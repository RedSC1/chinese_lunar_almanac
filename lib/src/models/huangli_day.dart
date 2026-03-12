import '../calculators/festival_calc.dart';
import '../calculators/twelve_gods_calc.dart';
import '../calculators/xiu_28_lunar_mansion_calc.dart';
import '../utils/time_utils.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart' as sxwnl;

import 'compass_direction.dart';
import 'flying_star_board.dart';
import 'huangli_hour.dart';
import 'sanyuan_jiuyun.dart';

import 'day_shen_sha.dart';
import 'day_yi_ji.dart';
import 'day_astro.dart';

/// 黄历单日实体核心类 (HuangliDay)
///
/// 封装了一天所有的历法、神煞、择吉等黄历详细数据。
/// 本类作为门面设计，基础历法信息直接暴露，
/// 耗时的神煞、宜忌、玄空等专业领域数据通过 lazy getter (延迟计算) 提供。
///
/// 使用方式：
/// ```dart
/// final tp = TimePack.createBySolarTime(clockTime: AstroDateTime.fromDateTime(DateTime.now()));
/// final day = HuangliDay.from(tp);
/// ```
class HuangliDay {
  // ==========================================
  // 【一】基础显示信息 (基于用户本地钟表时间)
  // ==========================================
  final AstroDateTime solarDate; // 用户本地日期 (clockTime)
  final dynamic lunarDate; // 当地日期对应的农历
  final int weekday; // 当地星期
  final GanZhi ganZhi; // 命理日柱 (基于 metaTime，处理 23:00 换日)
  final GanZhi monthGanZhi; // 命理月柱 (五虎遁推算)
  final DiZhi monthZhi; // 命理月地支 (从 termIndex 推导)
  final GanZhi yearGanZhi; // 命理年柱 (从 termIndex 推导)

  // ==========================================
  // 【二】节气与天象 (时区感知)
  // ==========================================
  final String? solarTerm; // 当天发生的节气 (时区感知)
  final AstroDateTime? solarTermTime; // 节气精确时刻 (当地时间)
  final String? moonPhase; // 月相
  final String constellation; // 星座
  final String star28; // 廿八宿 (同步于命理锚点)

  // ==========================================
  // 【三】节日与纪念日 (Festivals)
  // ==========================================
  final List<String> festivals;

  // ==========================================
  // 【四】领域私有状态 (延迟计算专用锚点数据)
  // ==========================================
  final sxwnl.DayInfo _info; // 命理基础信息 (基于 metaTime)
  final TimePack _timePack;
  final int _monthBranchIndex;
  final int _yearGanZhiIndex;
  final int _seasonIndex;
  final int _monthSeasonTypeIndex;
  final bool _isSiJue;
  final bool _isSiLi;
  final int _nextSolarTermIndex;
  final bool _exactJieQiTime;

  // ==========================================
  // 【五】领域子模块 (Lazy Load)
  // ==========================================

  /// 神煞专区 (延迟加载)
  late final DayShenSha shenSha = DayShenSha.calculate(
    info: _info,
    monthBranchIndex: _monthBranchIndex,
    yearGanZhiIndex: _yearGanZhiIndex,
    seasonIndex: _seasonIndex,
    monthSeasonTypeIndex: _monthSeasonTypeIndex,
    star28Name: star28,
    isSiJue: _isSiJue,
    isSiLi: _isSiLi,
  );

  /// 宜忌专区 (延迟加载)
  late final DayYiJi yiJi = DayYiJi.calculate(
    info: _info,
    monthBranchIndex: _monthBranchIndex,
    nextSolarTermIndex: _nextSolarTermIndex,
    shenSha: shenSha,
  );

  /// 星象与大运专区 (延迟加载)
  late final DayAstro astro = DayAstro.calculate(
    timePack: _timePack,
    exactJieQiTime: _exactJieQiTime,
  );

  // ==========================================
  // 【六】快捷访问层
  // ==========================================

