import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart' as sxwnl;
import '../calculators/yi_ji_calc.dart';
import 'day_shen_sha.dart';
import '../utils/fast_bitset.dart';
import '../data/activities.dart';

/// 黄历单日宜忌专区 (DayYiJi)
///
/// 依赖于神煞的计算结果，生成当日的宜忌事项。
class DayYiJi {
  /// 原始结算结果 (底层数据)
  final YiJiResult _result;

  /// 宜 (Good Activities) - 默认全量
  List<String> get suitableActivities => getSuitableLabels();

  /// 忌 (Bad Activities) - 默认全量
  List<String> get tabooActivities => getTabooLabels();

  /// 获取宜事标签列表 (支持掩码过滤)
  List<String> getSuitableLabels({FastBitSet? mask}) {
    return _result.toGoodStringList(mask: mask);
  }

  /// 获取忌事标签列表 (支持掩码过滤)
  List<String> getTabooLabels({FastBitSet? mask}) {
    return _result.toBadStringList(mask: mask);
  }

  /// 获取宜事枚举对象列表 (支持掩码过滤)
  List<AlmanacActivity> getSuitableEnums({FastBitSet? mask}) {
    return _result.toGoodEnumList(mask: mask);
  }

  /// 获取忌事枚举对象列表 (支持掩码过滤)
  List<AlmanacActivity> getTabooEnums({FastBitSet? mask}) {
    return _result.toBadEnumList(mask: mask);
  }

  DayYiJi({
    required YiJiResult result,
  }) : _result = result;

  factory DayYiJi.calculate({
    required sxwnl.DayInfo info,
    required int monthBranchIndex,
    required int nextSolarTermIndex,
    required DayShenSha shenSha,
  }) {
    final yiji = YiJiCalc.calculate(
      monthBranch: monthBranchIndex,
      dayGanZhiIndex: info.ganZhi.index,
      lunarMonth: info.lunarDate.month,
      lunarDay: info.lunarDate.day,
      nextSolarTermIndex: nextSolarTermIndex,
      dayOfficerIndex: shenSha.jianChu.index,
      activeRealGods: shenSha.activeRealGods,
      activeVirtualGodsMask: shenSha.activeVirtualGodsMask,
      isPhaseOfMoon: info.moonPhase != null,
    );

    return DayYiJi(result: yiji);
  }

  @override
  String toString() {
    return 'DayYiJi(suitable: ${suitableActivities.length}, taboo: ${tabooActivities.length})';
  }
}
