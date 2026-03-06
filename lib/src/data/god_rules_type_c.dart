// Generated file. Do not edit manually.
// Type C god rules: month[men] → stem/branch index → check if char in day pillar
//
// Encoding: 0-9 = stem index (match dayStemIndex), 10-21 = branch index + 10 (match dayBranchIndex)
// Runtime: val < 10 ? (dayStemIndex == val) : (dayBranchIndex == val - 10)

import 'gods.dart';

/// 类型C神煞查表：月份索引[0-11] → 编码值
/// 编码：0-9 = 天干索引（匹配日天干），10-21 = 地支索引+10（匹配日地支）
class TypeCGodRules {
  /// 月恩 (吉) L781: 甲辛丙丁庚己戊辛壬癸庚乙
  static const yue_en = [0, 7, 2, 3, 6, 5, 4, 7, 8, 9, 6, 1];

  /// 重丧 (凶) L892: 癸己甲乙己丙丁己庚辛己壬
  static const zhong_sang = [9, 5, 0, 1, 5, 2, 3, 5, 6, 7, 5, 8];

  /// 重复 (凶) L893: 癸己庚辛己壬癸戊甲乙己壬
  static const chong_fu = [9, 5, 6, 7, 5, 8, 9, 4, 0, 1, 5, 8];

  /// 复日 (凶) L1012: 癸巳甲乙戊丙丁巳庚辛戊壬 ⚠️ 含地支: 位置[1, 7]
  static const fu_ri = [9, 15, 0, 1, 4, 2, 3, 15, 6, 7, 4, 8];

  /// 所有类型C规则
  static const Map<AlmanacGod, List<int>> all = {
    AlmanacGod.yue_en: yue_en,
    AlmanacGod.zhong_sang: zhong_sang,
    AlmanacGod.chong_fu: chong_fu,
    AlmanacGod.fu_ri: fu_ri,
  };
}
