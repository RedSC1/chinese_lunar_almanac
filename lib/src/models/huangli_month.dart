import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import 'huangli_day.dart';

/// 黄历月历对象 (按公历月组织)
///
/// 内部逐日构造 [HuangliDay]，提供按月聚合的便捷访问。
///
/// ```dart
/// final month = HuangliMonth.from(year: 2026, month: 3);
/// print(month.length); // 31
/// print(month[0].ganZhi); // 第一天的日柱
/// print(month.day(16).ganZhi); // 3月16日的日柱
/// ```
class HuangliMonth {
  final int year;
  final int month;
  final double timezone;
  final bool splitRatHour;
  final bool exactJieQiTime;

  late final List<HuangliDay> days = _buildDays();

  HuangliMonth._({
    required this.year,
    required this.month,
    required this.timezone,
    required this.splitRatHour,
    required this.exactJieQiTime,
  });

  factory HuangliMonth.from({
    required int year,
    required int month,
    double timezone = 8.0,
    bool splitRatHour = false,
    bool exactJieQiTime = false,
  }) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Month must be between 1 and 12');
    }
    return HuangliMonth._(
      year: year,
      month: month,
      timezone: timezone,
      splitRatHour: splitRatHour,
      exactJieQiTime: exactJieQiTime,
    );
  }

  List<HuangliDay> _buildDays() {
    final int count = DateTime(year, month + 1, 0).day;
    return List.generate(count, (i) {
      final tp = TimePack.createBySolarTime(
        clockTime: AstroDateTime(year, month, i + 1, 12),
        timezone: timezone,
        splitByRatHour: splitRatHour,
      );
      return HuangliDay.from(tp, exactJieQiTime: exactJieQiTime);
    });
  }

  /// 当月天数
  int get length => days.length;

  /// 按 0-based 索引取天
  HuangliDay operator [](int index) => days[index];

  /// 按公历日取 (1-based)
  HuangliDay day(int solarDay) {
    if (solarDay < 1 || solarDay > length) {
      throw RangeError.range(solarDay, 1, length, 'solarDay');
    }
    return days[solarDay - 1];
  }

  /// 当月1号星期几 (1=周一, 7=周日)
  int get firstWeekday => DateTime(year, month, 1).weekday;

  /// 当月所有节日 (去重)
  List<String> get festivalsInMonth {
    final set = <String>{};
    for (final d in days) {
      set.addAll(d.festivals);
    }
    return set.toList();
  }

  /// 当月节气列表 [(公历日, 节气名)]
  List<MapEntry<int, String>> get solarTermsInMonth {
    final result = <MapEntry<int, String>>[];
    for (final d in days) {
      if (d.solarTerm != null) {
        result.add(MapEntry(d.solarDate.day, d.solarTerm!));
      }
    }
    return result;
  }

  @override
  String toString() => 'HuangliMonth($year-$month, $length days)';
}
