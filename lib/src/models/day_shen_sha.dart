import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart' as sxwnl;
import '../calculators/god_calc.dart';
import '../calculators/jian_chu_calc.dart';
import '../calculators/chong_sha_calc.dart';
import '../calculators/tai_shen_calc.dart';
import '../calculators/peng_zu_calc.dart';
import '../calculators/god_direction_calc.dart';
import '../calculators/twelve_gods_calc.dart';
import '../data/yi_ji/virtual_god_defs.dart';
import '../data/gods.dart';
import '../utils/fast_bitset.dart';
import 'compass_direction.dart';

/// 黄历单日神煞专区 (DayShenSha)
///
/// 包含所有与神明碰撞、禁忌、方位、建除有关的领域模型。
class DayShenSha {
  /// 彭祖百忌
  final String pengZu;

  /// 冲煞描述
  final String chongSha;

  /// 十二建除
  final JianChu jianChu;

  /// 十二值神 (青龙、明堂等日级黄道/黑道)
  final DailyTwelveGods dayTwelveGod;

  /// 胎神占方
  final String taiShen;

  /// 吉神方位 (喜神、福神、财神、阳贵、阴贵)
  final Map<String, CompassDirection> godDirections;

  /// 活跃的实神掩码 (引擎内部使用)
  final FastBitSet activeRealGods;

  /// 活跃的虚神掩码 (引擎内部使用, 比如德大会等)
  final int activeVirtualGodsMask;

  /// 吉神列表 (默认全量)
  List<String> get auspiciousGods => getAuspiciousGodsLabels();

  /// 凶神列表 (默认全量)
  List<String> get inauspiciousGods => getInauspiciousGodsLabels();

  /// 获取吉神标签列表 (支持掩码过滤)
  List<String> getAuspiciousGodsLabels({FastBitSet? mask}) {
    return activeRealGods.getAuspiciousGods(mask: mask);
  }

  /// 获取凶神标签列表 (支持掩码过滤)
  List<String> getInauspiciousGodsLabels({FastBitSet? mask}) {
    return activeRealGods.getInauspiciousGods(mask: mask);
  }
  
  /// 获取吉神枚举对象列表 (支持掩码过滤)
  List<AlmanacGod> getAuspiciousGodEnums({FastBitSet? mask}) {
    return activeRealGods.getAuspiciousGodEnums(mask: mask);
  }

  /// 获取凶神枚举对象列表 (支持掩码过滤)
  List<AlmanacGod> getInauspiciousGodEnums({FastBitSet? mask}) {
    return activeRealGods.getInauspiciousGodEnums(mask: mask);
  }

  DayShenSha({
    required this.pengZu,
    required this.chongSha,
    required this.jianChu,
    required this.dayTwelveGod,
    required this.taiShen,
    required this.godDirections,
    required this.activeRealGods,
    required this.activeVirtualGodsMask,
  });

  /// 延迟按需结算工厂
  factory DayShenSha.calculate({
    required sxwnl.DayInfo info,
    required int monthBranchIndex,
    required int yearGanZhiIndex,
    required int seasonIndex,
    required int monthSeasonTypeIndex,
    required String star28Name,
    required bool isSiJue,
    required bool isSiLi,
  }) {
    // 彭祖百忌
    final pengZu = PengZu.getFullTaboo(info.ganZhi);
    // 冲煞
    final chongSha = ChongSha.getChongShaString(info.ganZhi);
    // 胎神 (此处根据您原先逻辑，TaiShenCalculator 返回 dynamic，如果返回 String 直接用)
    final taiShen = TaiShenCalculator.getDirection(info.ganZhi);
    // 吉神方位
    final godDirs = GodDirection.getDailyDirections(info.ganZhi.gan);

    // 建除十二神
    final jianchuIndex = (info.ganZhi.zhi.index - monthBranchIndex + 12) % 12;
    final jianChu = JianChu.values[jianchuIndex];

    // 十二值神 (日级黄黑道)
    final dayTwelveGod = DailyTwelveGods.calculate(
      sxwnl.DiZhi.values[monthBranchIndex],
      info.ganZhi.zhi,
    );

    // 实神本尊碰撞
    final activeRealGods = GodCalculator.calculateAll(
      monthIndex: monthBranchIndex,
      dayGanZhiIndex: info.ganZhi.index,
      yearGanZhiIndex: yearGanZhiIndex,
      lunarMonth: info.lunarDate.month,
      lunarDay: info.lunarDate.day,
      seasonIndex: seasonIndex,
      monthSeasonTypeIndex: monthSeasonTypeIndex,
      day28Star: star28Name,
      date: info.solarDate,
      isSiJue: isSiJue,
      isSiLi: isSiLi,
    );

    // 虚神掩码碰撞 (支持等第表)
    final activeVirtualGodsMask = computeVirtualGodBits(
      officerIndex: jianChu.index,
      monthBranch: monthBranchIndex,
      dayBranch: info.ganZhi.zhi.index,
      dayStemBranch60: info.ganZhi.index,
      hasYueDe: activeRealGods.has(AlmanacGod.yue_de.index),
    );

    return DayShenSha(
      pengZu: pengZu,
      chongSha: chongSha,
      jianChu: jianChu,
      dayTwelveGod: dayTwelveGod,
      taiShen: taiShen.toString(), // 确保返回 String
      godDirections: godDirs,
      activeRealGods: activeRealGods,
      activeVirtualGodsMask: activeVirtualGodsMask,
    );
  }

  @override
  String toString() {
    return 'DayShenSha(jianChu: ${jianChu.name}, chong: $chongSha, gods: ${auspiciousGods.length + inauspiciousGods.length})';
  }
}
