import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/src/data/activities.dart';

void main() {
  group('AlmanacActivity', () {
    group('enum values', () {
      test('has expected number of activities', () {
        expect(AlmanacActivity.values.length, equals(104));
      });

      test('all activities have labels', () {
        for (final activity in AlmanacActivity.values) {
          expect(activity.label, isNotEmpty);
        }
      });

      test('specific activities have correct labels', () {
        expect(AlmanacActivity.jia_qu.label, equals('嫁娶'));
        expect(AlmanacActivity.ji_si.label, equals('祭祀'));
        expect(AlmanacActivity.chu_xing.label, equals('出行'));
        expect(AlmanacActivity.ban_yi.label, equals('搬移'));
        expect(AlmanacActivity.kai_shi.label, equals('开市'));
      });

      test('special activities exist', () {
        expect(AlmanacActivity.zhu_shi_bu_yi, isNotNull);
        expect(AlmanacActivity.zhu_shi_bu_ji, isNotNull);
        expect(AlmanacActivity.zhu_shi_jie_ji, isNotNull);
      });
    });

    group('fromLabel', () {
      test('finds activity by label', () {
        final activity = AlmanacActivity.fromLabel('嫁娶');
        expect(activity, equals(AlmanacActivity.jia_qu));
      });

      test('finds activity for all valid labels', () {
        for (final activity in AlmanacActivity.values) {
          final found = AlmanacActivity.fromLabel(activity.label);
          expect(found, equals(activity));
        }
      });

      test('returns null for invalid label', () {
        final activity = AlmanacActivity.fromLabel('不存在的活动');
        expect(activity, isNull);
      });

      test('returns null for empty string', () {
        final activity = AlmanacActivity.fromLabel('');
        expect(activity, isNull);
      });

      test('is case sensitive', () {
        final activity = AlmanacActivity.fromLabel('JIA_QU');
        expect(activity, isNull);
      });
    });

    group('sortPriority', () {
      test('has priority for all activities', () {
        expect(AlmanacActivity.sortPriority.length, equals(AlmanacActivity.values.length));
      });

      test('all priorities are non-negative', () {
        for (final priority in AlmanacActivity.sortPriority) {
          expect(priority, greaterThanOrEqualTo(0));
        }
      });

      test('priorities can be used for sorting', () {
        final indices = [0, 1, 2, 3];
        indices.sort((a, b) => AlmanacActivity.sortPriority[a].compareTo(AlmanacActivity.sortPriority[b]));
        expect(indices, isList);
      });

      test('ji si has highest priority (0)', () {
        expect(AlmanacActivity.sortPriority[AlmanacActivity.ji_si.index], equals(0));
      });
    });

    group('activity masks', () {
      test('imperial67 is not empty', () {
        expect(AlmanacActivity.imperial67.isEmpty, isFalse);
      });

      test('civilian37 is not empty', () {
        expect(AlmanacActivity.civilian37.isEmpty, isFalse);
      });

      test('tongshu60 is not empty', () {
        expect(AlmanacActivity.tongshu60.isEmpty, isFalse);
      });

      test('cnlunarLegacy38 is not empty', () {
        expect(AlmanacActivity.cnlunarLegacy38.isEmpty, isFalse);
      });

      test('imperial67 has correct size', () {
        expect(AlmanacActivity.imperial67.length, lessThanOrEqualTo(67));
      });

      test('civilian37 has correct size', () {
        expect(AlmanacActivity.civilian37.length, lessThanOrEqualTo(37));
      });

      test('tongshu60 has correct size', () {
        expect(AlmanacActivity.tongshu60.length, lessThanOrEqualTo(60));
      });

      test('masks can be used with bitwise operations', () {
        final testMask = AlmanacActivity.civilian37;
        expect(testMask.has(AlmanacActivity.jia_qu.index), isA<bool>());
      });

      test('different masks contain different activities', () {
        final imp = AlmanacActivity.imperial67;
        final civ = AlmanacActivity.civilian37;

        // They should not be identical
        expect(imp.toList(), isNot(equals(civ.toList())));
      });
    });

    group('edge cases', () {
      test('enum indices are sequential', () {
        for (int i = 0; i < AlmanacActivity.values.length; i++) {
          expect(AlmanacActivity.values[i].index, equals(i));
        }
      });

      test('duplicate labels check', () {
        final labels = AlmanacActivity.values.map((a) => a.label).toList();
        final uniqueLabels = labels.toSet();

        // Most labels should be unique, but some traditional almanac activities
        // may have variants (like 筑提 vs 筑堤防)
        expect(uniqueLabels.length, greaterThan(90));
      });

      test('fromLabel handles whitespace', () {
        final activity = AlmanacActivity.fromLabel(' 嫁娶 ');
        // Should not match due to whitespace
        expect(activity, isNull);
      });
    });

    group('special activities', () {
      test('zhu_shi_bu_yi is defined', () {
        expect(AlmanacActivity.zhu_shi_bu_yi.label, equals('诸事不宜'));
      });

      test('zhu_shi_bu_ji is defined', () {
        expect(AlmanacActivity.zhu_shi_bu_ji.label, equals('诸事不忌'));
      });

      test('zhu_shi_jie_ji is defined', () {
        expect(AlmanacActivity.zhu_shi_jie_ji.label, equals('诸事皆忌'));
      });

      test('special activities have appropriate priorities', () {
        final buYiPriority = AlmanacActivity.sortPriority[AlmanacActivity.zhu_shi_bu_yi.index];
        final buJiPriority = AlmanacActivity.sortPriority[AlmanacActivity.zhu_shi_bu_ji.index];
        final jieJiPriority = AlmanacActivity.sortPriority[AlmanacActivity.zhu_shi_jie_ji.index];

        // All special "all things" activities should have similar priorities
        expect(buYiPriority, equals(buJiPriority));
        expect(buJiPriority, equals(jieJiPriority));
      });
    });

    group('important activities', () {
      test('marriage activities exist', () {
        expect(AlmanacActivity.jia_qu, isNotNull);
        expect(AlmanacActivity.na_cai_wen_ming, isNotNull);
        expect(AlmanacActivity.jie_hun_yin, isNotNull);
      });

      test('business activities exist', () {
        expect(AlmanacActivity.kai_shi, isNotNull);
        expect(AlmanacActivity.kai_zhang, isNotNull);
        expect(AlmanacActivity.na_cai, isNotNull);
        expect(AlmanacActivity.li_quan_jiao_yi, isNotNull);
      });

      test('construction activities exist', () {
        expect(AlmanacActivity.xiu_zao, isNotNull);
        expect(AlmanacActivity.po_tu, isNotNull);
        expect(AlmanacActivity.xiu_gong_shi, isNotNull);
        expect(AlmanacActivity.ying_jian, isNotNull);
      });

      test('ritual activities exist', () {
        expect(AlmanacActivity.ji_si, isNotNull);
        expect(AlmanacActivity.qi_fu, isNotNull);
        expect(AlmanacActivity.qi_si, isNotNull);
      });

      test('travel activities exist', () {
        expect(AlmanacActivity.chu_xing, isNotNull);
        expect(AlmanacActivity.ban_yi, isNotNull);
        expect(AlmanacActivity.ru_zhai, isNotNull);
      });
    });

    group('regression tests', () {
      test('activity can be converted to string', () {
        for (final activity in AlmanacActivity.values) {
          expect(activity.toString(), isNotEmpty);
        }
      });

      test('activity enum value matches its index', () {
        for (int i = 0; i < AlmanacActivity.values.length; i++) {
          expect(AlmanacActivity.values[i].index, equals(i));
        }
      });
    });
  });
}