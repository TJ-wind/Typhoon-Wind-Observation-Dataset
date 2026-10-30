# Khanun (2017)

[English](README.md) | [简体中文](README_zh.md)

16 hourly observation CSVs from 1 source observation file, containing 357,732 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `component_profiles` | 2017-10-14 to 2017-10-15 | 16 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2017_20_Khanun/observations/component_profiles/2017-10-14/2017-10-14_09.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

[Back to database](../../README.md#english)
