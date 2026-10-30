# Typhoon wind observations

[English](README.md) | [简体中文](README_zh.md)

Doppler lidar observations from eight typhoons during 2017–2024, including wind profiles, wind direction and time series.

## Data

Observation CSVs are grouped by typhoon, data type, date and hour. All use the same 20 columns; missing values are blank. See [column meanings, units and quality flags](docs/CSV_COLUMNS.md).

| Year | Typhoon |
|---|---|
| 2017 | [Khanun](data/2017_20_Khanun/README.md) |
| 2018 | [Mangkhut](data/2018_22_Mangkhut/README.md) |
| 2019 | [Lekima](data/2019_09_Lekima/README.md) |
| 2020 | [Hagupit](data/2020_04_Hagupit/README.md) |
| 2020 | [Higos](data/2020_07_Higos/README.md) |
| 2022 | [Ma-on](data/2022_09_Maon/README.md) |
| 2022 | [Muifa](data/2022_12_Muifa/README.md) |
| 2024 | [Kong-rey](data/2024_21_Kongrey/README.md) |

## Read and plot

Set the repository root as MATLAB's current folder. Open [main.m](main.m), edit `filename`, then run. This gives a table named `data` and one wind profile plot.

To read one file directly:

```matlab
filename = fullfile('data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');
data = main_function(filename);
```

For a radial-wind CSV, set `quantity = 'radial_wind_speed_mps'` in `main.m`.

## Paper figures

Wind figures read the observation CSVs directly from `data/` and calculate statistics when run. Place the complete observation data in that folder; map files and the instrument photograph are in `paper_figures/assets/`.

Run [plot_paper_figures.m](plot_paper_figures.m) to generate nine figures in `paper_figures/output`. Set `figureNumbers` to select figures. See the [figure descriptions](paper_figures/README.md). Tested with MATLAB R2026a.

Contact: Wei Cui (崔巍) — [cuiwei@tongji.edu.cn](mailto:cuiwei@tongji.edu.cn)
