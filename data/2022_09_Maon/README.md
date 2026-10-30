# Ma-on (2022)

[English](README.md) | [简体中文](README_zh.md)

819 hourly observation CSVs from 172,210 source observation files, containing 43,052,500 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `continuous` | 2022-07-29 to 2022-08-31 | 796 |
| `storm_subset` | 2022-08-24 to 2022-08-25 | 23 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2022_09_Maon/observations/storm_subset/2022-08-24/2022-08-24_08.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

`continuous` contains the extended observation record. `storm_subset` contains the typhoon period stored separately in the source archive.

[Back to database](../../README.md#english)
