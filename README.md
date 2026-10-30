# Typhoon wind observations · 台风风观测数据库

[English](#english) | [简体中文](#简体中文)

## English

Doppler lidar measurements collected by the Tongji University Wind Engineering Team during eight typhoons (2017–2024), including wind profiles, wind direction and wind speed time series.

### Data

Observation CSVs are grouped by typhoon, data type, date and hour. All use the same 20 columns; missing values are blank. See [column meanings, units and quality flags](CSV_COLUMNS.md).

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

### Read and plot

Set the repository root as MATLAB's current folder. Open [main.m](main.m), edit `filename`, then run. This gives a table named `data` and one wind profile plot.

To read one file directly:

```matlab
filename = fullfile('data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');
data = main_function(filename);
```

For a radial-wind CSV, set `quantity = 'radial_wind_speed_mps'` in `main.m`.

### Paper figures

Wind figures read the observation CSVs directly from `data/` and calculate statistics when run. 

Run [plot_paper_figures.m](plot_paper_figures.m) to generate nine figures in `paper_figures/output`. Set `figureNumbers` to select figures. See the [figure descriptions](figure_README.md). Tested with MATLAB R2026a.

Contact: Wei Cui (崔巍) — [cuiwei@tongji.edu.cn](mailto:cuiwei@tongji.edu.cn)

## 简体中文

[English](#english)

同济大学风工程团队采集的多普勒激光雷达实测数据，覆盖 2017—2024 年的 8 场台风，包括风剖面、风向和风速时程。

### 数据

观测 CSV 按“台风 / 数据类型 / 日期 / 小时”存放，统一使用 20 列，缺失项留空。详见[各列含义、单位和质量标记](CSV_COLUMNS_zh.md)。

| 年份 | 台风 |
|---|---|
| 2017 | [卡努](data/2017_20_Khanun/README_zh.md) |
| 2018 | [山竹](data/2018_22_Mangkhut/README_zh.md) |
| 2019 | [利奇马](data/2019_09_Lekima/README_zh.md) |
| 2020 | [黑格比](data/2020_04_Hagupit/README_zh.md) |
| 2020 | [海高斯](data/2020_07_Higos/README_zh.md) |
| 2022 | [马鞍](data/2022_09_Maon/README_zh.md) |
| 2022 | [梅花](data/2022_12_Muifa/README_zh.md) |
| 2024 | [康妮](data/2024_21_Kongrey/README_zh.md) |

### 读取与绘图

在 MATLAB 中将仓库根目录设为当前文件夹。打开 [main.m](main.m)，修改 `filename`，运行后得到变量 `data` 和一张风剖面图。

单独读取一个文件：

```matlab
filename = fullfile('data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');
data = main_function(filename);
```

读取径向风数据时，将 `main.m` 中的 `quantity` 改为 `'radial_wind_speed_mps'`。

### 论文绘图

风观测图直接读取 `data/` 中的 CSV，并在运行时计算统计量。

运行 [plot_paper_figures.m](plot_paper_figures.m) 生成 9 张图，保存至 `paper_figures/output`。修改 `figureNumbers` 可选择出图范围，详见[绘图说明](figure_README_zh.md)。代码已在 MATLAB R2026a 中运行验证。

联系人：崔巍（Wei Cui）— [cuiwei@tongji.edu.cn](mailto:cuiwei@tongji.edu.cn)
