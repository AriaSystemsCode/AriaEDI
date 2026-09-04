# EDINOTE SQL migration design

Date: 2026-08-28  
Status: Proposed design; no application code or data changes performed.

## 1. Objective and recommendation

Move the customer's EDINOTE storage from VFP DBF/FPT to the existing company SQL database, while retaining small, indexed VFP cursors for existing processing logic. Reduce local table growth and the operational need to purge the DBF weekly.

Reuse the existing SQL connection, cursor, and transaction infrastructure. Add a narrow EDINOTE access boundary rather than replacing the general data layer. Keep NOTEPAD and order tables in their current storage in this phase.

Migrate EDINOTE as a whole for an enabled company. Do not migrate only PO notes while allowing other processes to keep writing the same logical table to DBF. Weekly retention remains a separate business decision, not a prerequisite for operating the SQL table.

## 2. Evidence from this repository

Source paths below are relative to the EDI3.0 project. VCT/SCT references are embedded source in VFP memo containers; search line numbers are not stable method line numbers. The library contains multiple class records/variants. Confirm the compiled customer version and active class records before implementation; a reference in the inventory does not prove the customer executes it.

| Source | Observed behavior | Design consequence |
|---|---|---|
| Classes/EDIPO.VCX and EdiPO.VCT, ediprocesspo.ProcessPO | Builds type B and PADR(partner + transaction type + sequence, 20); reads EDINOTE, scatters memo fields, changes the destination key to T + order and inserts into NOTEPAD; later reverts EDINOTE | Preserve the lookup and temporary-buffer semantics; a processing note is not automatically a permanent SQL write |
| Classes/edi.vct, NOTE mapping branch | Seeks EDINOTE, appends if missing and adds text plus carriage returns to MNOTES | SQL-backed cursor must exist before mapping executes, including when no stored note exists |
| Classes/EdiPO.VCT, DeleteTransaction variants | Blanks matching Type/Key fields, then deletes blank-key rows and calls TABLEUPDATE | Replace blank-before-delete behavior in SQL mode; it can destroy the identity needed by a SQL updater |
| PRGs/ediglobl.prg:1611, lfOpen_SQL_File | Calls RemoteCompanyData.sqlrun; supports alias, index expression and tag; sets buffering to 5 | Reuse indexed cursor conventions |
| Same helper | Requires isRemoteComp, returns a string result, calls SQLCOMMIT on a returned handle | Wrap/normalize results and verify transaction ownership; do not use as a generic transaction-neutral function |
| Classes/edi.vct, Open_SQL_File / SQL_Update | SQL cursor helpers and modified-row insert/update/delete implementation; SQL primary-key predicates use individual fields | Reuse after verifying method availability, dependencies and provider behavior |
| Same library | BeginTran, CommitTran and RollBackTran usage | Use explicit ownership of SQL write transactions |
| DBFS/99/EDINOTE.DBF header and translator EDINOTE.xml | Six fields; KEY is C(40), no timestamp | Preserve full key width; existing rows cannot be aged directly from EDINOTE alone |

### Change inventory

| Area | Candidate files to adapt or verify |
|---|---|
| PO processing and related variants | Classes/EdiPO.VCT, EdiAN.VCT, POS.VCT; verify XMLMAPPINGS variants and deployed builds |
| Mapping and receiving commits | Classes/edi.vct |
| Other note readers/writers | Classes/EDITX.VCT, EDIOR.VCT, EDIST.VCT, EDIOW.VCT, EDICD.VCT |
| Background/direct table opening | Classes/EDISCHDL.vct, EDI_DLL.VCT |
| Main UI, data environments and alternate aliases | Screens/ebmain.SCT, including REMEDINOTE; Screens/EB/EBCRDRAJ.SCT, EB/eblocaad.SCT, nc/ebautsr.SCT |
| Purge and note UI | Screens/EBZAP.SCT; PRGs/SY/NOTEPAD.PRG, including table/index identity assumptions |
| .NET translators | Aria Translators X12Translator and CSVTranslator, BBC CSVTranslator, FREEWAY: ReceiveFile.cs and generated VFPTables.cs |

The .NET receivers have direct EDINOTE.Delete calls through AriaConnection.DbfsConnection. They must follow the same company storage setting. Do not assume changing the VFP class covers them. Generated data classes and their generation source must remain consistent.

Also review customer mapping expressions and data-dictionary metadata for indirect access, aliases and dynamically constructed table names. This inventory is a repository baseline, not certification of customer-specific mappings.

## 3. Target storage and schema

Use one company's existing SQL database through its configured connection. If deployment instead shares a database across companies, require CompanyId in every key, query and uniqueness rule before proceeding.

