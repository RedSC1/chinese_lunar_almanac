import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

void main() {
  group('HuangliDay', () {
    late TimePack timePack;
    late HuangliDay day;

    setUp(() {
      // Use a known date for consistent testing: 2026-03-11
      final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
      timePack = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
      day = HuangliDay.from(timePack);
    });

    group('basic properties', () {
      test('has correct solar date', () {
        expect(day.solarDate.year, equals(2026));
        expect(day.solarDate.month, equals(3));
        expect(day.solarDate.day, equals(11));
      });

      test('has lunar date', () {
        expect(day.lunarDate, isNotNull);
      });

      test('has weekday', () {
        expect(day.weekday, greaterThanOrEqualTo(0));
        expect(day.weekday, lessThan(7));
      });

      test('has GanZhi (day pillar)', () {
        expect(day.ganZhi, isNotNull);
        expect(day.ganZhi.gan, isNotNull);
        expect(day.ganZhi.zhi, isNotNull);
      });

      test('has month GanZhi', () {
        expect(day.monthGanZhi, isNotNull);
        expect(day.monthGanZhi.gan, isNotNull);
        expect(day.monthGanZhi.zhi, isNotNull);
      });

      test('has year GanZhi', () {
        expect(day.yearGanZhi, isNotNull);
        expect(day.yearGanZhi.gan, isNotNull);
        expect(day.yearGanZhi.zhi, isNotNull);
      });

      test('has constellation', () {
        expect(day.constellation, isNotEmpty);
      });

      test('has 28 stars mansion', () {
        expect(day.star28, isNotEmpty);
      });
    });

    group('festivals', () {
      test('returns festivals list', () {
        expect(day.festivals, isNotNull);
        expect(day.festivals, isList);
      });

      test('contains festivals on special dates', () {
        final newYear = AstroDateTime(2026, 1, 1, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: newYear, timezone: 8.0);
        final d = HuangliDay.from(tp);
        expect(d.festivals, contains('元旦节'));
      });
    });

    group('deity and almanac properties', () {
      test('has pengZu', () {
        expect(day.pengZu, isNotEmpty);
      });

      test('has chongSha', () {
        expect(day.chongSha, isNotEmpty);
      });

      test('has jianChu', () {
        expect(day.jianChu, isNotNull);
      });

      test('has taiShen', () {
        expect(day.taiShen, isNotEmpty);
      });

      test('has god directions', () {
        expect(day.godDirections, isNotEmpty);
        expect(day.godDirections, isMap);
      });

      test('has auspicious gods list', () {
        expect(day.auspiciousGods, isNotNull);
        expect(day.auspiciousGods, isList);
      });

      test('has inauspicious gods list', () {
        expect(day.inauspiciousGods, isNotNull);
        expect(day.inauspiciousGods, isList);
      });
    });

    group('activities', () {
      test('has suitable activities', () {
        expect(day.suitableActivities, isNotNull);
        expect(day.suitableActivities, isList);
        expect(day.suitableActivities, isNotEmpty);
      });

      test('has taboo activities', () {
        expect(day.tabooActivities, isNotNull);
        expect(day.tabooActivities, isList);
        expect(day.tabooActivities, isNotEmpty);
      });

      test('suitable and taboo activities are different', () {
        final allSuitable = day.suitableActivities.toSet();
        final allTaboo = day.tabooActivities.toSet();

        // Should not have complete overlap
        expect(allSuitable, isNot(equals(allTaboo)));
      });
    });

    group('astrology', () {
      test('has daily flying star', () {
        expect(day.dailyFlyingStar, isNotNull);
        expect(day.dailyFlyingStar.stars, hasLength(9));
      });

      test('has sanYuan', () {
        expect(day.sanYuan, isNotNull);
      });

      test('has jiuYun', () {
        expect(day.jiuYun, isNotNull);
      });

      test('has naYin', () {
        expect(day.naYin, isNotEmpty);
      });

      test('has naYinWuXing', () {
        expect(day.naYinWuXing, isNotEmpty);
      });
    });

    group('hours', () {
      test('dayHours returns 12 hours', () {
        expect(day.dayHours, hasLength(12));
      });

      test('all hours have valid properties', () {
        for (var hour in day.dayHours) {
          expect(hour.ganZhi, isNotNull);
          expect(hour.index, greaterThanOrEqualTo(0));
          expect(hour.index, lessThan(12));
          expect(hour.twelveGod, isNotNull);
          expect(hour.name, isNotEmpty);
        }
      });

      test('hours are in correct order', () {
        final expectedOrder = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
        for (int i = 0; i < 12; i++) {
          expect(day.dayHours[i].zhiName, equals(expectedOrder[i]));
        }
      });
    });

    group('lazy loading', () {
      test('shenSha is computed on first access', () {
        // Access multiple times to ensure it's cached
        final shenSha1 = day.shenSha;
        final shenSha2 = day.shenSha;
        expect(identical(shenSha1, shenSha2), isTrue);
      });

      test('yiJi is computed on first access', () {
        final yiJi1 = day.yiJi;
        final yiJi2 = day.yiJi;
        expect(identical(yiJi1, yiJi2), isTrue);
      });

      test('astro is computed on first access', () {
        final astro1 = day.astro;
        final astro2 = day.astro;
        expect(identical(astro1, astro2), isTrue);
      });
    });

    group('toString', () {
      test('toString contains basic info', () {
        final str = day.toString();
        expect(str, contains('HuangliDay'));
        expect(str, contains('2026'));
        expect(str, contains('3'));
        expect(str, contains('11'));
      });

      test('toAlmanacString contains comprehensive info', () {
        final str = day.toAlmanacString();
        expect(str, contains('日期'));
        expect(str, contains('农历'));
        expect(str, contains('星宿'));
      });
    });

    group('different dates', () {
      test('handles spring festival correctly', () {
        // 2026 Spring Festival is on Feb 17
        final springFestival = AstroDateTime(2026, 2, 17, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: springFestival, timezone: 8.0);
        final d = HuangliDay.from(tp);
        expect(d.festivals, contains('春节'));
      });

      test('handles different timezones', () {
        final utcTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp1 = TimePack.createBySolarTime(clockTime: utcTime, timezone: 0.0);
        final tp2 = TimePack.createBySolarTime(clockTime: utcTime, timezone: 8.0);

        final day1 = HuangliDay.from(tp1);
        final day2 = HuangliDay.from(tp2);

        // Different timezones may result in different dates
        expect(day1.solarDate, isNotNull);
        expect(day2.solarDate, isNotNull);
      });

      test('handles midnight correctly without split rat hour', () {
        final midnight = AstroDateTime(2026, 3, 11, 23, 30, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: midnight,
          timezone: 8.0,
          splitRatHour: false,
        );
        final d = HuangliDay.from(tp);
        expect(d.ganZhi, isNotNull);
      });

      test('handles midnight correctly with split rat hour', () {
        final midnight = AstroDateTime(2026, 3, 11, 23, 30, 0);
        final tp = TimePack.createBySolarTime(
          clockTime: midnight,
          timezone: 8.0,
          splitRatHour: true,
        );
        final d = HuangliDay.from(tp);
        expect(d.ganZhi, isNotNull);
      });
    });

    group('exact jieqi time mode', () {
      test('handles exact jieqi time mode', () {
        final testTime = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final d = HuangliDay.from(tp, exactJieQiTime: true);

        expect(d.monthGanZhi, isNotNull);
        expect(d.yearGanZhi, isNotNull);
      });

      test('exact mode may differ from default mode', () {
        final testTime = AstroDateTime(2026, 3, 6, 8, 0, 0); // Around Jingzhe
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);

        final dayDefault = HuangliDay.from(tp, exactJieQiTime: false);
        final dayExact = HuangliDay.from(tp, exactJieQiTime: true);

        // Both should be valid
        expect(dayDefault.monthGanZhi, isNotNull);
        expect(dayExact.monthGanZhi, isNotNull);
      });
    });

    group('regression tests', () {
      test('handles year boundary correctly', () {
        final newYearEve = AstroDateTime(2025, 12, 31, 23, 59, 0);
        final tp = TimePack.createBySolarTime(clockTime: newYearEve, timezone: 8.0);
        final d = HuangliDay.from(tp);

        expect(d.solarDate.year, equals(2025));
        expect(d.solarDate.month, equals(12));
        expect(d.solarDate.day, equals(31));
      });

      test('handles leap month correctly', () {
        // Just ensure it doesn't crash with leap months
        final testTime = AstroDateTime(2023, 4, 20, 12, 0, 0); // Around potential leap month
        final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
        final d = HuangliDay.from(tp);

        expect(d.lunarDate, isNotNull);
      });

      test('different days produce different results', () {
        final day1Time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final day2Time = AstroDateTime(2026, 3, 12, 12, 0, 0);

        final tp1 = TimePack.createBySolarTime(clockTime: day1Time, timezone: 8.0);
        final tp2 = TimePack.createBySolarTime(clockTime: day2Time, timezone: 8.0);

        final d1 = HuangliDay.from(tp1);
        final d2 = HuangliDay.from(tp2);

        expect(d1.ganZhi.index, isNot(equals(d2.ganZhi.index)));
      });
    });
  });
}