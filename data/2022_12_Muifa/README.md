# Muifa (2022)

[English](README.md) | [简体中文](README_zh.md)

30 hourly observation CSVs from 6,105 source observation files, containing 1,526,250 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `reconstructed` | 2022-09-14 to 2022-09-15 | 30 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2022_12_Muifa/observations/reconstructed/2022-09-14/2022-09-14_02.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

[Back to database](../../README.md#english)
