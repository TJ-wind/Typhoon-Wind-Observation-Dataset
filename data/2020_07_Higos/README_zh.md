# 海高斯（2020）

[English](README.md) | [简体中文](README_zh.md)

本目录包含 1,295 个原始观测文件对应的 10 个小时观测 CSV，共 1,677,025 行。

所有 CSV 使用同一套 20 列。第一行是英文列名，缺项留空；字段顺序、含义和单位见 [CSV 列说明](../../README.md#列说明)。

## 数据目录

| `observations` 下的目录 | 日期范围 | 小时 CSV |
|---|---|---:|
| `radial` | 2020-08-18 至 2020-08-19 | 10 |

## 读取一个文件

在数据库根目录运行：

```matlab
data = main_function('data/2020_07_Higos/observations/radial/2020-08-18/2020-08-18_17.csv');
```

需要画图时，把根目录 `main.m` 中的文件路径改为上述路径，运行即可。

`observations/radial` 保存原径向风速（第 9 列）。绘图时，将 `main.m` 中的 `quantity` 设为 `'radial_wind_speed_mps'`。`derived/horizontal_profiles` 保存四束倾斜光束重建的水平风速（第 6 列 `horizontal_wind_speed_mps`）。两个目录使用相同的 20 列；重建方法见统一列说明。

[返回数据库](../../README.md#简体中文)
