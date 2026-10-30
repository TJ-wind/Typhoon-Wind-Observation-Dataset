# 康妮（2024）

[English](README.md) | [简体中文](README_zh.md)

本目录包含 14,261 个原始观测文件对应的 60 个小时观测 CSV，共 18,460,484 行。

所有 CSV 使用同一套 20 列。第一行是英文列名，缺项留空；字段顺序、含义和单位见 [CSV 列说明](../../README.md#列说明)。

## 数据目录

| `observations` 下的目录 | 日期范围 | 小时 CSV |
|---|---|---:|
| `reconstructed` | 2024-10-31 至 2024-11-02 | 60 |

## 读取一个文件

在数据库根目录运行：

```matlab
data = main_function('data/2024_21_Kongrey/observations/reconstructed/2024-10-31/2024-10-31_11.csv');
```

需要画图时，把根目录 `main.m` 中的文件路径改为上述路径，运行即可。

[返回数据库](../../README.md#简体中文)
