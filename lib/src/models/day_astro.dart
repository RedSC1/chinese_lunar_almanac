import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../calculators/sanyuan_jiuyun_calc.dart';
import 'sanyuan_jiuyun.dart';
import 'flying_star_board.dart';

/// 黄历星象与大运专区 (DayAstro)
///
/// 包含三元九运、玄空日飞星等宏观历法相关逻辑。
class DayAstro {
  /// 当前三元
  final SanYuan sanYuan;

  /// 当前九运
  final FlyingStar jiuYun;

  /// 九星日盘 (九宫飞星)
  final FlyingStarBoard dailyFlyingStar;

  DayAstro({
    required this.sanYuan,
    required this.jiuYun,
    required this.dailyFlyingStar,
  });

  factory DayAstro.calculate({
    required TimePack timePack,
    bool exactJieQiTime = false,
  }) {
    // 三元九运直接用北京时间的年份
    final bjYear = timePack.bjClt.year;
    final sy = SanYuanJiuYunCalc.getSanYuan(bjYear);
    final jy = SanYuanJiuYunCalc.getJiuYun(bjYear);

    // 日飞星盘：NineStarBoard 内部已经完全接管了 TimePack。
    // 计算阴阳遁的节气使用 bjClt 绝对时刻，计算日偏移量使用本地钟表及换日子时配置。
    final dayStarBoard = NineStarBoard(
      exactJieQiTime: exactJieQiTime,
    ).getDayBoard(timePack);

    return DayAstro(
      sanYuan: sy,
      jiuYun: jy,
      dailyFlyingStar: dayStarBoard,
    );
  }

  @override
  String toString() {
    final centerStar = dailyFlyingStar.stars[4];
    return 'DayAstro(sanYuan: ${sanYuan.label}, jiuYun: ${jiuYun.name}, centerStar: ${centerStar.name})';
  }
}
