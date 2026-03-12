import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/src/calculators/festival_calc.dart';

void main() {
  group('FestivalCalculator', () {
    group('getFestivals', () {
      test('returns solar legal holiday - New Year', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 1,
          solarDay: 1,
          lunarMonth: 11,
          lunarDay: 10,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('元旦节'));
      });

      test('returns solar legal holiday - Labor Day', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 5,
          solarDay: 1,
          lunarMonth: 3,
          lunarDay: 15,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('国际劳动节'));
      });

      test('returns solar legal holiday - National Day', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 10,
          solarDay: 1,
          lunarMonth: 8,
          lunarDay: 15,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('国庆节'));
      });

      test('returns lunar legal holiday - Spring Festival', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 10,
          lunarMonth: 1,
          lunarDay: 1,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('春节'));
      });

      test('returns lunar legal holiday - Dragon Boat Festival', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 6,
          solarDay: 10,
          lunarMonth: 5,
          lunarDay: 5,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('端午节'));
      });

      test('returns lunar legal holiday - Mid-Autumn Festival', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 9,
          solarDay: 15,
          lunarMonth: 8,
          lunarDay: 15,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('中秋节'));
      });

      test('skips lunar holidays during leap month', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 10,
          lunarMonth: 1,
          lunarDay: 1,
          isLeapMonth: true,
          isLastLunarDay: false,
        );

        expect(festivals, isNot(contains('春节')));
      });

      test('returns solar term festival - Qingming', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 4,
          solarDay: 5,
          lunarMonth: 3,
          lunarDay: 3,
          isLeapMonth: false,
          isLastLunarDay: false,
          solarTerm: '清明',
        );

        expect(festivals, contains('清明节'));
      });

      test('returns other solar holiday - Valentine\'s Day', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 14,
          lunarMonth: 1,
          lunarDay: 15,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('情人节'));
      });

      test('returns other lunar holiday - Lantern Festival', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 26,
          lunarMonth: 1,
          lunarDay: 15,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, contains('元宵节'));
      });

      test('handles Chinese New Year Eve on 29th (small month)', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 9,
          lunarMonth: 12,
          lunarDay: 29,
          isLeapMonth: false,
          isLastLunarDay: true,
        );

        expect(festivals, contains('除夕'));
      });

      test('handles Chinese New Year Eve on 30th (large month)', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 9,
          lunarMonth: 12,
          lunarDay: 30,
          isLeapMonth: false,
          isLastLunarDay: true,
        );

        expect(festivals, contains('除夕'));
      });

      test('does not return Eve when not last day of lunar month', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 2,
          solarDay: 9,
          lunarMonth: 12,
          lunarDay: 29,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, isNot(contains('除夕')));
      });

      test('returns empty list when no festivals', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 3,
          solarDay: 10,
          lunarMonth: 2,
          lunarDay: 10,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, isEmpty);
      });

      test('returns multiple festivals on same day', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 3,
          solarDay: 5,
          lunarMonth: 2,
          lunarDay: 5,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals.length, greaterThan(1));
        expect(festivals, contains('周恩来诞辰纪念日'));
        expect(festivals, contains('中国青年志愿者服务日'));
      });

      test('removes duplicate festivals', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 1,
          solarDay: 1,
          lunarMonth: 1,
          lunarDay: 1,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        final uniqueFestivals = festivals.toSet().toList();
        expect(festivals.length, equals(uniqueFestivals.length));
      });

      test('handles edge case - invalid month boundary', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 13,
          solarDay: 1,
          lunarMonth: 13,
          lunarDay: 1,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, isEmpty);
      });

      test('handles edge case - day 0', () {
        final festivals = FestivalCalculator.getFestivals(
          solarMonth: 1,
          solarDay: 0,
          lunarMonth: 1,
          lunarDay: 0,
          isLeapMonth: false,
          isLastLunarDay: false,
        );

        expect(festivals, isEmpty);
      });
    });
  });
}