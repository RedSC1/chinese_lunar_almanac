# chinese_lunar_almanac

纯 Dart 实现的中国传统黄历（老黄历）库，提供完整的日历信息、干支历法、九宫飞星、神煞宜忌等功能。

> 📖 **[开发者笔记 (Developer's Note)](https://github.com/RedSC1/ziwei_core/blob/main/developer's_note.md)**：为什么写这个库？它的架构设计思路是什么？以及作者对玄学的一点“理智”思考。

天文历算内核基于 [寿星万年历](https://github.com/sxwnl/sxwnl)，节日数据、神煞与宜忌规则移植自 [cnlunar](https://github.com/OPN48/cnlunar)。支持时区感知、早晚子时、精确节令等多种配置。

## 功能

- 公历 / 农历日期转换
- 年柱、月柱、日柱、时柱干支
- 纳音五行
- 二十四节气（精确时刻）
- 廿八星宿
- 建除十二值日
- 十二值神（黄黑道）
- 时辰干支与黄黑道吉凶
- 彭祖百忌
- 冲煞信息
- 节日（公历 / 农历 / 节气节日）
- 月相（朔望）
- 九宫飞星（年 / 月 / 日 / 时盘，地盘 / 山盘 / 向盘）
- 神煞与宜忌推算
- 按月 / 按年批量生成黄历

## 快速开始

```yaml
dependencies:
  chinese_lunar_almanac: ^0.1.2
```

```dart
import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';
```

## 使用示例

### 统一入口（推荐）

```dart
final cal = HuangliCalendar(timezone: 8.0);

// 单日黄历
final day = cal.getDay(2026, 3, 16);
print(day.lunarDate);          // 正月廿八
print(day.ganZhi);             // 己丑
print(day.yearGanZhi);         // 丙午
print(day.monthGanZhi);        // 辛卯
print(day.naYin);              // 霹雳火
print(day.star28);             // 危月燕
print(day.chongSha);           // 冲羊(乙未) 煞东
print(day.shenSha.jianChu);    // 开
print(day.shenSha.dayTwelveGod); // 勾陈
print(day.pengZu);             // 己不破券二比并亡，丑不冠带主不还乡
print(day.festivals);          // 节日列表（公历/农历/节气节日）

// 时辰
for (final hour in day.dayHours) {
  print('${hour.zhiName}时(${hour.name}) ${hour.timeRange} '
      '${hour.isHuangDao ? "吉" : "凶"}');
}

// 月历
final month = cal.getMonth(2026, 3);
print(month.length);              // 31
print(month.solarTermsInMonth);   // [(5, 惊蛰), (20, 春分)]
print(month.festivalsInMonth);    // [...]

// 年历
final year = cal.getYear(2026);
print(year.totalDays);            // 365
print(year.solarTermsInYear);     // 24 节气
```

### 九宫飞星

```dart
final time = AstroDateTime(2026, 3, 16, 10);
final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
final nsb = NineStarBoard(boundary: Boundary.solar);

// 年 / 月 / 日 / 时盘
final yearBoard  = nsb.getYearBoard(time);
final monthBoard = nsb.getMonthBoard(time);
final dayBoard   = nsb.getDayBoard(tp);
final hourBoard  = nsb.getHourBoard(tp);

print(dayBoard.centerStar);   // FlyingStar.star5
print(dayBoard.numbers);      // [4, 9, 2, 3, 5, 7, 8, 1, 6]

// 按方位取星
print(dayBoard.southStar);
print(dayBoard.starAt(CompassDirection.northeast));

// 住宅飞星（地盘 / 山盘 / 向盘）
final earth    = nsb.getEarthPlate(7);
final mountain = nsb.getMountainPlate(earth, Mountain.zi);
final water    = nsb.getWaterPlate(earth, Mountain.zi);
```

### 直接构造（不使用 HuangliCalendar）

```dart
// 单日
final tp = TimePack.createBySolarTime(
  clockTime: AstroDateTime(2026, 3, 16, 12),
  timezone: 8.0,
);
final day = HuangliDay.from(tp);

// 月历
final month = HuangliMonth.from(year: 2026, month: 3);

// 年历
final year = HuangliYear.from(year: 2026);
```

## 配置项

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `timezone` | `8.0` | 用户所在时区（东八区 = 8.0） |
| `splitRatHour` | `false` | 是否启用早晚子时（`true` = 23:00 前属当日子时） |
| `exactJieQiTime` | `false` | 是否使用精确节令时刻判断月柱切换 |

## 九宫飞星配置

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `boundary` | `Boundary.solar` | 年月盘界限（`solar` = 节气，`lunar` = 农历） |
| `method` | `DayFlyingStarMethod.consecutive` | 日盘排法（连茹 / 截路） |
| `useHistoricalSolarTerms` | `false` | 是否使用历史节气修正（1645-1929） |

## 九宫宫位索引

盘面数组固定按以下顺序排列：

```
[0]东南  [1]南   [2]西南
[3]东    [4]中   [5]西
[6]东北  [7]北   [8]西北
```

## 已知限制 & 开发计划

- **历史节气修正（黄历层）**：九宫飞星已支持 `useHistoricalSolarTerms`，但 `HuangliDay` / `HuangliCalendar` 层尚未接入。当前黄历的节气显示和月柱判断均基于现代天文定气法，对 1645-1929 年间的历史日期可能与古代皇历印本存在一两天偏差。后续版本将统一接入 `SSQ` 历史修正表。
- **神煞宜忌**：已实现完整的神煞推算与宜忌裁决引擎，但各家万年历对神煞取舍和宜忌裁决规则存在分歧，当前结果可能与市面软件不完全一致。
- **择日筛选**：计划支持按条件（宜忌、冲煞、黄黑道等）筛选日期区间内的吉日，尚未实现。

## 致谢

- 节日数据、每日神煞与宜忌裁决规则移植自开源项目 [cnlunar](https://github.com/OPN48/cnlunar)（Python），在此基础上进行了 Dart 重写与部分修正。
- 天文历算内核基于 [寿星万年历](https://github.com/sxwnl/sxwnl)。

## 许可证

MIT
