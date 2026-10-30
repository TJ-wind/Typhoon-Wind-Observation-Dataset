# 利奇马（2019）

[English](README.md) | [简体中文](README_zh.md)

本目录包含 8,935 个原始观测文件对应的 64 个小时观测 CSV，共 3,288,594 行。

所有 CSV 使用同一套 20 列。第一行是英文列名，缺项留空；字段顺序、含义和单位见 [CSV 列说明](../../README.md#列说明)。

## 数据目录

| `observations` 下的目录 | 日期范围 | 小时 CSV |
|---|---|---:|
| `radial_filtered` | 2019-08-09 至 2019-08-10 | 16 |
| `radial_unfiltered` | 2019-08-09 至 2019-08-10 | 16 |
| `reconstructed_filtered` | 2019-08-09 至 2019-08-10 | 16 |
| `reconstructed_unfiltered` | 2019-08-09 至 2019-08-10 | 16 |

## 读取一个文件

在数据库根目录运行：

```matlab
data = main_function('data/2019_09_Lekima/observations/reconstructed_unfiltered/2019-08-09/2019-08-09_10.csv');
```

需要画图时，把根目录 `main.m` 中的文件路径改为上述路径，运行即可。

`reconstructed_*` 是重建风速，`radial_*` 是径向风速；`filtered` 与 `unfiltered` 对应原筛选版与未筛选版。绘制径向风时，将 `main.m` 中的 `quantity` 设为 `'radial_wind_speed_mps'`。

[返回数据库](../../README.md#简体中文)