  String get pengZu => shenSha.pengZu;
  String get chongSha => shenSha.chongSha;
  dynamic get jianChu => shenSha.jianChu;
  String get taiShen => shenSha.taiShen.toString();
  Map<String, CompassDirection> get godDirections => shenSha.godDirections;
  List<String> get auspiciousGods => shenSha.auspiciousGods;
  List<String> get inauspiciousGods => shenSha.inauspiciousGods;
  List<String> get suitableActivities => yiJi.suitableActivities;
  List<String> get tabooActivities => yiJi.tabooActivities;
  FlyingStarBoard get dailyFlyingStar => astro.dailyFlyingStar;
  SanYuan get sanYuan => astro.sanYuan;
  FlyingStar get jiuYun => astro.jiuYun;
  String get naYin => ganZhi.naYin;
  String get naYinWuXing => ganZhi.naYinWuXing;

  /// 获取当日十二时辰详细信息列表
  ///
  /// 按照 子、丑、寅、卯、辰、巳、午、未、申、酉、戌、亥 的顺序返回。
  /// 其中第一个元素(子时)的跨度为前一天的 23:00 到当天的 01:00。
  List<HuangliHour> get dayHours {
    final gzs = sxwnl.getDayHourGanZhi(ganZhi.gan);
    return List.generate(12, (i) {
      final hourZhi = sxwnl.DiZhi.values[i];
      final twelveGod = HourlyTwelveGods.calculate(ganZhi.zhi, hourZhi);
      return HuangliHour(
        ganZhi: gzs[i],
        index: i,
        twelveGod: twelveGod,
      );
    });
  }

  HuangliDay._({
    required this.solarDate,
    required this.lunarDate,
    required this.weekday,
    required this.ganZhi,
    required this.monthGanZhi,
    required this.monthZhi,
    required this.yearGanZhi,
    required this.solarTerm,
    required this.solarTermTime,
    required this.moonPhase,
    required this.constellation,
    required this.star28,
    required this.festivals,
    required sxwnl.DayInfo info,
    required TimePack timePack,
    required int monthBranchIndex,
    required int yearGanZhiIndex,
    required int seasonIndex,
    required int monthSeasonTypeIndex,
    required bool isSiJue,
    required bool isSiLi,
    required int nextSolarTermIndex,
    required bool exactJieQiTime,
  }) : _info = info,
       _timePack = timePack,
       _monthBranchIndex = monthBranchIndex,
       _yearGanZhiIndex = yearGanZhiIndex,
       _seasonIndex = seasonIndex,
       _monthSeasonTypeIndex = monthSeasonTypeIndex,
       _isSiJue = isSiJue,
       _isSiLi = isSiLi,
       _nextSolarTermIndex = nextSolarTermIndex,
       _exactJieQiTime = exactJieQiTime;

