// Generated file. Do not edit manually.
// Type H god rules: Complex dependencies (Year, Lunar Date, 28 Stars, etc.)
// Contains 23 rules.

import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../utils/fast_bitset.dart';
import 'gods.dart';

class TypeHGodRules {
  /// 不将 L758
  static const List<List<int>> bujiang = [
    [38, 28, 37, 27, 17, 26, 16, 13, 3, 53, 14, 4],
    [37, 27, 36, 26, 16, 13, 3, 12, 2, 52, 24, 14, 4],
    [47, 37, 27, 36, 26, 23, 13, 3, 12, 2, 24, 14],
    [46, 36, 26, 23, 13, 22, 12, 2, 11, 1, 34, 24, 14],
    [33, 23, 13, 22, 12, 21, 11, 1, 10, 0, 34, 24],
    [33, 23, 32, 22, 12, 21, 11, 20, 10, 0, 44, 34, 24],
    [32, 22, 31, 21, 11, 20, 10, 19, 9, 59, 44, 34],
    [31, 21, 30, 20, 10, 19, 9, 18, 8, 58, 54, 44, 34],
    [41, 31, 21, 30, 20, 29, 19, 9, 18, 8, 54, 44],
    [40, 30, 20, 29, 19, 28, 18, 8, 17, 7, 4, 54, 44],
    [39, 29, 19, 28, 18, 27, 17, 7, 16, 6, 4, 54],
    [39, 29, 38, 28, 18, 27, 17, 26, 16, 6, 14, 4, 54],
  ];

  /// 杨公忌日 (历月, 历日)
  static const List<List<int>> yangGongJi = [
    [1, 13],
    [2, 11],
    [3, 9],
    [4, 7],
    [5, 5],
    [6, 2],
    [7, 1],
    [7, 29],
    [8, 27],
    [9, 25],
    [10, 23],
    [11, 21],
    [12, 19],
  ];

