import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/src/utils/time_utils.dart';
import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

void main() {
  group('TimeUtils', () {
    group('jdToFixedIndex', () {
      test('converts JD to fixed index', () {
        final result = TimeUtils.jdToFixedIndex(0.0);
        expect(result, isA<int>());
      });

      test('same JD produces same index', () {
        final jd = 12345.6789;
        final index1 = TimeUtils.jdToFixedIndex(jd);
        final index2 = TimeUtils.jdToFixedIndex(jd);
        expect(index1, equals(index2));
      });

      test('different JDs on different days produce different indices', () {
        final jd1 = 12345.1;
        final jd2 = 12346.1;
        final index1 = TimeUtils.jdToFixedIndex(jd1);
        final index2 = TimeUtils.jdToFixedIndex(jd2);
        expect(index1, isNot(equals(index2)));
      });

      test('JDs on same day produce same index', () {
        final jd1 = 12345.1;
        final jd2 = 12345.8;
        final index1 = TimeUtils.jdToFixedIndex(jd1);
        final index2 = TimeUtils.jdToFixedIndex(jd2);
        expect(index1, equals(index2));
      });

      test('handles negative JD', () {
        final result = TimeUtils.jdToFixedIndex(-100.5);
        expect(result, isA<int>());
      });

      test('handles zero JD', () {
        final result = TimeUtils.jdToFixedIndex(0.0);
        expect(result, isA<int>());
      });

      test('handles large JD', () {
        final result = TimeUtils.jdToFixedIndex(1000000.5);
        expect(result, isA<int>());
      });
    });

    group('getFixedJdDaySafe', () {
      test('gets fixed day index for regular time', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(time, false);
        expect(index, isA<int>());
      });

      test('handles 23:00 without split rat hour', () {
        final time = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(time, false);
        expect(index, isA<int>());
      });

      test('handles 23:00 with split rat hour', () {
        final time = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final indexWithSplit = TimeUtils.getFixedJdDaySafe(time, true);
        final indexWithoutSplit = TimeUtils.getFixedJdDaySafe(time, false);

        // They should differ because 23:00 is treated differently
        expect(indexWithSplit, isNot(equals(indexWithoutSplit)));
      });

      test('handles 22:00 same way regardless of split rat hour', () {
        final time = AstroDateTime(2026, 3, 11, 22, 0, 0);
        final indexWithSplit = TimeUtils.getFixedJdDaySafe(time, true);
        final indexWithoutSplit = TimeUtils.getFixedJdDaySafe(time, false);

        expect(indexWithSplit, equals(indexWithoutSplit));
      });

      test('handles midnight', () {
        final time = AstroDateTime(2026, 3, 11, 0, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(time, false);
        expect(index, isA<int>());
      });

      test('consecutive days have consecutive indices', () {
        final time1 = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final time2 = AstroDateTime(2026, 3, 12, 12, 0, 0);

        final index1 = TimeUtils.getFixedJdDaySafe(time1, false);
        final index2 = TimeUtils.getFixedJdDaySafe(time2, false);

        expect(index2 - index1, equals(1));
      });

      test('same time on same day produces same index', () {
        final time1 = AstroDateTime(2026, 3, 11, 10, 0, 0);
        final time2 = AstroDateTime(2026, 3, 11, 14, 0, 0);

        final index1 = TimeUtils.getFixedJdDaySafe(time1, false);
        final index2 = TimeUtils.getFixedJdDaySafe(time2, false);

        expect(index1, equals(index2));
      });
    });

    group('getLocalMetaDayIdx', () {
      test('converts Beijing JD to local meta day index', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final bjJd = testTime.toJ2000();

        final index = TimeUtils.getLocalMetaDayIdx(bjJd, tp);
        expect(index, isA<int>());
      });

      test('handles different timezones', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final bjJd = testTime.toJ2000();

        final tp1 = TimePack.createBySolarTime(clockTime: testTime, timezone: 0.0);
        final tp2 = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);

        final index1 = TimeUtils.getLocalMetaDayIdx(bjJd, tp1);
        final index2 = TimeUtils.getLocalMetaDayIdx(bjJd, tp2);

        // Different timezones may map to different local days
        expect(index1, isA<int>());
        expect(index2, isA<int>());
      });

      test('handles split rat hour configuration', () {
        final testTime = AstroDateTime(2026, 3, 11, 23, 30, 0);
        final bjJd = testTime.toJ2000();

        final tp1 = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: false,
        );
        final tp2 = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: true,
        );

        final index1 = TimeUtils.getLocalMetaDayIdx(bjJd, tp1);
        final index2 = TimeUtils.getLocalMetaDayIdx(bjJd, tp2);

        expect(index1, isA<int>());
        expect(index2, isA<int>());
      });

      test('same Beijing moment maps consistently', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final bjJd = testTime.toJ2000();
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);

        final index1 = TimeUtils.getLocalMetaDayIdx(bjJd, tp);
        final index2 = TimeUtils.getLocalMetaDayIdx(bjJd, tp);

        expect(index1, equals(index2));
      });

      test('handles midnight edge case', () {
        final midnight = AstroDateTime(2026, 3, 11, 0, 0, 0);
        final bjJd = midnight.toJ2000();
        final tp = TimePack.createBySolarTime(clockTime: midnight, timezone: 8.0);

        final index = TimeUtils.getLocalMetaDayIdx(bjJd, tp);
        expect(index, isA<int>());
      });

      test('handles 23:00 edge case without split', () {
        final lateEvening = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final bjJd = lateEvening.toJ2000();
        final tp = TimePack.createBySolarTime(
          clockTime: lateEvening,
          timezone: 8.0,
          splitRatHour: false,
        );

        final index = TimeUtils.getLocalMetaDayIdx(bjJd, tp);
        expect(index, isA<int>());
      });

      test('handles 23:00 edge case with split', () {
        final lateEvening = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final bjJd = lateEvening.toJ2000();
        final tp = TimePack.createBySolarTime(
          clockTime: lateEvening,
          timezone: 8.0,
          splitRatHour: true,
        );

        final index = TimeUtils.getLocalMetaDayIdx(bjJd, tp);
        expect(index, isA<int>());
      });
    });

    group('edge cases', () {
      test('handles year boundary', () {
        final newYearEve = AstroDateTime(2025, 12, 31, 23, 59, 0);
        final index = TimeUtils.getFixedJdDaySafe(newYearEve, false);
        expect(index, isA<int>());
      });

      test('handles leap year date', () {
        final leapDay = AstroDateTime(2024, 2, 29, 12, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(leapDay, false);
        expect(index, isA<int>());
      });

      test('handles far future date', () {
        final farFuture = AstroDateTime(2100, 6, 15, 12, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(farFuture, false);
        expect(index, isA<int>());
      });

      test('handles far past date', () {
        final farPast = AstroDateTime(1900, 1, 1, 12, 0, 0);
        final index = TimeUtils.getFixedJdDaySafe(farPast, false);
        expect(index, isA<int>());
      });
    });
  });

  group('TimePackMeta extension', () {
    group('metaTime', () {
      test('returns virtual time when not in rat hour', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: false,
        );

        expect(tp.metaTime.hour, equals(12));
      });

      test('advances time when hour is 23 and split is false', () {
        final testTime = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: false,
        );

        expect(tp.metaTime.hour, equals(0));
        expect(tp.metaTime.day, equals(12));
      });

      test('does not advance time when hour is 23 and split is true', () {
        final testTime = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: true,
        );

        expect(tp.metaTime.hour, equals(23));
        expect(tp.metaTime.day, equals(11));
      });

      test('does not affect 22:00', () {
        final testTime = AstroDateTime(2026, 3, 11, 22, 0, 0);
        final tp1 = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: false,
        );
        final tp2 = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: true,
        );

        expect(tp1.metaTime.hour, equals(22));
        expect(tp2.metaTime.hour, equals(22));
      });

      test('metaTime is consistent on multiple calls', () {
        final testTime = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: false,
        );

        final meta1 = tp.metaTime;
        final meta2 = tp.metaTime;

        expect(meta1.hour, equals(meta2.hour));
        expect(meta1.day, equals(meta2.day));
      });

      test('handles year-end wraparound', () {
        final newYearEve = AstroDateTime(2025, 12, 31, 23, 30, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: newYearEve,
          timezone: 8.0,
          splitRatHour: false,
        );

        final meta = tp.metaTime;
        expect(meta.year, equals(2026));
        expect(meta.month, equals(1));
        expect(meta.day, equals(1));
      });

      test('handles month-end wraparound', () {
        final monthEnd = AstroDateTime(2026, 3, 31, 23, 30, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: monthEnd,
          timezone: 8.0,
          splitRatHour: false,
        );

        final meta = tp.metaTime;
        expect(meta.month, equals(4));
        expect(meta.day, equals(1));
      });
    });

    group('regression tests', () {
      test('metaTime matches virtualTime for non-rat hours', () {
        for (int hour = 0; hour < 23; hour++) {
          final testTime = AstroDateTime(2026, 3, 11, hour, 0, 0);
          final tp = TimePack.createBySolarTime(
            clockTime: testTime,
            timezone: 8.0,
            splitRatHour: false,
          );

          expect(tp.metaTime.hour, equals(tp.virtualTime.hour));
          expect(tp.metaTime.day, equals(tp.virtualTime.day));
        }
      });

      test('split rat hour preserves 23:00', () {
        final testTime = AstroDateTime(2026, 3, 11, 23, 0, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: testTime,
          timezone: 8.0,
          splitRatHour: true,
        );

        expect(tp.metaTime.hour, equals(23));
        expect(tp.virtualTime.hour, equals(23));
      });
    });
  });
}