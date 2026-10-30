# Hagupit (2020)

[English](README.md) | [简体中文](README_zh.md)

12 hourly observation CSVs from 1,800 source observation files, containing 2,331,000 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `analysis_subset` | 2020-08-03 | 2 |
| `reconstructed` | 2020-08-03 | 10 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2020_04_Hagupit/observations/reconstructed/2020-08-03/2020-08-03_10.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

`reconstructed` is the main observation series. `analysis_subset` is the analysis subset stored separately in the source archive. Both are retained in separate folders.

[Back to database](../../README.md#english)
