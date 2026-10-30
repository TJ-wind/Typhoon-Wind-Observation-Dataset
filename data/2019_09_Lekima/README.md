# Lekima (2019)

[English](README.md) | [简体中文](README_zh.md)

64 hourly observation CSVs from 8,935 source observation files, containing 3,288,594 rows.

All CSVs use the same 20 columns, with English headers in the first row and blanks for missing fields. Column order, meanings and units: [CSV column guide](../../README.md#csv-columns).

## Data folders

| Folder under `observations` | Dates | Hourly CSVs |
|---|---|---:|
| `radial_filtered` | 2019-08-09 to 2019-08-10 | 16 |
| `radial_unfiltered` | 2019-08-09 to 2019-08-10 | 16 |
| `reconstructed_filtered` | 2019-08-09 to 2019-08-10 | 16 |
| `reconstructed_unfiltered` | 2019-08-09 to 2019-08-10 | 16 |

## Read one file

Run from the database root:

```matlab
data = main_function('data/2019_09_Lekima/observations/reconstructed_unfiltered/2019-08-09/2019-08-09_10.csv');
```

To plot, set the file path in the root `main.m` to this path and run it.

`reconstructed_*` contains reconstructed winds; `radial_*` contains radial winds. `filtered` and `unfiltered` preserve the original filtered and unfiltered products. For radial files, set `quantity = 'radial_wind_speed_mps'` in `main.m`.

[Back to database](../../README.md#english)
