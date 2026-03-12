import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/src/calculators/jian_chu_calc.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

void main() {
  group('JianChu', () {
    group('constants', () {
      test('has correct number of values', () {
        expect(JianChu.values.length, equals(12));
      });

      test('values have correct indices', () {
        for (int i = 0; i < JianChu.values.length; i++) {
          expect(JianChu.values[i].index, equals(i));
        }
      });

      test('values have correct names', () {
        final expectedNames = ['建', '除', '满', '平', '定', '执', '破', '危', '成', '收', '开', '闭'];
        for (int i = 0; i < JianChu.values.length; i++) {
          expect(JianChu.values[i].name, equals(expectedNames[i]));
        }
      });

      test('HuangDao values are correct according to formula', () {
        // 建满平收黑，除定执危开成黄
        final expectedHuangDao = [false, true, false, false, true, true, false, true, true, false, true, false];
        for (int i = 0; i < JianChu.values.length; i++) {
          expect(JianChu.values[i].isHuangDao, equals(expectedHuangDao[i]),
              reason: '${JianChu.values[i].name} should be ${expectedHuangDao[i] ? "HuangDao" : "HeiDao"}');
        }
      });
    });

    group('calculate', () {
      test('calculates Jian when day branch equals month branch', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.zi);
        expect(result.index, equals(0));
        expect(result.name, equals('建'));
      });

      test('calculates Chu when day branch is one after month branch', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.chou);
        expect(result.index, equals(1));
        expect(result.name, equals('除'));
      });

      test('calculates Man when day branch is two after month branch', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.yin);
        expect(result.index, equals(2));
        expect(result.name, equals('满'));
      });

      test('wraps around correctly at year boundary', () {
        final result = JianChu.calculate(DiZhi.hai, DiZhi.zi);
        expect(result.index, equals(1));
        expect(result.name, equals('除'));
      });

      test('handles full cycle correctly', () {
        final monthZhi = DiZhi.yin;
        for (int i = 0; i < 12; i++) {
          final dayZhi = DiZhi.values[i];
          final result = JianChu.calculate(monthZhi, dayZhi);
          final expectedIndex = (i - monthZhi.index + 12) % 12;
          expect(result.index, equals(expectedIndex));
        }
      });

      test('returns correct HuangDao status for Jian', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.zi);
        expect(result.isHuangDao, isFalse);
      });

      test('returns correct HuangDao status for Chu', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.chou);
        expect(result.isHuangDao, isTrue);
      });

      test('returns correct HuangDao status for Po', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.wu);
        expect(result.name, equals('破'));
        expect(result.isHuangDao, isFalse);
      });

      test('toString includes name and HuangDao status', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.zi);
        expect(result.toString(), contains('建'));
        expect(result.toString(), contains('黑道'));
      });

      test('toString for HuangDao day', () {
        final result = JianChu.calculate(DiZhi.zi, DiZhi.chou);
        expect(result.toString(), contains('除'));
        expect(result.toString(), contains('黄道'));
      });
    });

    group('edge cases', () {
      test('handles all combinations of month and day branches', () {
        for (final monthZhi in DiZhi.values) {
          for (final dayZhi in DiZhi.values) {
            final result = JianChu.calculate(monthZhi, dayZhi);
            expect(result.index, greaterThanOrEqualTo(0));
            expect(result.index, lessThan(12));
            expect(result.name, isNotEmpty);
          }
        }
      });

      test('calculation is consistent', () {
        final result1 = JianChu.calculate(DiZhi.mao, DiZhi.si);
        final result2 = JianChu.calculate(DiZhi.mao, DiZhi.si);
        expect(result1.index, equals(result2.index));
        expect(result1.name, equals(result2.name));
        expect(result1.isHuangDao, equals(result2.isHuangDao));
      });
    });
  });
}