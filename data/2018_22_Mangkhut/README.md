# Mangkhut (2018)

[English](README.md) | [简体中文](README_zh.md)

50 hourly observation CSVs from 1 source observation file, containing 571,081 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `component_profiles` | 2018-09-15 to 2018-09-17 | 50 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2018_22_Mangkhut/observations/component_profiles/2018-09-15/2018-09-15_04.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

[Back to database](../../README.md#english)