  /// 核心工厂方法：根据 [TimePack] 一键生成今日黄历全部数据。
  ///
  /// [timePack] 封装了时区、真太阳时、子时换日等所有时间配置。
  /// [exactJieQiTime] 控制月柱切换逻辑：
  /// - true: 精确到秒切换（15:00 交节，15:01 变月柱）。
  /// - false (默认): 全天模式。只要“今天”落入节气，全天按新月柱算。
  factory HuangliDay.from(TimePack timePack, {bool exactJieQiTime = false}) {
    final bjClt = timePack.bjClt;
    final metaTime = timePack.metaTime;
    final clockTime = timePack.clockTime;

    // 1. 获取两类基础信息
    // - displayInfo: 用户本地日历对应的映射 (农历日期等)
    // - metaInfo: 命理日对应的映射 (处理 23:00 换日后的干支)
    final displayInfo = getDayRange(clockTime, clockTime).first;
    final metaInfo = getDayRange(metaTime, metaTime).first;

    // 2. 节气感知 (时区感知) & 命理月柱判断
    String? localSolarTerm;
    AstroDateTime? localSolarTermTime;
    int? localSolarTermIndex;

    {
      final tzOffsetMinutes = ((8 - timePack.timezone) * 60).round();
      // 用户本地今天 00:00 (北京时间)
      final localMidnightBj = AstroDateTime(
        clockTime.year,
        clockTime.month,
        clockTime.day,
      ).add(Duration(minutes: tzOffsetMinutes));
      // 用户本地明天 00:00 (北京时间)
      final localNextMidnightBj = localMidnightBj.add(
        const Duration(hours: 24),
      );

      final nearestTerm = getNextJieQi(localMidnightBj);
      if (nearestTerm != null &&
          !nearestTerm.dateTime.isBefore(localMidnightBj) &&
          nearestTerm.dateTime.isBefore(localNextMidnightBj)) {
        localSolarTerm = nearestTerm.name;
        localSolarTermIndex = nearestTerm.index;
        // 转回用户当地钟表时间
        localSolarTermTime = nearestTerm.dateTime.subtract(
          Duration(minutes: tzOffsetMinutes),
        );
      }
    }

    // 确定月柱索引 (termIndex)
    int termIndex;
    if (exactJieQiTime) {
      // 精确模式：使用此时此刻在北京时间参照系下的前一个节气
      termIndex = sxwnl.getPrevJie(bjClt)!.index;
    } else {
      // 全天模式：如果本地“今天”有交节，直接提前。否则用前一个。
      termIndex = localSolarTermIndex ?? sxwnl.getPrevJie(bjClt)!.index;
    }

    // 3. 年柱 (立春为界)
    final prevJieForYear = sxwnl.getPrevJie(bjClt)!;
    final int solarYearIndex = (termIndex >= 2)
        ? prevJieForYear.dateTime.year
        : prevJieForYear.dateTime.year - 1;
    final yearGanZhi = sxwnl.yearGanZhi(solarYearIndex);

    // 4. 月地支索引与五虎遁月天干
    // 正月(寅)为2，对应地支索引 2
    final monthBranchIndex = (termIndex ~/ 2 + 1) % 12;
    // 五虎遁：甲己之年丙作首，乙庚之歲戊為頭，丙辛必定尋庚起，丁壬壬位順行流，戊癸甲寅好追求。
    // 年干索引: yearGanZhi.gan.index
    // 月地支是从寅(2)开始，我们求该月在年的顺位数 (首月寅 = 0)
    final int monthOffset = (monthBranchIndex - 2 + 12) % 12;
    final int yearGanIndex = yearGanZhi.gan.index;

    // 🚀 五虎遁：O(1) 数学映射秒杀 if-else
    // 公式推导：(年干取模5 * 2 + 2) 刚好映射到 丙(2), 戊(4), 庚(6), 壬(8), 甲(0)
    final int startMonthGanIndex = ((yearGanIndex % 5) * 2 + 2) % 10;

    // 最终该月的天干索引：起始天干 + 偏移量，再取模 10
    final int targetMonthGanIndex = (startMonthGanIndex + monthOffset) % 10;
    final monthGanZhi = GanZhi(
      TianGan.values[targetMonthGanIndex],
      DiZhi.values[monthBranchIndex],
    );

    // 5. 廿八宿 & 其他元数据 (基于 metaTime)
    final star28Obj = LunarMansion.calculateFromJulianDay(metaTime.toJ2000());
    final star28 = star28Obj.fullName;

    // 6. 节日 (基于展示层日期)
    final festivals = FestivalCalculator.getFestivals(
      solarMonth: displayInfo.solarDate.month,
      solarDay: displayInfo.solarDate.day,
      lunarMonth: displayInfo.lunarDate.month,
      lunarDay: displayInfo.lunarDate.day,
      isLeapMonth: displayInfo.lunarDate.isLeap,
      isLastLunarDay:
          displayInfo.lunarDate.day == displayInfo.lunarDate.monthSize,
      solarTerm: localSolarTerm,
    );

    // 7. 神煞关联参数
    final seasonIndex = ((monthBranchIndex + 10) % 12) ~/ 3;
    final monthSeasonTypeIndex = ((monthBranchIndex - 3 + 12) % 12) % 3;

    // 8. 四绝四离 (时区感知) & 下一个节气索引 (用于宜忌)
    //    定义：重大节气（立春、立夏等）的前一天。
    //    逻辑：判断节气的精确时刻是否落在用户本地日历的“明天”范围内。
    bool isSiJue = false;
    bool isSiLi = false;
    final int nextSolarTermIndex;
    {
      final tzOffsetHours = 8 - timePack.timezone;
      // 用户本地今天 24:00 (即明天 00:00) → 转成北京时间
      final localTomorrowBj = AstroDateTime(
        clockTime.year,
        clockTime.month,
        clockTime.day,
      ).add(Duration(hours: tzOffsetHours.round() + 24));
      // 用户本地后天 00:00 → 转成北京时间
      final localNextNextMidnightBj = localTomorrowBj.add(
        const Duration(hours: 24),
      );

      // 1. 查找紧跟在“今天”之后的节气 (用于宜忌计算中的“距离下个节气还有几天”)
      final upcomingTerm = getNextJieQi(bjClt)!;
      nextSolarTermIndex = upcomingTerm.index;

      // 2. 特判“明天”是否有交节 (用于判定今天是否为四绝、四离)
      final termForTomorrow = getNextJieQi(localTomorrowBj);
      if (termForTomorrow != null &&
          !termForTomorrow.dateTime.isBefore(localTomorrowBj) &&
          termForTomorrow.dateTime.isBefore(localNextNextMidnightBj)) {
        final idx = termForTomorrow.index;
        if (idx == 2 || idx == 8 || idx == 14 || idx == 20) {
          isSiJue = true;
        } else if (idx == 5 || idx == 11 || idx == 17 || idx == 23) {
          isSiLi = true;
        }
      }
    }

    return HuangliDay._(
      solarDate: clockTime,
      lunarDate: displayInfo.lunarDate,
      weekday: displayInfo.weekday,
      ganZhi: metaInfo.ganZhi,
      monthGanZhi: monthGanZhi,
      monthZhi: DiZhi.values[monthBranchIndex],
      yearGanZhi: yearGanZhi,
      solarTerm: localSolarTerm,
      solarTermTime: localSolarTermTime,
      moonPhase: displayInfo.moonPhase,
      constellation: displayInfo.constellation,
      star28: star28,
      festivals: festivals,
      info: metaInfo, // 命理计算使用 metaInfo
      timePack: timePack,
      monthBranchIndex: monthBranchIndex,
      yearGanZhiIndex: yearGanZhi.index,
      seasonIndex: seasonIndex,
      monthSeasonTypeIndex: monthSeasonTypeIndex,
      isSiJue: isSiJue,
      isSiLi: isSiLi,
      nextSolarTermIndex: nextSolarTermIndex,
      exactJieQiTime: exactJieQiTime,
    );
  }

  /// 汇总输出一整天的黄历完整文本报表
  @override
  String toString() {
    return 'HuangliDay(${solarDate.year}-${solarDate.month}-${solarDate.day}, $ganZhi日)';
  }

  /// 简单的汇总输出（非格式化，仅供调试）
  String toAlmanacString() {
    return [
      '日期: ${solarDate.year}-${solarDate.month}-${solarDate.day} (星期$weekday)',
      '农历: $lunarDate (${yearGanZhi.toString()}年 ${monthGanZhi.toString()}月 ${ganZhi.toString()}日)',
      '节气: $solarTerm',
      '星宿月相: $star28宿 $constellation $moonPhase',
      '神煞: $shenSha',
      '宜忌: $yiJi',
      '星象: $astro',
    ].join('\n');
  }
}