| Existing field | Proposed SQL representation | Compatibility requirement |
|---|---|---|
| TYPE C(1) | char(1), not null | Preserve all types, not only B |
| KEY C(40) | char(40), not null | Preserve all 40 characters; quote the column identifier in SQL |
| CDESC C(35) | char(35), not null | Preserve blank values |
| MNOTES memo | varchar(max), not null, provisional | Must round-trip as a VFP memo with the deployed driver/code page; validate before final DDL |
| FLAG C(1) | char(1), not null | Preserve existing values |
| COWNER C(16) | char(16), not null | Preserve existing values |

Use explicit six-field projections in business cursors. Do not expose future SQL-only housekeeping fields to SCATTER/INSERT INTO NOTEPAD implicitly. Match existing empty-string and space behavior; do not introduce nulls into legacy expressions.

Proposed lookup index: TYPE, KEY. Proposed primary key: TYPE, KEY only if customer profiling proves it uniquely identifies every live row under the selected SQL collation. The updater's SQL key list would be separate fields, not the VFP expression Type + Key.

If duplicates or collation collisions exist, block that schema choice. Resolve the business identity with the owner or use a stable surrogate identifier with an explicitly tested cursor/updater design. Never silently drop or merge duplicates during migration.

Do not infer full-key equality from a short VFP SEEK. For each call site classify exact versus prefix matching, SET EXACT behavior, padding and index order. Preserve 20-character logical keys without truncating 40-character stored keys. Prefix readers must retrieve all matching candidates; exact writes/deletes must identify their intended full rows. Any prefix range query must be tested for wildcard characters and collation behavior.

## 4. EDINOTE access boundary

The following are proposed responsibilities, not functions implemented in this task:

| Operation | Contract |
|---|---|
| Open scope | Load only the current transaction's required rows into EDINOTE or a requested alternate alias; create the correct empty schema when no rows exist |
| Index and buffer | Establish Type + Key with the expected tag and buffer mode 5; retain six-field VFP types |
| Save scope | Persist intentional changes with explicit SQL transaction handling and checked results |
| Revert scope | Discard cursor edits without modifying committed SQL rows |
| Delete scope | Delete exact identified records without blanking their keys first |
| Close scope | Release owned cursors and restore the previous work area; do not close another caller's cursor |

DBF mode delegates to existing behavior. SQL mode uses existing remote data infrastructure. Preserve private data sessions, alias ownership, error propagation and index selection. Never replace or requery a dirty cursor without first following its caller's save/revert decision.

Avoid an unfiltered full-table fetch at startup. Interactive viewers may use a bounded scope or paging; batch work may prefetch a bounded set of transaction keys to avoid a remote request per mapped segment.

### Reuse restrictions

- lfOpen_SQL_File is suitable as a starting point for reads outside an owned write transaction. Its internal SQLCOMMIT must not commit unrelated work. If that cannot be guaranteed, use the lower-level existing executor with explicit connection ownership in the EDINOTE boundary.
- Normalize the helper's string return value and distinguish an empty result from a failed query. A failed query must never be treated as an absent note.
- SQL_Update is a class method with supporting methods/metadata dependencies; it is not proven to be available on every caller. Expose it through the established shared class/service location after verifying the deployed inheritance graph.
- Validate memo parameter binding, field quoting, primary-key discovery, modified-row tracking, commit failures and cursor cleanup using the actual customer runtime.
- Use bound parameters. Verify parameter visibility through helper call scopes. Do not concatenate partner keys or memo content into SQL text.
- Do not globally rewrite a shared helper as part of this change unless tests show it is required. Scope compatibility adjustments to EDINOTE where possible.

## 5. Processing and persistence behavior

### Receiving and mapping

Open the appropriate note scope before NOTE mappings execute. Preserve append order, carriage returns, descriptions, flags and owners. Save only at the existing receiving workflow's intended persistence boundary. Do not report successful receiving if required note persistence fails.

### PO processing

Load the PO scope before mapping/processing needs it. Allow existing SEEK, APPEND, REPLACE and SCATTER operations against the local cursor. Preserve the successful copy to NOTEPAD under T + order. Where the existing method calls TABLEREVERT on EDINOTE, discard those temporary modifications rather than unconditionally saving them to SQL.

Important: the earlier summary that EDINOTE merely supplies stored notes was incomplete. Mapping can also build notes in its buffered cursor. Preserve that distinction in implementation and tests.

### Delete and reprocess

Replace the SQL branch's blank-then-delete sequence with deletion by original stable identity. Include REMEDINOTE paths, non-PO transaction keys and .NET receiver deletion. Retrying a completed delete should not delete additional records. Reprocessing must not double-append note text or duplicate NOTEPAD rows.

### Concurrency and mixed storage failures

SQL transactions cover SQL writes only. Do not assume they roll back VFP NOTEPAD, order tables or EDILIBDT. Retain source notes until destination writes are confirmed. Record actionable failure context and provide reconciliation for interrupted operations; do not mark the transaction complete after a partial failure.

Serialize processing of the same company/transaction across foreground, scheduler and translator paths using a verified shared ownership mechanism. If existing locking does not cover every entry point, add that mechanism before enabling SQL. A uniqueness constraint alone does not prevent two sessions overwriting appended memo text. Separate transactions must remain independently processable.

