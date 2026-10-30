# Higos (2020)

[English](README.md) | [简体中文](README_zh.md)

10 hourly observation CSVs from 1,295 source observation files, containing 1,677,025 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `radial` | 2020-08-18 to 2020-08-19 | 10 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2020_07_Higos/observations/radial/2020-08-18/2020-08-18_17.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

`observations/radial` contains the original radial wind speed (column 9). Set `quantity = 'radial_wind_speed_mps'` in `main.m` to plot it. `derived/horizontal_profiles` contains horizontal wind speed reconstructed from four inclined beams (column 6, `horizontal_wind_speed_mps`). Both folders use the same 20 columns; the reconstruction method is described in the column guide.

[Back to database](../../README.md#english)
