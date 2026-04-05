import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'huangli_day.dart';
import 'huangli_month.dart';
import 'huangli_year.dart';

/// 黄历统一入口
///
/// 收口时区、早晚子时、精确节令等全局配置，避免每次调用都重复传参。
///
/// ```dart
/// final cal = HuangliCalendar(timezone: 8.0);
/// final day = cal.getDay(2026, 3, 16);
/// final month = cal.getMonth(2026, 3);
/// final year = cal.getYear(2026);
/// ```
class HuangliCalendar {
  final double timezone;
  final RatHourMode ratHourMode;
  final bool exactJieQiTime;

  const HuangliCalendar({
    this.timezone = 8.0,
    this.ratHourMode = RatHourMode.noSplit,
    this.exactJieQiTime = false,
  });

  /// 获取单日黄历
  HuangliDay getDay(int year, int month, int day, {int hour = 12}) {
    final tp = TimePack.createBySolarTime(
      clockTime: AstroDateTime(year, month, day, hour),
      timezone: timezone,
      ratHourMode: ratHourMode,
    );
    return HuangliDay.from(tp, exactJieQiTime: exactJieQiTime);
  }

  /// 获取月历
  HuangliMonth getMonth(int year, int month) {
    return HuangliMonth.from(
      year: year,
      month: month,
      timezone: timezone,
      ratHourMode: ratHourMode,
      exactJieQiTime: exactJieQiTime,
    );
  }

  /// 获取年历
  HuangliYear getYear(int year) {
    return HuangliYear.from(
      year: year,
      timezone: timezone,
      ratHourMode: ratHourMode,
      exactJieQiTime: exactJieQiTime,
    );
  }
}
