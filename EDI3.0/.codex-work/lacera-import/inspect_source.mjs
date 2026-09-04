import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const source = 'D:/Aria/Aria3EDI/AriaEDI/EDI3.0/.codex-work/lacera-import/LAC99_06.xlsx';
const input = await FileBlob.load(source);
const workbook = await SpreadsheetFile.importXlsx(input);

const overview = await workbook.inspect({
  kind: 'workbook,sheet,table,region',
  maxChars: 12000,
  tableMaxRows: 20,
  tableMaxCols: 30,
  tableMaxCellChars: 200,
});
console.log(overview.ndjson);

for (let i = 0; i < workbook.worksheets.items.length; i++) {
  const sheet = workbook.worksheets.getItemAt(i);
  const used = sheet.getUsedRange(true);
  console.log(JSON.stringify({
    sheetIndex: i,
    sheetName: sheet.name,
    usedAddress: used?.address ?? null,
    values: used?.values ?? [],
    formulas: used?.formulas ?? [],
  }));
}
