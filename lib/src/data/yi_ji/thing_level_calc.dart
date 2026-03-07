import '../../utils/fast_bitset.dart';
import 'thing_level_rules.dart';

/// 宜忌等第判定 (Thing Level Calculator)
class ThingLevelCalc {
  /// 计算“当天的宜忌等第 (Thing Level)”
  ///
  /// 根据当月的地支 [monthBranch]、当天激活的实神 [activeRealGods]
  /// 以及虚神掩码 [activeVirtualGodsMask]，循环碰撞预编译的 56 条规则。
  ///
  /// 返回一个冲突评级 (0~5)，数字越大代表凶煞越重、惩罚越狠 (5=诸事皆忌)。
  /// 如果没有命中任何降级规则，则返回 -1（代表安全，无特殊降级）。
  static int calculate({
    required int monthBranch,
    required FastBitSet activeRealGods,
    required int activeVirtualGodsMask,
  }) {
    int maxLevel = -1; // -1 代表安全，无特殊降级
    final currentMonthBit = 1 << monthBranch; // 月份的 12-bit 掩码

    // 暴力遍历 56 条预编译掩码规则
    for (final rule in ThingLevelRules.rules) {
      // 1. 检查月份掩码是否匹配
      if ((rule.monthMask & currentMonthBit) != 0) {
        // 2. 检查所要求的虚神是否全部在场
        if ((activeVirtualGodsMask & rule.virtualGodMask) ==
            rule.virtualGodMask) {
          // 3. 检查所要求的实神是否全部在场
          if (activeRealGods.containsAll(rule.realGodMask)) {
            // 命中！如果这条规则的惩罚比当前记录的更重(数字更大)，就更新它
            if (rule.level > maxLevel) {
              maxLevel = rule.level;
            }
          }
        }
      }
    }

    return maxLevel;
  }
}
