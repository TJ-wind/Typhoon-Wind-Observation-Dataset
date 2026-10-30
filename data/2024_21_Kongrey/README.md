# Kong-rey (2024)

[English](README.md) | [简体中文](README_zh.md)

60 hourly observation CSVs from 14,261 source observation files, containing 18,460,484 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `reconstructed` | 2024-10-31 to 2024-11-02 | 60 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2024_21_Kongrey/observations/reconstructed/2024-10-31/2024-10-31_11.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

[Back to database](../../README.md#english)
