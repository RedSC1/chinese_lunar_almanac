import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

void main() {
  group('HuangliHour', () {
    late HuangliHour ziHour;
    late HuangliHour wuHour;

    setUp(() {
      // Get a sample day to extract hours from
      final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
      final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
      final day = HuangliDay.from(tp);
      final hours = day.dayHours;

      ziHour = hours[0]; // 子时
      wuHour = hours[6]; // 午时
    });

    group('basic properties', () {
      test('has valid ganZhi', () {
        expect(ziHour.ganZhi, isNotNull);
        expect(ziHour.ganZhi.gan, isNotNull);
        expect(ziHour.ganZhi.zhi, isNotNull);
      });

      test('has correct index', () {
        expect(ziHour.index, equals(0));
        expect(wuHour.index, equals(6));
      });

      test('has twelve god', () {
        expect(ziHour.twelveGod, isNotNull);
        expect(wuHour.twelveGod, isNotNull);
      });

      test('has god name', () {
        expect(ziHour.godName, isNotEmpty);
        expect(wuHour.godName, isNotEmpty);
      });

      test('has name', () {
        expect(ziHour.name, isNotEmpty);
        expect(wuHour.name, isNotEmpty);
      });

      test('has zhi name', () {
        expect(ziHour.zhiName, equals('子'));
        expect(wuHour.zhiName, equals('午'));
      });

      test('has naYin', () {
        expect(ziHour.naYin, isNotEmpty);
        expect(wuHour.naYin, isNotEmpty);
      });

      test('has naYinWuXing', () {
        expect(ziHour.naYinWuXing, isNotEmpty);
        expect(wuHour.naYinWuXing, isNotEmpty);
      });
    });

    group('huang dao status', () {
      test('isHuangDao returns boolean', () {
        expect(ziHour.isHuangDao, isA<bool>());
        expect(wuHour.isHuangDao, isA<bool>());
      });

      test('huang dao status is consistent', () {
        final isHuangDao1 = ziHour.isHuangDao;
        final isHuangDao2 = ziHour.isHuangDao;
        expect(isHuangDao1, equals(isHuangDao2));
      });
    });

    group('time range', () {
      test('zi hour starts at 23:00', () {
        expect(ziHour.startHour, equals(23));
      });

      test('zi hour ends at 01:00', () {
        expect(ziHour.endHour, equals(1));
      });

      test('wu hour starts at 11:00', () {
        expect(wuHour.startHour, equals(11));
      });

      test('wu hour ends at 13:00', () {
        expect(wuHour.endHour, equals(13));
      });

      test('time range is formatted correctly', () {
        expect(ziHour.timeRange, equals('23:00 - 01:00'));
        expect(wuHour.timeRange, equals('11:00 - 13:00'));
      });

      test('all hours have 2-hour spans', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final day = HuangliDay.from(tp);

        for (final hour in day.dayHours) {
          final start = hour.startHour;
          final end = hour.endHour;

          // Calculate the difference considering wraparound
          final diff = (end - start + 24) % 24;
          expect(diff, equals(2), reason: 'Hour ${hour.zhiName} should have 2-hour span');
        }
      });
    });

    group('isCurrent', () {
      test('zi hour is current at 23:00', () {
        expect(ziHour.isCurrent(23), isTrue);
      });

      test('zi hour is current at 00:00', () {
        expect(ziHour.isCurrent(0), isTrue);
      });

      test('zi hour is not current at 02:00', () {
        expect(ziHour.isCurrent(2), isFalse);
      });

      test('wu hour is current at 11:00', () {
        expect(wuHour.isCurrent(11), isTrue);
      });

      test('wu hour is current at 12:00', () {
        expect(wuHour.isCurrent(12), isTrue);
      });

      test('wu hour is not current at 13:00', () {
        expect(wuHour.isCurrent(13), isFalse);
      });

      test('wu hour is not current at 10:00', () {
        expect(wuHour.isCurrent(10), isFalse);
      });
    });

    group('all twelve hours', () {
      late List<HuangliHour> hours;

      setUp(() {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final day = HuangliDay.from(tp);
        hours = day.dayHours;
      });

      test('has exactly 12 hours', () {
        expect(hours, hasLength(12));
      });

      test('indices are sequential', () {
        for (int i = 0; i < 12; i++) {
          expect(hours[i].index, equals(i));
        }
      });

      test('zhi names are in correct order', () {
        final expectedNames = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
        for (int i = 0; i < 12; i++) {
          expect(hours[i].zhiName, equals(expectedNames[i]));
        }
      });

      test('all hours have unique time ranges', () {
        final ranges = hours.map((h) => h.timeRange).toSet();
        expect(ranges, hasLength(12));
      });

      test('time ranges cover full 24 hours', () {
        // Collect all hours that are "current" for each hour of the day
        for (int h = 0; h < 24; h++) {
          final currentHours = hours.where((hour) => hour.isCurrent(h)).toList();
          expect(currentHours, hasLength(1), reason: 'Hour $h should belong to exactly one time period');
        }
      });
    });

    group('toString', () {
      test('contains zhi name', () {
        expect(ziHour.toString(), contains('子'));
        expect(wuHour.toString(), contains('午'));
      });

      test('contains gan-zhi name', () {
        expect(ziHour.toString(), contains(ziHour.name));
        expect(wuHour.toString(), contains(wuHour.name));
      });

      test('contains time range', () {
        expect(ziHour.toString(), contains('23:00'));
        expect(ziHour.toString(), contains('01:00'));
      });
    });

    group('edge cases', () {
      test('handles different days with different hour gan-zhi', () {
        final day1Time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final day2Time = AstroDateTime(2026, 3, 12, 12, 0, 0);

        final tp1 = TimePack.createBySolarTime(clockTime: day1Time, timezone: 8.0);
        final tp2 = TimePack.createBySolarTime(clockTime: day2Time, timezone: 8.0);

        final day1 = HuangliDay.from(tp1);
        final day2 = HuangliDay.from(tp2);

        // The gan of the hours should differ between days
        expect(day1.dayHours[0].ganZhi.gan.index, isNot(equals(day2.dayHours[0].ganZhi.gan.index)));
      });

      test('hour properties are immutable-like', () {
        final name1 = ziHour.name;
        final name2 = ziHour.name;
        expect(name1, equals(name2));

        final range1 = ziHour.timeRange;
        final range2 = ziHour.timeRange;
        expect(range1, equals(range2));
      });
    });

    group('regression tests', () {
      test('no hour spans across more than 2 hours', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final day = HuangliDay.from(tp);

        for (final hour in day.dayHours) {
          // Count how many hours are considered "current"
          int currentCount = 0;
          for (int h = 0; h < 24; h++) {
            if (hour.isCurrent(h)) {
              currentCount++;
            }
          }
          expect(currentCount, equals(2), reason: 'Hour ${hour.zhiName} should cover exactly 2 hours');
        }
      });

      test('consecutive hours have adjacent time ranges', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final day = HuangliDay.from(tp);

        for (int i = 0; i < 11; i++) {
          final currentEnd = day.dayHours[i].endHour;
          final nextStart = day.dayHours[i + 1].startHour;

          // They should be adjacent (considering 24-hour wraparound)
          expect((currentEnd + 1) % 24, anyOf(equals(nextStart), equals((nextStart + 1) % 24)));
        }
      });
    });
  });
}