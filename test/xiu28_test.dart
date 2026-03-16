import 'package:chinese_lunar_almanac/src/calculators/xiu_28_lunar_mansion_calc.dart';
import 'package:test/test.dart';

void main() {
  group('LunarMansion', () {
    test('contains 28 unique mansions in standard order', () {
      expect(LunarMansion.mansions, hasLength(28));

      final fullNames = LunarMansion.mansions.map((m) => m.fullName).toList();
      expect(fullNames.toSet(), hasLength(28));
      expect(fullNames.first, '角木蛟');
      expect(fullNames.last, '轸水蚓');
    });

    test('uses 胃宿 as the J2000 day 0 baseline', () {
      final mansion = LunarMansion.calculateFromJulianDay(0);

      expect(mansion.name, '胃');
      expect(mansion.fullName, '胃土雉');
      expect(mansion.direction, '西方白虎');
      expect(mansion.isGood, isTrue);
    });

    test('advances one mansion per day and repeats every 28 days', () {
      expect(LunarMansion.calculateFromJulianDay(1).fullName, '昴日鸡');
      expect(LunarMansion.calculateFromJulianDay(2).fullName, '毕月乌');
      expect(LunarMansion.calculateFromJulianDay(28).fullName, '胃土雉');
      expect(LunarMansion.calculateFromJulianDay(-1).fullName, '娄金狗');
    });
  });
}
