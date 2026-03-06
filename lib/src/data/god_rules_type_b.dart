// Generated file. Do not edit manually.
// Type B god rules: month[men] → stem index → match day stem
// Usage: if (dayStemIndex == table[monthIndex]) → god is active

import 'gods.dart';

/// 类型B神煞查表：月份索引[0-11] → 触发天干索引[0-9]
/// 运行时判定：dayStemIndex == table[monthIndex]
class TypeBGodRules {
  /// 月德 (吉) L718: 壬庚丙甲壬庚丙甲壬庚丙甲
  static const yue_de = [8, 6, 2, 0, 8, 6, 2, 0, 8, 6, 2, 0];

  /// 月德合 (吉) L723: 丁乙辛己丁乙辛己丁乙辛己
  static const yue_de_he = [3, 1, 7, 5, 3, 1, 7, 5, 3, 1, 7, 5];

  /// 月空 (吉) L806: 丙甲壬庚丙甲壬庚丙甲壬庚
  static const yue_kong = [2, 0, 8, 6, 2, 0, 8, 6, 2, 0, 8, 6];

  /// 所有类型B规则
  static const Map<AlmanacGod, List<int>> all = {
    AlmanacGod.yue_de: yue_de,
    AlmanacGod.yue_de_he: yue_de_he,
    AlmanacGod.yue_kong: yue_kong,
  };
}
