import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';
import 'package:test/test.dart';

void main() {
  group('HuangliDay.dayHours', () {
    final tp = TimePack.createBySolarTime(
      clockTime: AstroDateTime(2026, 2, 17, 10, 30),
      timezone: 8.0,
    );
    final day = HuangliDay.from(tp);
    final hours = day.dayHours;

    test('returns 12 shichen in the conventional order', () {
      expect(hours, hasLength(12));
      expect(
        hours.map((h) => h.zhiName),
        orderedEquals(['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥']),
      );
    });

    test('represents zi hour as 23:00 to 01:00 and handles cross-day membership', () {
      final zi = hours.first;

      expect(zi.startHour, 23);
      expect(zi.endHour, 1);
      expect(zi.timeRange, '23:00 - 01:00');
      expect(zi.isCurrent(23), isTrue);
      expect(zi.isCurrent(0), isTrue);
      expect(zi.isCurrent(1), isFalse);
      expect(zi.isCurrent(22), isFalse);
    });

    test('covers every clock hour exactly once across 12 shichen', () {
      for (var hour = 0; hour < 24; hour++) {
        final matches = hours.where((item) => item.isCurrent(hour)).length;
        expect(
          matches,
          1,
          reason: 'clock hour $hour should belong to exactly one shichen',
        );
      }
    });
  });

  group('HuangliDay validated almanac case', () {
    final tp = TimePack.createBySolarTime(
      clockTime: AstroDateTime(2026, 3, 16, 10, 0, 0),
      timezone: 8.0,
      ratHourMode: RatHourMode.noSplit,
    );
    final day = HuangliDay.from(tp);

    test('matches basic almanac fields for 2026-03-16', () {
      expect(day.solarDate.year, 2026);
      expect(day.solarDate.month, 3);
      expect(day.solarDate.day, 16);
      expect(day.weekday, 1);

      expect(day.lunarDate.month, 1);
      expect(day.lunarDate.day, 28);
      expect(day.lunarDate.isLeap, isFalse);

      expect(day.yearGanZhi.toString(), '丙午');
      expect(day.monthGanZhi.toString(), '辛卯');
      expect(day.ganZhi.toString(), '己丑');
      expect(day.yearGanZhi.zhi.animal, '马');
      expect(day.naYin, '霹雳火');
    });

    test('matches non-yi-ji huangli display fields for 2026-03-16', () {
      expect(day.chongSha, '冲羊(乙未) 煞东');
      expect(day.shenSha.dayTwelveGod.name, '勾陈');
      expect(day.shenSha.jianChu.name, '开');
      expect(day.star28, '危月燕');
      expect(day.pengZu, '己不破券二比并亡，丑不冠带主不还乡');
      expect(
        day.dayHours.map((h) => h.isHuangDao ? 1 : 0).toList(),
        orderedEquals([0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1]),
      );
    });
  });
}
