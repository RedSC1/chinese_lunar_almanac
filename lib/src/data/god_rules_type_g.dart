// Generated file. Do not edit manually.
// Type G god rules: Math / Boolean formulas
// Contains 4 rules: 三合, 天恩, 岁破, 蚩尤

import '../utils/fast_bitset.dart';
import 'gods.dart';

/// 类型G神煞计算法：纯数学运算 / 简单逻辑关联
class TypeGGodRules {
  /// 蚩尤 (凶) L974: '戌子寅辰午申'[men % 6]
  /// '戌'=10, '子'=0, '寅'=2, '辰'=4, '午'=6, '申'=8
  static const _chiYouBranches = [10, 0, 2, 4, 6, 8];

  /// 计算某天的所有类型G神煞，返回包含命中神煞的 FastBitSet。
  /// [monthIndex] 月地支索引 (0-11)
  /// [dayGanZhiIndex] 日干支索引 (0-59)，相当于 dhen
  /// [dayBranchIndex] 日地支索引 (0-11)
  /// [yearBranchIndex] 年地支索引 (0-11)
  static FastBitSet calculate({
    required int monthIndex,
    required int dayGanZhiIndex,
    required int dayBranchIndex,
    required int yearBranchIndex,
  }) {
    final activeGods = FastBitSet(171); // AlmanacGod.values.length

    // 三合 (吉) L746: (den - men) % 4 == 0
    // 注意 Dart 中 % 可能是负数，需要保证正余数 (a % b + b) % b
    if ((dayBranchIndex - monthIndex) % 4 == 0) {
      activeGods.add(AlmanacGod.san_he.index);
    }

    // 天恩 (吉) L779: dhen % 15 < 5 and dhen ~/ 15 != 2
    if ((dayGanZhiIndex % 15 < 5) && (dayGanZhiIndex ~/ 15 != 2)) {
      activeGods.add(AlmanacGod.tian_en.index);
    }

    // 岁破 (凶) L837: den == (yen + 6) % 12
    if (dayBranchIndex == (yearBranchIndex + 6) % 12) {
      activeGods.add(AlmanacGod.sui_po.index);
    }

    // 蚩尤 (凶) L974: '戌子寅辰午申'[men % 6] in d
    // 取余求出它这个月通缉的地支，看它等不等于日地支
    if (dayBranchIndex == _chiYouBranches[monthIndex % 6]) {
      activeGods.add(AlmanacGod.chi_you.index);
    }

    return activeGods;
  }
}