  /// 计算某天的所有类型H神煞，返回 FastBitSet
  static FastBitSet calculate({
    required int monthIndex,
    required int dayGanZhiIndex,
    required int yearGanZhiIndex,
    required int lunarMonth,
    required int lunarDay,
    required int seasonIndex,
    required int monthSeasonTypeIndex, // 0:仲, 1:季, 2:孟
    required String day28Star,
    required AstroDateTime date,
    required bool isSiJue,
    required bool isSiLi,
    required bool isTuWangYongShi,
  }) {
    final activeGods = FastBitSet(171);
    final dayStem = dayGanZhiIndex % 10;
    final dayBranch = dayGanZhiIndex % 12;
    final yearStem = yearGanZhiIndex % 10;
    final yearBranch = yearGanZhiIndex % 12;

    // 1. 岁德 L714: 甲庚丙壬戊甲庚丙壬戊
    final suiDeStem = const [0, 6, 2, 8, 4, 0, 6, 2, 8, 4][yearStem];
    if (dayStem == suiDeStem) activeGods.add(AlmanacGod.sui_de.index);

    // 2. 岁德合 L717: 己乙辛丁癸己乙辛丁癸
    final suiDeHeStem = const [5, 1, 7, 3, 9, 5, 1, 7, 3, 9][yearStem];
    if (dayStem == suiDeHeStem) activeGods.add(AlmanacGod.sui_de_he.index);

    // 3. 天德 L735
    // 仲月(0) 看地支，孟(2)季(1) 看天干。
    if (monthSeasonTypeIndex == 0) {
      final branches = const [
        [5, 4],
        [],
        [],
        [8, 7],
        [],
        [],
        [11, 10],
        [],
        [],
        [2, 1],
        [],
        [],
      ][monthIndex];
      if (branches.contains(dayBranch))
        activeGods.add(AlmanacGod.tian_de.index);
    } else {
      final stems = const [-1, 6, 3, -1, 8, 7, -1, 0, 9, -1, 2, 1][monthIndex];
      if (dayStem == stems) activeGods.add(AlmanacGod.tian_de.index);
    }

    // 4. 天德合 L739: '空乙壬空丁丙空己戊空辛庚'
    final tTianDeHe = const [
      -1,
      1,
      8,
      -1,
      3,
      2,
      -1,
      5,
      4,
      -1,
      7,
      6,
    ][monthIndex];
    if (dayStem == tTianDeHe) activeGods.add(AlmanacGod.tian_de_he.index);

    // 5. 凤凰日 L743: '危昴胃毕'[sn]
    final fhStar = const ['危', '昴', '胃', '毕'][seasonIndex];
    if (day28Star.startsWith(fhStar))
      activeGods.add(AlmanacGod.feng_huang_ri.index);

    // 6. 麒麟日 L744: '井尾牛壁'[sn]
    final qlStar = const ['井', '尾', '牛', '壁'][seasonIndex];
    if (day28Star.startsWith(qlStar))
      activeGods.add(AlmanacGod.qi_lin_ri.index);

    // 7. 五合 L753: 寅卯
    if (dayBranch == 2 || dayBranch == 3)
      activeGods.add(AlmanacGod.wu_he.index);

    // 8. 不将 L758: bujiang[men]
    if (bujiang[monthIndex].contains(dayGanZhiIndex))
      activeGods.add(AlmanacGod.bu_jiang.index);

    // 9. 天喜 L777: '申酉戌亥子丑寅卯辰巳午未'[men] -> 匹配 dayBranch
    final txBranch = const [8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7][monthIndex];
    if (dayBranch == txBranch) activeGods.add(AlmanacGod.tian_xi.index);

    // 10. 明星 L808: '辰午甲戌子寅辰午甲戌子寅'[men] -> (0,4,8)=辰(4)午(6)子(0)寅(2)是地支，(2,6,10)=甲(0)戌(10)但这里是混排! '辰', '午', '甲', '戌', '子', '寅'
    // 0:辰(4地支), 1:午(6地支), 2:甲(0天干), 3:戌(10地支), 4:子(0地支), 5:寅(2地支)
    final mxVals = const [
      14,
      16,
      0,
      20,
      10,
      12,
      14,
      16,
      0,
      20,
      10,
      12,
    ]; // <10 is stem, >=10 is branch+10
    final mxVal = mxVals[monthIndex];
    if (mxVal < 10) {
      if (dayStem == mxVal) activeGods.add(AlmanacGod.ming_xing.index);
    } else {
      if (dayBranch == mxVal - 10) activeGods.add(AlmanacGod.ming_xing.index);
    }

    // 11. 兵吉 L832: match month
    final bingJiBranches = const [
      [2, 3, 4, 5],
      [1, 2, 3, 4],
      [0, 1, 2, 3],
      [11, 0, 1, 2],
      [10, 11, 0, 1],
      [9, 10, 11, 0],
      [8, 9, 10, 11],
      [7, 8, 9, 10],
      [6, 7, 8, 9],
      [5, 6, 7, 8],
      [4, 5, 6, 7],
      [3, 4, 5, 6],
    ];
    if (bingJiBranches[monthIndex].contains(dayBranch))
      activeGods.add(AlmanacGod.bing_ji.index);

    // 12. 伏兵 L844: '丙甲壬庚'[yen % 4] -> 匹配 dayStem
    final fuBingStem = const [2, 0, 8, 6][yearBranch % 4];
    if (dayStem == fuBingStem) activeGods.add(AlmanacGod.fu_bing.index);

    // 13. 月忌 L873: 5, 14, 23
    if (lunarDay == 5 || lunarDay == 14 || lunarDay == 23)
      activeGods.add(AlmanacGod.yue_ji.index);

    // 14. 杨公忌 L894
    for (final pair in yangGongJi) {
      if (pair[0] == lunarMonth && pair[1] == lunarDay) {
        activeGods.add(AlmanacGod.yang_gong_ji.index);
        break;
      }
    }

    // 15. 大祸 L901: '丁乙癸辛'[yen % 4] -> 匹配 dayStem
    final daHuoStem = const [3, 1, 9, 7][yearBranch % 4];
    if (dayStem == daHuoStem) activeGods.add(AlmanacGod.da_huo.index);

    // 16. 三娘煞 L941: 3, 7, 13, 18, 22, 27
    if (lunarDay == 3 ||
        lunarDay == 7 ||
        lunarDay == 13 ||
        lunarDay == 18 ||
        lunarDay == 22 ||
        lunarDay == 27) {
      activeGods.add(AlmanacGod.san_niang_sha.index);
    }

    // 17. 四绝
    if (isSiJue) activeGods.add(AlmanacGod.si_jue.index);
    // 18. 四离
    if (isSiLi) activeGods.add(AlmanacGod.si_li.index);
    // 19. 土王用事
    if (isTuWangYongShi) activeGods.add(AlmanacGod.tu_wang_yong_shi.index);

    // 20. 岁薄 L1001 (基于节气月，而非农历月。四月=巳月=3, 十月=亥月=9)
    if (monthIndex == 3 && (dayGanZhiIndex == 54 || dayGanZhiIndex == 42))
      activeGods.add(AlmanacGod.sui_bao.index);
    if (monthIndex == 9 && (dayGanZhiIndex == 48 || dayGanZhiIndex == 24))
      activeGods.add(AlmanacGod.sui_bao.index);

    // 21. 逐阵 L1002 (基于节气月。六月=未月=5, 十二月=丑月=11)
    if (monthIndex == 5 && (dayGanZhiIndex == 54 || dayGanZhiIndex == 42))
      activeGods.add(AlmanacGod.zhu_zhen.index);
    if (monthIndex == 11 && (dayGanZhiIndex == 48 || dayGanZhiIndex == 24))
      activeGods.add(AlmanacGod.zhu_zhen.index);

    // 22. 阴阳交破 L1003 (基于《堪舆经》: 四月(巳/3)癸亥(59), 十月(亥/9)丁巳(53))
    if (monthIndex == 3 && dayGanZhiIndex == 59)
      activeGods.add(AlmanacGod.yin_yang_jiao_po.index);
    if (monthIndex == 9 && dayGanZhiIndex == 53)
      activeGods.add(AlmanacGod.yin_yang_jiao_po.index);

    // 23. 重日 L1011
    if (dayBranch == 5 || dayBranch == 11)
      activeGods.add(AlmanacGod.chong_ri.index);

    // 24. 复日 L1012 (基于干支月)
    const fuRiMap = '甲乙戊丙丁巳庚辛戊壬癸巳'; // index = monthIndex (0=寅~11=丑)
    if (fuRiMap.length > monthIndex) {
      String targetChar = fuRiMap[monthIndex];
      String dayStemStr = "甲乙丙丁戊己庚辛壬癸"[dayGanZhiIndex % 10];
      String dayBranchStr = "子丑寅卯辰巳午未申酉戌亥"[dayBranch];
      if (targetChar == dayStemStr || targetChar == dayBranchStr) {
        activeGods.add(AlmanacGod.fu_ri.index);
      }
    }

    return activeGods;
  }
}
