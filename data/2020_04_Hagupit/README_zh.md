# 黑格比（2020）

[English](README.md) | [简体中文](README_zh.md)

本目录包含 1,800 个原始观测文件对应的 12 个小时观测 CSV，共 2,331,000 行。

所有 CSV 使用同一套 20 列。第一行是英文列名，缺项留空；字段顺序、含义和单位见 [CSV 列说明](../../README.md#列说明)。

## 数据目录

| `observations` 下的目录 | 日期范围 | 小时 CSV |
|---|---|---:|
| `analysis_subset` | 2020-08-03 | 2 |
| `reconstructed` | 2020-08-03 | 10 |

## 读取一个文件

在数据库根目录运行：

```matlab
data = main_function('data/2020_04_Hagupit/observations/reconstructed/2020-08-03/2020-08-03_10.csv');
```

需要画图时，把根目录 `main.m` 中的文件路径改为上述路径，运行即可。

`reconstructed` 是主观测序列，`analysis_subset` 是原目录另外保存的分析子集。两者分别保留。

[返回数据库](../../README.md#简体中文)
