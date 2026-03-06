// Generated file. Do not edit manually.
// Type F god rules: Match day pillar against a fixed list of 60-jiazi pairs, pure Set lookups.
// Runtime: if (table.contains(dayGanZhiIndex)) → god is active

import 'gods.dart';

/// 类型F神煞查表：无月/季参数，日干支(0-59)固定命中集合
class TypeFGodRules {
  /// 大葬 (吉) L762: 壬申 癸酉 壬午 甲申 乙酉 丙申 丁酉 壬寅 丙午 己酉 庚申 辛酉
  static const Set<int> da_zang = {8, 9, 18, 20, 21, 32, 33, 38, 42, 45, 56, 57};

  /// 鸣吠 (吉) L763: 庚午 壬申 癸酉 壬午 甲申 乙酉 己酉 丙申 丁酉 壬寅 丙午 庚寅 庚申 辛酉
  static const Set<int> ming_fei = {6, 8, 9, 18, 20, 21, 45, 32, 33, 38, 42, 26, 56, 57};

  /// 小葬 (吉) L764: 庚午 壬辰 甲辰 乙巳 甲寅 丙辰 庚寅
  static const Set<int> xiao_zang = {6, 28, 40, 41, 50, 52, 26};

  /// 鸣吠对 (吉) L766: 丙寅 丁卯 丙子 辛卯 甲午 庚子 癸卯 壬子 甲寅 乙卯
  static const Set<int> ming_fei_dui = {2, 3, 12, 27, 30, 36, 39, 48, 50, 51};

  /// 不守塚 (吉) L767: 庚午 辛未 壬申 癸酉 戊寅 己卯 壬午 癸未 甲申 乙酉 丁未 甲午 乙未 丙申 丁酉 壬寅 癸卯 丙午 戊申 己酉 ...
  static const Set<int> bu_shou_zhong = {6, 7, 8, 9, 14, 15, 18, 19, 20, 21, 43, 30, 31, 32, 33, 38, 39, 42, 44, 45, 56, 57};

  /// 宝日 (凶) L1004: 丁未 丁丑 丙戌 甲午 庚子 壬寅 癸卯 乙巳 戊申 己酉 辛亥 丙辰
  static const Set<int> bao_ri = {43, 13, 22, 30, 36, 38, 39, 41, 44, 45, 47, 52};

  /// 义日 (凶) L1005: 甲子 丙寅 丁卯 己巳 辛未 壬申 癸酉 乙亥 庚辰 辛丑 庚戌 戊午
  static const Set<int> yi_ri = {0, 2, 3, 5, 7, 8, 9, 11, 16, 37, 46, 54};

  /// 制日 (凶) L1006: 乙丑 甲戌 壬午 戊子 庚寅 辛卯 癸巳 乙未 丙申 丁酉 己亥 甲辰
  static const Set<int> zhi_ri = {1, 10, 18, 24, 26, 27, 29, 31, 32, 33, 35, 40};

  /// 伐日 (凶) L1007: 庚午 辛巳 丙子 戊寅 己卯 癸未 癸丑 甲申 乙酉 丁亥 壬辰 壬戌
  static const Set<int> fa_ri = {6, 17, 12, 14, 15, 19, 49, 20, 21, 23, 28, 58};

  /// 专日 (凶) L1009: 甲寅 乙卯 丁巳 丙午 庚申 辛酉 癸亥 壬子 戊辰 戊戌 己丑 己未
  static const Set<int> zhuan_ri = {50, 51, 53, 42, 56, 57, 59, 48, 4, 34, 25, 55};

  /// 八专 (凶) L962: 丁未 己未 庚申 甲寅 癸丑
  static const Set<int> ba_zhuan = {43, 55, 56, 50, 49};

  /// 所有匹配固定日柱规则的集合
  static const Map<AlmanacGod, Set<int>> all = {
    AlmanacGod.da_zang: da_zang,
    AlmanacGod.ming_fei: ming_fei,
    AlmanacGod.xiao_zang: xiao_zang,
    AlmanacGod.ming_fei_dui: ming_fei_dui,
    AlmanacGod.bu_shou_zhong: bu_shou_zhong,
    AlmanacGod.bao_ri: bao_ri,
    AlmanacGod.yi_ri: yi_ri,
    AlmanacGod.zhi_ri: zhi_ri,
    AlmanacGod.fa_ri: fa_ri,
    AlmanacGod.zhuan_ri: zhuan_ri,
    AlmanacGod.ba_zhuan: ba_zhuan,
  };
}
