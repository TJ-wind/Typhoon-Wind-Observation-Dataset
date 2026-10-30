# Typhoon wind observations · 台风风观测数据库

[English](#english) | [简体中文](#简体中文)

## English

Doppler lidar measurements collected by the Tongji University Wind Engineering Team during eight typhoons (2017–2024), including wind profiles, wind direction and wind speed time series.

### Data

Observation CSVs are grouped by typhoon, data type, date and hour. All use the same 20 columns; missing values are blank. See [column meanings, units and quality flags](#csv-columns).

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

#### Browse and download the complete data

The complete [data/ directory](data/) contains all 1,071 observation CSV files and 16 documentation files, with the original typhoon, data-type, date and hour folders. Browse individual files using the links above, or clone the repository to obtain the directory.

### Read and plot

Set the repository root as MATLAB's current folder. Open [main.m](main.m), edit `filename`, then run. This gives a table named `data` and one wind profile plot.

To read one file directly:

```matlab
filename = fullfile('data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');
data = main_function(filename);
```

For a radial-wind CSV, set `quantity = 'radial_wind_speed_mps'` in `main.m`.

### CSV columns

<details>
<summary>20 column definitions, time and quality flags</summary>

All observation CSVs use the same 20 columns in the order below. The first row contains column names; data start on the second row. Files use UTF-8, commas and a decimal point (`.`). Missing or unavailable fields are blank. MATLAB reads blank numeric fields as `NaN`.

| No. | Column | Meaning | Unit |
|---:|---|---|---|
| 1 | `timestamp` | Recorded time, formatted as yyyy-MM-dd HH:mm:ss.SSSSSS. | Source clock |
| 2 | `height_m` | Vertical height above the lidar. Calculated as range × sin(elevation) for source MAT and radial CSV data; taken from the native height field for reconstructed CSV and NC data. | m |
| 3 | `range_m` | Slant distance along the laser beam. | m |
| 4 | `azimuth_deg` | Beam azimuth, clockwise from north (0°). | deg |
| 5 | `elevation_deg` | Beam elevation above horizontal. | deg |
| 6 | `horizontal_wind_speed_mps` | Horizontal speed. Calculated from the two horizontal components for source MAT data; native values retained for reconstructed CSV and NC data. | m/s |
| 7 | `vertical_wind_speed_mps` | Vertical speed, positive upward. | m/s |
| 8 | `wind_direction_deg` | Horizontal wind direction. Native directions retained for reconstructed products; wind-from direction calculated from the horizontal components for source MAT data. | deg |
| 9 | `radial_wind_speed_mps` | Signed speed along the beam. Source sign conventions are listed below. | m/s |
| 10 | `eastward_wind_mps` | Horizontal component, positive eastward. | m/s |
| 11 | `northward_wind_mps` | Horizontal component, positive northward. | m/s |
| 12 | `cnr_db` | Carrier-to-noise ratio. | dB |
| 13 | `wind_confidence_index_pct` | Confidence index for reconstructed wind. | % |
| 14 | `radial_confidence_index_pct` | Confidence index for radial wind. | % |
| 15 | `wind_status` | Reconstructed-wind quality flag: 1 = accepted, 0 = rejected. The native NC missing flag 255 is retained. | Flag |
| 16 | `radial_status` | Radial-wind quality flag: 1 = accepted, 0 = rejected. The native NC missing flag 255 is retained. | Flag |
| 17 | `radial_dispersion_mps` | Dispersion Radial Wind Speed in the source radial CSV. | m/s |
| 18 | `radial_mean_error_native` | Mean Error in the source radial CSV, in its original unit. | Source unit |
| 19 | `doppler_spectrum_width_mps` | Doppler spectrum width in the source NC. | m/s |
| 20 | `doppler_spectrum_mean_error_pct` | Doppler spectrum mean error in the source NC. | % |

#### Rows and time

Each row records one measurement height at one time. Rows at the same time form a profile; scanned records also contain beam azimuth and elevation. Timestamps retain the source clock. Kong-rey NC times are UTC; the other events retain their recorded clocks. Conversion standardizes the text format.

Each hourly CSV groups source scans by their starting hour. A scan crossing an hour boundary stays in its starting-hour file, with actual sampling times retained in each row. Source MAT profiles are grouped by their individual record times.

#### Wind components and quality

In the source MAT files, `MatWindX` is positive southward and `MatWindY` westward. Thus eastward wind is `-MatWindY`, northward wind is `-MatWindX`, and horizontal speed is `hypot(MatWindX, MatWindY)`. For reconstructed CSV and NC data, the components are `eastward = -U*sind(direction)` and `northward = -U*cosd(direction)`, using MATLAB's degree-based functions.

Radial speeds retain their source signs: positive toward the instrument for Lekima and Hagupit; positive away for Ma-on, Muifa and Kong-rey. Higos retains its native sign. Higos horizontal speeds in `derived/horizontal_profiles` use a least-squares reconstruction from four inclined beams at their recorded angles. Status 1 requires all four beam speeds to be finite and all four source flags to be 1. These files populate horizontal speed, height, time and quality flag.

All observation rows and source quality flags are retained. `main.m` plots finite values with status 1 or a blank status field, as in the source MAT products.

</details>

### Paper figures

Run [plot_paper_figures.m](plot_paper_figures.m) to generate nine figures in `paper_figures/output`. Set `figureNumbers` to select figures. Tested with MATLAB R2026a.

<details>
<summary>Figure numbers, data sources and statistical methods</summary>

Use `figureNumbers = 3:9` for the seven wind figures below. Figure 1 is the map; Figure 2 shows the instrument and scanning geometry.

| `figureNumbers` | Figure | Observation source or asset |
|---:|---|---|
| 3 | Khanun, Mangkhut, Lekima, and Hagupit histories | Khanun/Mangkhut: `component_profiles`; Lekima: `reconstructed_unfiltered`; Hagupit: `reconstructed` |
| 4 | Higos, Ma-on, Muifa, and Kong-rey histories | Higos: `derived/horizontal_profiles`; Ma-on: `storm_subset`; Muifa/Kong-rey: `reconstructed` |
| 5 | Hagupit wind-speed passage, direction, and availability | Hagupit: `reconstructed` |
| 6 | Hagupit time-height fields | Hagupit: `reconstructed` |
| 7 | Representative vertical profiles | Hagupit: `reconstructed` |
| 8 | Higos sampling positions and Hagupit horizontal wind path | Higos: `radial`; Hagupit: `reconstructed` |
| 9 | 3D wind-vector profiles and direction with height | Hagupit: `reconstructed` |

Observation folders are under `data/<event>/observations`; Higos horizontal speeds are under `data/2020_07_Higos/derived/horizontal_profiles`. Map assets are `best_tracks.csv`, `observation_coordinates.csv`, and `map_geometry.csv`. All figure text uses Microsoft YaHei: 8 pt text and 9.5 pt bold panel titles.

#### Wind histories

The series use calendar-aligned 10-minute averages of accepted scalar horizontal speeds. The actual levels near 100 and 300 m are approximately 96.6/289.8 m for Khanun and Mangkhut, 90/290 m for Ma-on and Muifa, and 100/300 m for Lekima, Hagupit, and Kong-rey. Higos uses the mean height of the four inclined gates.

`accepted_count` counts accepted records, `finite_count` finite source values, and `candidate_count` available source rows. The retained fraction uses `candidate_count` for Khanun and Mangkhut and `finite_count` for the other events. Open circles identify intervals with fewer than five accepted records or a retained fraction below 0.8. The Higos history displays intervals with at least five accepted scans and includes a third level near 200 m.

#### Hagupit case

The case figures use native 10 m height spacing. Quality selection requires at least five accepted records, an accepted fraction of at least 0.8, a finite count of at least half the median count over 50–300 m, and paired wind directions for at least 80% of finite records. Gaps remain in the plotted profiles and histories.

The periods on 3 August 2020, using the recorded clock, are P: 15:10–15:40, A: 15:50–16:00, B: 17:40–17:50, and C: 18:40–18:50. For the supplied observations, the 100 m mean speeds for A, B, and C are approximately 30.56, 3.69, and 32.50 m/s. Scalar speed, mean eastward/northward components, circular mean direction, and the direction of the mean vector are calculated separately. The power-law fit uses the qualified P profile from 50 to 300 m and is anchored at its 100 m speed.

</details>

Contact: Wei Cui (崔巍) — [cuiwei@tongji.edu.cn](mailto:cuiwei@tongji.edu.cn)

## 简体中文

[English](#english)

同济大学风工程团队采集的多普勒激光雷达实测数据，覆盖 2017—2024 年的 8 场台风，包括风剖面、风向和风速时程。

### 数据

观测 CSV 按“台风 / 数据类型 / 日期 / 小时”存放，统一使用 20 列，缺失项留空。详见[各列含义、单位和质量标记](#列说明)。

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

#### 浏览与下载完整数据

完整的 [data/ 目录](data/) 包含全部 1,071 个观测 CSV 和 16 个说明文件，保留“台风 / 数据类型 / 日期 / 小时”的原始目录结构。可通过上表链接浏览各场台风的文件，也可克隆仓库获得完整目录。

### 读取与绘图

在 MATLAB 中将仓库根目录设为当前文件夹。打开 [main.m](main.m)，修改 `filename`，运行后得到变量 `data` 和一张风剖面图。

单独读取一个文件：

```matlab
filename = fullfile('data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');
data = main_function(filename);
```

读取径向风数据时，将 `main.m` 中的 `quantity` 改为 `'radial_wind_speed_mps'`。

### 列说明

<details>
<summary>展开 20 列定义、时间和质量标记</summary>

全部观测 CSV 使用以下 20 列，列名和顺序完全相同。第一行是英文列名，从第二行开始是数据。文件采用 UTF-8 编码、英文逗号分隔、小数点为 `.`。缺测值和该产品没有提供的字段留空，空白数值字段在 MATLAB 中读为 `NaN`。

| 列号 | 列名 | 含义 | 单位 |
|---:|---|---|---|
| 1 | `timestamp` | 记录时间，统一写为 yyyy-MM-dd HH:mm:ss.SSSSSS。 | 原文件时钟 |
| 2 | `height_m` | 距离激光雷达的垂直高度。MAT 和径向 CSV 按 range × sin(elevation) 计算；重建 CSV 和 NC 使用原高度字段。 | m |
| 3 | `range_m` | 沿激光束的斜距。 | m |
| 4 | `azimuth_deg` | 激光束方位角，北为 0°，向东顺时针增加。 | deg |
| 5 | `elevation_deg` | 激光束相对水平面的仰角。 | deg |
| 6 | `horizontal_wind_speed_mps` | 水平风速。MAT 由两个水平分量的平方和开方得到；重建 CSV 和 NC 保留原值。 | m/s |
| 7 | `vertical_wind_speed_mps` | 竖向风速，向上为正。 | m/s |
| 8 | `wind_direction_deg` | 水平风向。重建产品保留原风向；MAT 按水平分量计算来流方向。 | deg |
| 9 | `radial_wind_speed_mps` | 原文件的有符号径向风速，沿激光束方向。符号约定见下文。 | m/s |
| 10 | `eastward_wind_mps` | 东向水平风分量，向东为正。 | m/s |
| 11 | `northward_wind_mps` | 北向水平风分量，向北为正。 | m/s |
| 12 | `cnr_db` | 载噪比。 | dB |
| 13 | `wind_confidence_index_pct` | 重建风速的置信指数。 | % |
| 14 | `radial_confidence_index_pct` | 径向风速的置信指数。 | % |
| 15 | `wind_status` | 重建风速质量标记：1 为通过，0 为未通过；NC 原缺测标记 255 保留。 | 标记 |
| 16 | `radial_status` | 径向风速质量标记：1 为通过，0 为未通过；NC 原缺测标记 255 保留。 | 标记 |
| 17 | `radial_dispersion_mps` | 径向 CSV 中的 Dispersion Radial Wind Speed。 | m/s |
| 18 | `radial_mean_error_native` | 径向 CSV 中的 Mean Error，按原单位保存。 | 原单位 |
| 19 | `doppler_spectrum_width_mps` | NC 中的多普勒谱宽。 | m/s |
| 20 | `doppler_spectrum_mean_error_pct` | NC 中的多普勒谱平均误差。 | % |

#### 时间和一行数据

每行是一条记录在一个测量高度上的数据。同一时刻的多行组成一个剖面；扫描数据同时记录该束的方位角和仰角。时间保留原文件时钟。康妮 NC 的原时间是 UTC，其余事件沿用原记录时钟；转换过程统一文本格式。

每小时一份 CSV，按原扫描文件的起始小时归档。跨小时的完整扫描保存在开始小时文件中，行内时间仍是实际采样时刻。MAT 剖面按各自的记录时刻分到对应小时。

#### 风分量和质量标记

MAT 的原 `MatWindX` 正方向为向南，`MatWindY` 正方向为向西，因此东向风为 `-MatWindY`，北向风为 `-MatWindX`。水平风速为 `hypot(MatWindX, MatWindY)`。重建 CSV 和 NC 的水平分量按 `eastward = -U*sind(direction)`、`northward = -U*cosd(direction)` 计算，使用 MATLAB 中以度为单位的三角函数。

径向风速保留源文件的符号：利奇马、黑格比为朝向仪器取正；马鞍、梅花、康妮为离开仪器取正；海高斯保留其源符号。海高斯 `derived/horizontal_profiles` 中的水平风速由四束倾斜光束按实际扫描角度进行最小二乘重建，质量标记为 1 时四束均为有限值且源质量标记均为 1。该目录只填写重建水平风速、对应高度、时间及质量标记。

全部观测行及原质量标记保留。`main.m` 绘图时使用质量标记为 1 或标记为空的有限值；MAT 原数据属于标记为空的情况。

</details>

### 论文绘图

运行 [plot_paper_figures.m](plot_paper_figures.m) 生成 9 张图，保存至 `paper_figures/output`。修改 `figureNumbers` 可选择出图范围。代码已在 MATLAB R2026a 中运行验证。

<details>
<summary>展开图件编号、数据来源和统计方法</summary>

下表为七张风观测图，选择 `figureNumbers = 3:9` 即可绘制。编号 1 为地图，2 为仪器照片与扫描示意图。

| `figureNumbers` | 图件 | 观测数据或素材来源 |
|---:|---|---|
| 3 | 卡努、山竹、利奇马、黑格比风速时程 | 卡努、山竹：`component_profiles`；利奇马：`reconstructed_unfiltered`；黑格比：`reconstructed` |
| 4 | 海高斯、马鞍、梅花、康妮风速时程 | 海高斯：`derived/horizontal_profiles`；马鞍：`storm_subset`；梅花、康妮：`reconstructed` |
| 5 | 黑格比风速过程、风向与数据可用率 | 黑格比：`reconstructed` |
| 6 | 黑格比时间—高度分布 | 黑格比：`reconstructed` |
| 7 | 典型竖向风剖面 | 黑格比：`reconstructed` |
| 8 | 海高斯采样位置与黑格比水平风矢量轨迹 | 海高斯：`radial`；黑格比：`reconstructed` |
| 9 | 三维风矢量剖面与风向随高度的变化 | 黑格比：`reconstructed` |

观测目录位于 `data/<event>/observations`，海高斯水平风速位于 `data/2020_07_Higos/derived/horizontal_profiles`。地图素材为 `best_tracks.csv`、`observation_coordinates.csv` 和 `map_geometry.csv`。所有图件采用微软雅黑，正文标注为 8 pt，子图标题为 9.5 pt 加粗。

#### 风速时程

时程按钟表时间对齐，每 10 分钟计算通过质量筛选的水平风速标量平均值。100 m 和 300 m 附近的实际高度分别为：卡努、山竹约 96.6/289.8 m；马鞍、梅花为 90/290 m；利奇马、黑格比、康妮为 100/300 m。海高斯采用四束倾斜光束对应测距的平均高度。

`accepted_count` 是通过质量筛选的记录数，`finite_count` 是源数据中的有限值数量，`candidate_count` 是可用源数据行数。保留比例的分母在卡努和山竹中采用 `candidate_count`，其余事件采用 `finite_count`。空心圆标记通过筛选的记录少于 5 条或保留比例低于 0.8 的时段。海高斯时程展示至少有 5 次有效扫描的时段，并增加约 200 m 高度的曲线。

#### 黑格比案例

案例图保留原始 10 m 高度间隔。质量筛选要求：通过筛选的记录至少 5 条、通过比例至少 0.8、有限值数量至少达到 50–300 m 范围内数量中位数的一半，且至少 80% 的有限记录具有配对风向。剖面和时程保留数据间断。

各图采用 2020 年 8 月 3 日的原记录时钟：P 为 15:10–15:40，A 为 15:50–16:00，B 为 17:40–17:50，C 为 18:40–18:50。按当前观测数据计算，A、B、C 时段在 100 m 高度的平均风速约为 30.56、3.69 和 32.50 m/s。风速标量、东向和北向平均分量、风向圆周平均值、平均风矢量方向分别计算。幂律拟合采用 P 时段 50–300 m 范围内通过筛选的剖面，并以其 100 m 风速为基准。

</details>

联系人：崔巍（Wei Cui）— [cuiwei@tongji.edu.cn](mailto:cuiwei@tongji.edu.cn)
