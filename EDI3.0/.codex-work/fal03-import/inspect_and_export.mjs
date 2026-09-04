import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const source = 'D:/Aria/Aria3EDI/AriaEDI/EDI3.0/.codex-work/fal03-import/FAL03_01.xlsx';
const input = await FileBlob.load(source);
const workbook = await SpreadsheetFile.importXlsx(input);
const sheet = workbook.worksheets.getItemAt(0);
const used = sheet.getUsedRange(true);
const values = used.values;

const month = { Jan: 0, Feb: 1, Mar: 2, Apr: 3, May: 4, Jun: 5, Jul: 6, Aug: 7, Sep: 8, Oct: 9, Nov: 10, Dec: 11 };
const excelSerial = (text) => {
  if (!text) return null;
  const m = /^(\d{2})-([A-Za-z]{3})-(\d{2})$/.exec(String(text));
  if (!m) throw new Error('Unexpected date: ' + text);
  return Date.UTC(2000 + Number(m[3]), month[m[2]], Number(m[1])) / 86400000 + 25569;
};
const timeFraction = (text) => {
  if (!text) return null;
  const m = /^(\d{2}):(\d{2}):(\d{2})$/.exec(String(text));
  if (!m) throw new Error('Unexpected time: ' + text);
  return (Number(m[1]) * 3600 + Number(m[2]) * 60 + Number(m[3])) / 86400;
};

if (values[0].length !== 7) throw new Error('Expected 7 columns, found ' + values[0].length);
const normalized = values.slice(1).map((row) => [
  row[0] == null ? null : String(row[0]),
  row[1] == null ? null : String(row[1]),
  row[2] == null ? null : String(row[2]),
  row[3] == null ? null : String(row[3]),
  row[4] == null ? null : String(row[4]),
  excelSerial(row[5]),
  timeFraction(row[6]),
]);

console.log(JSON.stringify({
  sheetName: sheet.name,
  usedAddress: used.address,
  headers: values[0],
  rowCount: normalized.length,
  firstRows: normalized.slice(0, 3),
  lastRows: normalized.slice(-3),
  rows: normalized,
}));
