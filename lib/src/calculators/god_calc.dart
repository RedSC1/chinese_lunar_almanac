/* ------------------------------------------------------------------
 * 神煞计算逻辑参考了 Python 版的 cnlunar (https://github.com/OPN48/cnlunar)
 * 测试了 2000-2026 年的数据，跟 cnlunar 算的完全一致。
 * 原作者能把这些古籍规则手工录入进去，是真牛逼，致敬一下🫡。
 * * 不过原作代码里全是 List<String>，还带一堆交集并集之类的集合操作
 * 理论上性能表现不好，我就直接全改用自己写的 FastBitSet (32-bit chunk) 实现了。
 * 理论性能更好我感觉
 * 月支查日支这种 A 类神煞，我全部预计算成了硬编码，当然也有不用硬编码的版本，我也留着了。
 * * 另外看了一眼 cnlunar 的 Dart 实现版 (https://github.com/m11v/chinese_lunar_calendar)
 * 估计是嫌神煞和宜忌逻辑太脏，直接没做这部分。
 * 既然没人搞，那我来填坑吧。
 * 2026.3.7
 * ------------------------------------------------------------------ */

//2026年3月8日修复: 修改了原作使用农历月计算神煞的逻辑，经查证应当是农历月
//所以部分神煞计算结果和cnlunar不一致
//例如: “阴阳交破”
// 「四月阳建于巳，破于亥，阴建于未，破于癸。
//  癸，阳也，为阴所破也；亥，阴也，为阳所破也。
//  是谓阳破阴，阴破阳，故四月癸亥为阴阳交破。
//  十月阳建于亥，破于巳，阴建于丑，破于丁。
//  丁，阳也，为阴所破也；巳，阴也，为阳所破也。
//  是为阳破阴，阴破阳，故十月丁巳为阴阳交破。」

import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../data/god_grid_type_a.dart';
import '../data/god_rules_type_b.dart';
import '../data/god_rules_type_c.dart';
import '../data/god_rules_type_d.dart';
import '../data/god_rules_type_e.dart';
import '../data/god_rules_type_f.dart';
import '../data/god_rules_type_g.dart';
import '../data/god_rules_type_h.dart';
import '../data/gods.dart';
import '../utils/fast_bitset.dart';

/// 神煞综合计算器
/// 该类汇总了从 A 到 H 的所有 171 位神煞的判定规则。
class GodCalculator {
  /// 计算指定日期的所有活跃神煞
  ///
  /// 入参说明：
  /// [monthIndex] (men) - 月地支索引 (0-11)，对应 cnlunar 中的 men 参数 (由 godType 决定)
  /// [dayGanZhiIndex] (dhen) - 日干支索引 (0-59)
  /// [yearGanZhiIndex] (yhn) - 年干支索引 (0-59)
  /// [lunarMonth] - 农历月份 (1-12)
  /// [lunarDay] - 农历日期 (1-30)
  /// [seasonIndex] (sn) - 季节索引 (0:春, 1:夏, 2:秋, 3:冬)
  /// [monthSeasonTypeIndex] (lunarSeasonType) - 月份在季节中的位置 (0:仲, 1:季, 2:孟)
  /// [day28Star] - 当日二十八星宿名称 (如 "角", "亢"...)
  /// [date] - 公历日期 (AstroDateTime)
  /// [isSiJue] - 是否为四绝日
  /// [isSiLi] - 是否为四离日
  /// [isTuWangYongShi] - 是否为土王用事日
  static FastBitSet calculateAll({
    required int monthIndex,
    required int dayGanZhiIndex,
    required int yearGanZhiIndex,
    required int lunarMonth,
    required int lunarDay,
    required int seasonIndex,
    required int monthSeasonTypeIndex,
    required String day28Star,
    required AstroDateTime date,
    bool isSiJue = false,
    bool isSiLi = false,
    bool isTuWangYongShi = false,
  }) {
    // 基础索引
    final dayStemIndex = dayGanZhiIndex % 10;
    final dayBranchIndex = dayGanZhiIndex % 12;
    final yearBranchIndex = yearGanZhiIndex % 12;

    // --- Type A: 144格预计算网格 (99个神煞) ---
    final result = TypeAGrid.lookup(monthIndex, dayBranchIndex);

    // --- Type B: 月-天干-日天干 (3个神煞) ---
    TypeBGodRules.all.forEach((god, table) {
      if (dayStemIndex == table[monthIndex]) {
        result.add(god.index);
      }
    });

    // --- Type C: 月-干/支-日柱包含 (4个神煞) ---
    TypeCGodRules.all.forEach((god, table) {
      final val = table[monthIndex];
      final hit = val < 10
          ? (dayStemIndex == val)
          : (dayBranchIndex == val - 10);
      if (hit) result.add(god.index);
    });

    // --- Type D: 月-日柱匹配 (5个神煞) ---
    TypeDGodRules.singleMatch.forEach((god, table) {
      if (dayGanZhiIndex == table[monthIndex]) {
        result.add(god.index);
      }
    });
    if (TypeDGodRules.di_nang[monthIndex].contains(dayGanZhiIndex)) {
      result.add(AlmanacGod.di_nang.index);
    }

    // --- Type E: 季节-日干/日支/日柱匹配 (22个神煞) ---
    TypeEGodRules.stemMatch.forEach((god, seasons) {
      if (seasons[seasonIndex].contains(dayStemIndex)) {
        result.add(god.index);
      }
    });
    TypeEGodRules.branchMatch.forEach((god, seasons) {
      if (seasons[seasonIndex].contains(dayBranchIndex)) {
        result.add(god.index);
      }
    });
    TypeEGodRules.pillarMatch.forEach((god, seasons) {
      if (seasons[seasonIndex].contains(dayGanZhiIndex)) {
        result.add(god.index);
      }
    });

    // --- Type F: 固定日柱名单匹配 (11个神煞) ---
    TypeFGodRules.all.forEach((god, set) {
      if (set.contains(dayGanZhiIndex)) {
        result.add(god.index);
      }
    });

    // --- Type G: 纯数学公式计算 (4个神煞) ---
    final gResults = TypeGGodRules.calculate(
      monthIndex: monthIndex,
      dayGanZhiIndex: dayGanZhiIndex,
      dayBranchIndex: dayBranchIndex,
      yearBranchIndex: yearBranchIndex,
    );
    result.merge(gResults);

    // --- Type H: 复杂判定逻辑 (23个神煞) ---
    final hResults = TypeHGodRules.calculate(
      monthIndex: monthIndex,
      dayGanZhiIndex: dayGanZhiIndex,
      yearGanZhiIndex: yearGanZhiIndex,
      lunarMonth: lunarMonth,
      lunarDay: lunarDay,
      seasonIndex: seasonIndex,
      monthSeasonTypeIndex: monthSeasonTypeIndex,
      day28Star: day28Star,
      date: date,
      isSiJue: isSiJue,
      isSiLi: isSiLi,
      isTuWangYongShi: isTuWangYongShi,
    );
    result.merge(hResults);

    return result;
  }
}
