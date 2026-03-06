// Generated file. Do not edit manually.
// Type D god rules: month[men] → 60-甲子 index → match day ganZhi index
// Runtime: if (dayGanZhiIndex == table[monthIndex]) → god is active
// For 地囊: if (table[monthIndex].contains(dayGanZhiIndex)) → god is active

import 'gods.dart';

/// 类型D神煞查表：月份索引[0-11] → 六十甲子索引[0-59]
class TypeDGodRules {
  /// 天赦 (吉) L784: 甲子 甲子 戊寅 戊寅 戊寅 甲午 甲午 甲午 戊申 戊申 戊申 甲子
  static const tian_she = [0, 0, 14, 14, 14, 30, 30, 30, 44, 44, 44, 0];

  /// 天愿 (吉) L788: 甲子 癸未 甲午 甲戌 乙酉 丙子 丁丑 戊午 甲寅 丙辰 辛卯 戊辰
  static const tian_yuan = [0, 19, 30, 10, 21, 12, 13, 54, 50, 52, 27, 4];

  /// 五墓 (凶) L956: 壬辰 戊辰 乙未 乙未 戊辰 丙戌 丙戌 戊辰 辛丑 辛丑 戊辰 壬辰
  static const wu_mu = [28, 4, 31, 31, 4, 22, 22, 4, 37, 37, 4, 28];

  /// 阴错 (凶) L940: 壬子癸丑庚寅辛卯庚辰丁巳丙午丁未甲申乙酉甲戌癸亥
  static const yin_cuo = [48, 49, 26, 27, 16, 53, 42, 43, 20, 21, 10, 59];

  /// 地囊 (凶) L913: 每月2个干支对
  static const di_nang = [[7, 57], [21, 31], [36, 6], [19, 49], [0, 50], [15, 25], [4, 54], [19, 29], [2, 32], [3, 53], [4, 24], [46, 36]];

  /// 单匹配类型D规则 (天赦,天愿,五墓,阴错)
  static const Map<AlmanacGod, List<int>> singleMatch = {
    AlmanacGod.tian_she: tian_she,
    AlmanacGod.tian_yuan: tian_yuan,
    AlmanacGod.wu_mu: wu_mu,
    AlmanacGod.yin_cuo: yin_cuo,
  };
}