Acceptance requires failure-injection tests at both SQL and DBF boundaries and demonstrated safe retry. Exactly-once behavior across stores is not claimed by this design without those controls.

## 6. Configuration and deployment

Propose a company-level EDINOTE storage setting, default DBF, with explicit SQL opt-in. This is a proposed setting, not an existing configuration field verified in the repository.

Use ActiveCompanyConStr and the current remote-company infrastructure where applicable. If the customer runs with isRemoteComp false, SQL enablement is blocked until a supported connection path is designed and tested. Do not change isRemoteComp globally just to move this table.

Once SQL is enabled, failure must stop the affected operation with a clear error. No automatic fallback to DBF and no unsynchronized dual writes. All active readers/writers must switch together. Deploy dormant support first, then migrate and enable during a maintenance window.

## 7. Migration and rollback

1. Confirm deployed executables/classes, custom mappings, connection/driver versions and all scheduled or external writers.
2. Profile the customer's live DBF/FPT: live/deleted counts, field definitions, memo sizes and encoding, duplicate full keys, prefix collisions and SQL collation collisions. Do not use the repository sample as proof of customer data quality.
3. Run the SQL cursor compatibility tests and approve final schema/key choice. Prepare backups and a rehearsed restore/reconciliation procedure.
4. Stop every writer, drain in-flight work, and back up DBF/FPT/CDX together. Record a cutover checkpoint.
5. Import all live rows without trimming keys, normalizing memo text or silently merging records. Preserve deleted records in the backup, not as active SQL rows.
6. Reconcile counts by TYPE, all field values and full memo contents using canonical encoding-aware checksums; resolve every difference. Preserve full values even if comparison ignores trailing spaces.
7. Enable SQL for all components; run receive/process/view/delete/reprocess smoke tests before reopening traffic. Monitor errors, query duration, rows fetched and memo payload volume.

Before any SQL writes occur, rollback can restore DBF configuration against the frozen source. After SQL writes occur, rollback requires stopping writers and exporting/reconciling the SQL changes into a validated DBF/FPT set first. Never simply point users at the stale pre-cutover DBF. If safe back-migration is not feasible, keep service stopped and repair forward.

## 8. Retention and purge

Do not create a weekly job as part of this design task. No retention duration has been approved.

EDINOTE has no date field, so age cannot be derived reliably from it alone. A future purge must use verified transaction lifecycle metadata or separately maintained creation/completion metadata. Imported rows with unknown age remain protected until ownership and age are established.

Eligibility must exclude active, failed/retryable and still-referenced notes and account for non-PO note types. EBZAP currently contains broad ZAP/PACK behavior and a type-1 preservation prompt; this must be explicitly redesigned for SQL, not translated into unconditional deletion.

First run a dry-run report grouped by note type, transaction ownership, age evidence and reason. After approval, use bounded, restartable deletion batches with audit counts and recovery arrangements. Schedule frequency and retention age are separate settings. Confirm required downstream notes were saved before deleting their source.

## 9. Verification and acceptance

| Test group | Required outcome |
|---|---|
| Schema and lookup | Six legacy fields preserved; full 40-character keys; blank/padded keys and prefix lookups return the intended rows |
| Memo round trip | Large memos, empty notes, quotes, carriage returns and customer characters preserved without truncation |
| Mapping and PO | Missing/existing notes, additive mappings, success/rejection and final revert match DBF baseline; NOTEPAD content and key are correct |
| Other consumers | Text, organization/location, credit/debit and other deployed note flows and screens work, including alternate aliases |
| Writes and deletes | Insert/update/delete/revert use the intended store; failed commits are surfaced; no blank-key mass deletion |
| Retry and concurrency | Same-transaction competition cannot lose or duplicate notes; interrupted mixed-store operations reconcile safely |
| Performance | Representative customer volume uses bounded indexed queries; fetched rows/memory do not grow with total table size; agree latency targets from a measured baseline |
| Configuration | DBF mode is unchanged; SQL outage does not fall back; unsupported non-remote configuration is rejected |
| Migration and rollback | Complete reconciliation passes; rollback after SQL writes is rehearsed |
| Purge | Dry run protects unresolved/active/non-PO records; batches are auditable and restartable |

No runtime SQL tests, customer data profiling, migration or performance measurements were performed for this document.

## 10. Implementation gates

Approve the direction now: company SQL storage plus scoped VFP cursors, reusing the existing infrastructure. Before coding is considered complete, resolve these gates:

- Customer deployment inventory and remote connection support.
- Full key identity, duplicate/prefix/collation rules and final SQL schema.
- Memo/updater compatibility and helper transaction ownership.
- Shared transaction-processing ownership and mixed-store recovery procedure.
- Coordinated migration, rollback rehearsal and acceptance results.

Retention approval can follow separately; do not delay correctness fixes or infer permission to delete data from the desire to reduce DBF growth.
