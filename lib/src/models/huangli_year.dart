import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

/// 黄历年历对象 (按公历年组织)
///
/// 内部按需构造 12 个 [HuangliMonth]，提供按年聚合的便捷访问。
///
/// ```dart
/// final year = HuangliYear.from(year: 2026);
/// print(year.month(3).day(16).ganZhi); // 3月16日的日柱
/// print(year[2].length); // 3月天数 (0-based, index 2 = 3月)
/// ```
class HuangliYear {
  final int year;
  final double timezone;
  final RatHourMode ratHourMode;
  final bool exactJieQiTime;

  late final List<HuangliMonth> months = _buildMonths();

  HuangliYear._({
    required this.year,
    required this.timezone,
    required this.ratHourMode,
    required this.exactJieQiTime,
  });

  factory HuangliYear.from({
    required int year,
    double timezone = 8.0,
    RatHourMode ratHourMode = RatHourMode.noSplit,
    bool exactJieQiTime = false,
  }) {
    return HuangliYear._(
      year: year,
      timezone: timezone,
      ratHourMode: ratHourMode,
      exactJieQiTime: exactJieQiTime,
    );
  }

  List<HuangliMonth> _buildMonths() {
    return List.generate(12, (i) {
      return HuangliMonth.from(
        year: year,
        month: i + 1,
        timezone: timezone,
        ratHourMode: ratHourMode,
        exactJieQiTime: exactJieQiTime,
      );
    });
  }

  /// 按 0-based 索引取月 (0 = 1月)
  HuangliMonth operator [](int index) => months[index];

  /// 按公历月取 (1-based)
  HuangliMonth month(int solarMonth) {
    if (solarMonth < 1 || solarMonth > 12) {
      throw RangeError.range(solarMonth, 1, 12, 'solarMonth');
    }
    return months[solarMonth - 1];
  }

  /// 全年天数
  int get totalDays => months.fold(0, (sum, m) => sum + m.length);

  /// 是否闰年
  bool get isLeapYear => DateTime(year, 2, 29).month == 2;

  /// 全年所有节日 (去重)
  List<String> get festivalsInYear {
    final set = <String>{};
    for (final m in months) {
      set.addAll(m.festivalsInMonth);
    }
    return set.toList();
  }

  /// 全年节气列表 [(月, 日, 节气名)]
  List<({int month, int day, String name})> get solarTermsInYear {
    final result = <({int month, int day, String name})>[];
    for (final m in months) {
      for (final entry in m.solarTermsInMonth) {
        result.add((month: m.month, day: entry.key, name: entry.value));
      }
    }
    return result;
  }

  @override
  String toString() => 'HuangliYear($year, $totalDays days)';
}
