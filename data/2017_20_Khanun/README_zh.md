# 卡努（2017）

[English](README.md) | [简体中文](README_zh.md)

本目录包含 1 个原始观测文件对应的 16 个小时观测 CSV，共 357,732 行。

所有 CSV 使用同一套 20 列。第一行是英文列名，缺项留空；字段顺序、含义和单位见 [CSV 列说明](../../README.md#列说明)。

## 数据目录

| `observations` 下的目录 | 日期范围 | 小时 CSV |
|---|---|---:|
| `component_profiles` | 2017-10-14 至 2017-10-15 | 16 |

## 读取一个文件

在数据库根目录运行：

```matlab
data = main_function('data/2017_20_Khanun/observations/component_profiles/2017-10-14/2017-10-14_09.csv');
```

需要画图时，把根目录 `main.m` 中的文件路径改为上述路径，运行即可。

[返回数据库](../../README.md#简体中文)
