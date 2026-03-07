/* -----------------------------------------------------------------------------
 * 【作者笔记】
 * @RedSC1
 * 时间：2026.3.7
 * 记录：关于历法引擎规则重构的行业乱象与工程决策
 * -------------------------------------------------------------------------- */

// 每日宜忌的部分同样来自cnlunar(https://github.com/OPN48/cnlunar)
// 我看了看原作《钦定协纪辨方书》，发现最后那个宜忌等第表有几个小地方对不上
// 原作的“德大会”“长生”“天破”是无效的字段，这几个判定条件永远都不会触发
// 我认为“德大会”应当是““月德”&&“阴阳大会””， “长生”应当是日支看月支是不是长生位
// 而“天破”在我看到的版本里根本就不存在
// 另外《钦定协纪辨方书》后面是有早就写好的“硬编码”的，是按照月支看日干支查表
// 理论上结果应该一样，但是实际上肯定不一样哈哈
// 时辰宜忌部分暂时不写了，我翻遍了《钦定协纪辨方书》并未找的明确的时辰宜忌记载
// 我不知道现在的商业软件的数据从哪来，这本书后面只有一个关于时辰神煞的表格，并且这些神煞
// 例如天乙贵人等等书里是没有宜什么忌什么的断语的
// 本着负责任的态度我就不写了，以后我再研究一下
// 对于所有的东方玄学术数软件，最难写的无非就是两个点，一个是各种乱七八糟流派，二是各种神煞
// 就好像八字六爻，你想写八字六爻排盘软件或者库，最难的不是排盘的逻辑而是几辈子都不一定用的到的神煞
// 呵呵
// 我最佩服的就是写各种七政四余的软件的人，能写出来的真是神人了卧槽
// 失传的早各种乱七八糟流派，什么化曜神煞卧槽是人写的吗？
// 之前下载过一个app，卧槽那设置界面跟飞机中控台一样，无敌了哥们

/* -------------------------------------------------------------------------- */

import '../../utils/fast_bitset.dart';
import 'god_activities.dart';
import '../gods.dart';
import '../activities.dart';
import 'officer_things.dart';
import 'thing_level_calc.dart';
import 'day8char_things.dart';

class YiJiResult {
  final List<String> goodThings;
  final List<String> badThings;
  final int thingLevel; // 0: 从宜不从忌, 1: 从宜亦从忌, 2: 从忌不从宜, 3: 诸事皆忌

  YiJiResult({
    required this.goodThings,
    required this.badThings,
    required this.thingLevel,
  });
}

/// 宜忌最终管线 (Yi Ji Calculator)
/// 负责将神煞、建除、八字日柱、时令特殊规则和等第判定揉合在一起，得出最终宜忌
class YiJiCalc {
  static YiJiResult calculate({
    required int monthBranch, // 节气月 0(子)~11(亥)
    required int dayGanZhiIndex, // 0~59
    required int lunarMonth,
    required int lunarDay,
    required int nextSolarTermIndex,
    required int dayOfficerIndex, // 0~11 (建~闭)
    required FastBitSet activeRealGods,
    required int activeVirtualGodsMask,
    required bool isPhaseOfMoon, // 朔望月
    bool isYeargodDuty = true, // 默认计算岁神
  }) {
    Set<String> good = {};
    Set<String> bad = {};

    void extractActivities(FastBitSet bitset, Set<String> target) {
      for (int i in bitset) {
        target.add(AlmanacActivity.values[i].label);
      }
    }

    // 1. 打底：建除十二神
    extractActivities(OfficerThings.good[dayOfficerIndex], good);
    extractActivities(OfficerThings.bad[dayOfficerIndex], bad);

    // 2. 叠加：日干支特殊宜忌
    var stemRule = Day8CharThings.stemRules[dayGanZhiIndex % 10];
    if (stemRule != null) {
      extractActivities(stemRule.$1, good);
      extractActivities(stemRule.$2, bad);
    }
    var branchRule = Day8CharThings.branchRules[dayGanZhiIndex % 12];
    if (branchRule != null) {
      extractActivities(branchRule.$1, good);
      extractActivities(branchRule.$2, bad);
    }

    // 3. 核心：神煞大混战
    for (int godIndex in activeRealGods) {
      var rule = GodActivities.table[godIndex];
      if (rule != null) {
        extractActivities(rule.$1, good);
        extractActivities(rule.$2, bad);
      }
    }

    // 4. 时令特殊后处理规则 (节气特判)
    // 4.1 雨水后立夏前 (nextSolarTermIndex 在 4~8 之间, 即惊蛰到立夏) 执日、危日、收日 (5, 7, 9) 宜 取鱼
    if (nextSolarTermIndex >= 4 &&
        nextSolarTermIndex <= 8 &&
        (dayOfficerIndex == 5 ||
            dayOfficerIndex == 7 ||
            dayOfficerIndex == 9)) {
      good.add('取鱼');
    }
    // 4.2 霜降后立春前 (nextSolarTermIndex 20~23 或 0~2, 即立冬到立春) 执日、危日、收日 宜 畋猎
    if ((nextSolarTermIndex >= 20 || nextSolarTermIndex <= 2) &&
        (dayOfficerIndex == 5 ||
            dayOfficerIndex == 7 ||
            dayOfficerIndex == 9)) {
      good.add('畋猎');
    }
    // 4.3 立冬后立春前 (nextSolarTermIndex 21~23 或 0~2, 即小雪到立春) 危日 午日(地支午=7) 申日(地支申=9) 宜 伐木
    // 注意: Python 源码写的是 `d in ['午', '申']` (d是两字日柱)。
    // 这个由于逻辑错误，'丙申' in ['午', '申'] 永远是 False，所以 Python 实际上从未在午日/申日加过伐木。
    // 为了和 Python 产出完全一致，这里故意保留原作者的 Bug，只在 危日 (dayOfficerIndex == 7) 时添加伐木。
    if ((nextSolarTermIndex >= 21 || nextSolarTermIndex <= 2) &&
        (dayOfficerIndex == 7)) {
      good.add('伐木');
    }
    // 4.4 每月一日 六日 十五 十九日 二十一日 二十三日 忌 整手足甲
    if (const [1, 6, 15, 19, 21, 23].contains(lunarDay)) {
      bad.add('整手足甲');
    }
    // 4.5 每月十二日 十五日 忌 整容剃头
    if (lunarDay == 12 || lunarDay == 15) {
      bad.addAll(['整容', '剃头']);
    }
    // 4.6 每月十五日 朔弦望月 忌 求医疗病
    if (lunarDay == 15 || isPhaseOfMoon) {
      bad.add('求医疗病');
    }

    // 5. 冲突大逃杀等级 (0~5)
    int maxLevel = ThingLevelCalc.calculate(
      monthBranch: monthBranch,
      activeRealGods: activeRealGods,
      activeVirtualGodsMask: activeVirtualGodsMask,
    );

    // 能否化险为夷？检查有无“德”神
    bool isDe =
        activeRealGods.has(AlmanacGod.sui_de.index) ||
        activeRealGods.has(AlmanacGod.sui_de_he.index) ||
        activeRealGods.has(AlmanacGod.yue_de.index) ||
        activeRealGods.has(AlmanacGod.yue_de_he.index) ||
        activeRealGods.has(AlmanacGod.tian_de.index) ||
        activeRealGods.has(AlmanacGod.tian_de_he.index);

    // 将等第 (maxLevel) 转化为终极解决策略 (thingLevel)
    // 0: 从宜不从忌 (吉足胜凶) -> 好事留下，互斥时坏事被删
    // 1: 从宜亦从忌 (吉凶相抵) -> 互斥的好事坏事同时取消
    // 2: 从忌不从宜 (凶胜于吉) -> 坏事留下，互斥时好事被删
    // 3: 诸事皆忌 (凶叠大凶) -> 好事变["诸事不吉"]
    int thingLevel;

    if (maxLevel == 5) {
      thingLevel = 3;
    } else if (maxLevel == 4) {
      thingLevel = isDe ? 2 : 3;
    } else if (maxLevel == 3) {
      thingLevel = isDe ? 1 : 2;
    } else if (maxLevel == 2) {
      thingLevel = isDe ? 0 : 2;
    } else if (maxLevel == 1) {
      thingLevel = isDe ? 0 : 1;
    } else if (maxLevel == 0) {
      thingLevel = 0;
    } else {
      // maxLevel == -1: 无规则命中，例外处理，直接从宜亦从忌
      // Python L609-610: else: thingLevel = 1
      // 注意：此处不经过 isDe 降级！
      thingLevel = 1;
    }

    // 6. 执行集合互斥消杀！
    Set<String> intersection = good.intersection(bad);

    if (thingLevel == 3) {
      good = {'诸事不宜'};
      bad = {'诸事不宜'};
    } else if (thingLevel == 2) {
      // 从忌不从宜：冲突的删去“宜”
      good.removeAll(intersection);
    } else if (thingLevel == 1) {
      // 从宜亦从忌：冲突的双方全部取消
      good.removeAll(intersection);
      bad.removeAll(intersection);
    } else if (thingLevel == 0) {
      // 从宜不从忌：冲突的删去“忌”
      bad.removeAll(intersection);
    }

    if (thingLevel != 3) {
      // 凡宜宣政事，布政事之日，只注宜宣政事。
      if (good.contains('宣政事') && good.contains('布政事')) {
        good.remove('布政事');
      }
      // 凡宜营建宫室、修宫室之日，只注宜营建宫室。
      if (good.contains('营建宫室') && good.contains('修宫室')) {
        good.remove('修宫室');
      }

      bool isDeSheEnSixiang = false;
      var maxpowerGods = [
        AlmanacGod.yue_de_he.index,
        AlmanacGod.tian_de_he.index,
        AlmanacGod.tian_she.index,
        AlmanacGod.tian_yuan.index,
        AlmanacGod.yue_en.index,
        AlmanacGod.si_xiang.index,
        AlmanacGod.shi_de.index,
      ];
      if (isYeargodDuty) maxpowerGods.add(AlmanacGod.sui_de_he.index);

      for (int g in maxpowerGods) {
        if (activeRealGods.has(g)) {
          isDeSheEnSixiang = true;
          break;
        }
      }

      if (isDeSheEnSixiang && thingLevel != 2) {
        bad.removeAll([
          '进人口',
          '安床',
          '经络',
          '酝酿',
          '开市',
          '立券交易',
          '纳财',
          '开仓库',
          '出货财',
        ]);

        // Restore "遇德犹忌" (bad things from the 6 De gods)
        var deGods = [
          AlmanacGod.sui_de,
          AlmanacGod.sui_de_he,
          AlmanacGod.yue_de,
          AlmanacGod.yue_de_he,
          AlmanacGod.tian_de,
          AlmanacGod.tian_de_he,
        ];
        if (isDe) {
          for (var dg in deGods) {
            if (activeRealGods.has(dg.index)) {
              var t = GodActivities.table[dg.index];
              if (t != null) {
                // Extract bad activities for this god and add them back
                for (int i = 0; i < AlmanacActivity.values.length; i++) {
                  if (t.$2.has(i)) {
                    bad.add(AlmanacActivity.values[i].label);
                  }
                }
              }
            }
          }
        }
      }

      // 天狗寅日忌祭祀，不注宜求福、祈嗣
      int dayEarthBranch = dayGanZhiIndex % 12;
      String dayStemStr = "甲乙丙丁戊己庚辛壬癸"[dayGanZhiIndex % 10];
      if (activeRealGods.has(AlmanacGod.tian_gou.index) ||
          dayEarthBranch == 2 /*寅*/ ) {
        bad.add('祭祀');
        good.removeAll(['祭祀', '求福', '祈嗣']);
      }

      // 凡卯日忌穿井，不注宜开渠。壬日忌开渠，不注宜穿井。
      if (dayEarthBranch == 3 /*卯*/ ) {
        bad.add('穿井');
        good.removeAll(['穿井', '开渠']);
      }
      if (dayStemStr == '壬') {
        bad.add('开渠');
        good.removeAll(['开渠', '穿井']);
      }

      // 凡巳日忌出行，不注宜出师、遣使。
      if (dayEarthBranch == 5 /*巳*/ ) {
        bad.add('出行');
        good.removeAll(['出行', '出师', '遣使']);
      }

      // 凡酉日忌宴会，亦不注宜庆赐、赏贺。
      if (dayEarthBranch == 9 /*酉*/ ) {
        bad.add('宴会');
        good.removeAll(['宴会', '庆赐', '赏贺']);
      }

      // 凡丁日忌剃头，亦不注宜整容。
      if (dayStemStr == '丁') {
        bad.add('剃头');
        good.removeAll(['剃头', '整容']);
      }

      // 凡吉足胜凶，从宜不从忌者，如遇德犹忌之事，则仍注忌。
      // L1161: Python logic self.todayLevel == 0 and thingLevel == 0 adds deIsBadThing
      // 我们之前的 isDeSheEnSixiang 逻辑已经部分处理了 "遇德犹忌"。但是这里我们针对 maxLevel == 0 加一个补丁
      if (maxLevel == 0 && thingLevel == 0 && isDe) {
        var deGods = [
          AlmanacGod.sui_de,
          AlmanacGod.sui_de_he,
          AlmanacGod.yue_de,
          AlmanacGod.yue_de_he,
          AlmanacGod.tian_de,
          AlmanacGod.tian_de_he,
        ];
        for (var dg in deGods) {
          if (activeRealGods.has(dg.index)) {
            var t = GodActivities.table[dg.index];
            if (t != null) {
              for (int i = 0; i < AlmanacActivity.values.length; i++) {
                if (t.$2.has(i)) bad.add(AlmanacActivity.values[i].label);
              }
            }
          }
        }
      }

      // --- 凡吉凶相抵 (maxLevel == 1) 的各种连带豁免 ---
      if (maxLevel == 1) {
        // L1164: 如遇德犹忌之事，则仍注忌。 (已经在 isDeSheEnSixiang / maxLevel==0 覆盖了部分，为了绝对安全再补充)
        if (isDe) {
          var deGods = [
            AlmanacGod.sui_de,
            AlmanacGod.sui_de_he,
            AlmanacGod.yue_de,
            AlmanacGod.yue_de_he,
            AlmanacGod.tian_de,
            AlmanacGod.tian_de_he,
          ];
          for (var dg in deGods) {
            if (activeRealGods.has(dg.index)) {
              var t = GodActivities.table[dg.index];
              if (t != null) {
                for (int i = 0; i < AlmanacActivity.values.length; i++) {
                  if (t.$2.has(i)) bad.add(AlmanacActivity.values[i].label);
                }
              }
            }
          }
        }

        // 不注忌祈福，亦不注忌求嗣。
        if (!bad.contains('祈福')) bad.remove('求嗣');

        // 不注忌结婚姻，亦不注忌冠带、纳采问名、嫁娶、进人口
        if (!bad.contains('结婚姻') && !isDe) {
          bad.removeAll(['冠带', '纳采问名', '嫁娶', '进人口']);
        }
        // 不注忌嫁娶，亦不注忌冠带、结婚姻、纳采问名、进人口、搬移、安床
        if (!bad.contains('嫁娶') && !isDe) {
          if (!activeRealGods.has(AlmanacGod.bu_jiang.index)) {
            bad.removeAll(['冠带', '纳采问名', '结婚姻', '进人口', '搬移', '安床']);
          }
        }

        // 不注忌搬移，亦不注忌安床。不注忌安床，亦不注忌搬移。
        if (!isDe) {
          if (!bad.contains('搬移')) bad.remove('安床');
          if (!bad.contains('安床')) bad.remove('搬移');

          // 不注忌解除，亦不注忌整容、剃头、整手足甲。
          if (!bad.contains('解除')) bad.removeAll(['整容', '剃头', '整手足甲']);

          // 不注忌修造动土、竖柱上梁，亦不注忌...
          if (!bad.contains('修造') || !bad.contains('竖柱上梁')) {
            bad.removeAll([
              '修宫室',
              '缮城郭',
              '整手足甲',
              '筑提', // Python 原文：'筑提'（非'筑堤防'），永远不会匹配
              '修仓库',
              '鼓铸',
              '苫盖',
              '修置产室',
              '开渠穿井', // Python 原文：连体词，永远不会匹配
              '安碓硙',
              '补垣塞穴', // Python 原文：连体词，永远不会匹配
              '修饰垣墙',
              '平治道涂',
              '破屋坏垣',
            ]);
          }
        }

        // Python L1199-1204: 开市/纳财/立券交易 cascading removal
        if (!bad.contains('开市')) bad.removeAll(['立券交易', '纳财', '开仓库', '出货财']);
        if (!bad.contains('纳财')) bad.removeAll(['立券交易', '开市']);
        if (!bad.contains('立券交易')) {
          bad.removeAll(['纳财', '开市', '开仓库', '出货财']);
        }
      }

      // 遇亥日、厌对、八专、四忌、四穷而仍注忌嫁娶者，只注所忌之事，其不忌者仍不注忌。【未妥善解决】
      if (dayEarthBranch == 11 /*亥*/ ) {
        bad.add('嫁娶');
      }

      // 凡吉凶相抵，不注忌牧养，亦不注忌纳畜。不注忌纳畜，亦不注忌牧养。
      if (maxLevel == 1) {
        if (!bad.contains('牧养')) bad.remove('纳畜');
        if (!bad.contains('纳畜')) bad.remove('牧养');
        // 凡吉凶相抵，有宜安葬不注忌启攒，有宜启攒不注忌安葬。
        if (good.contains('安葬')) bad.remove('启攒');
        if (good.contains('启攒')) bad.remove('安葬');
      }

      // 凡忌诏命公卿、招贤，不注宜施恩、封拜、举正直、袭爵受封。
      if (bad.contains('诏命公卿') || bad.contains('招贤')) {
        good.removeAll(['施恩', '举正直']);
      }
      // 凡忌施恩、封拜、举正直、袭爵受封，亦不注宜诏命公卿、招贤。
      if (bad.contains('施恩') || bad.contains('举正直')) {
        good.removeAll(['诏命公卿', '招贤']);
      }

      // 凡宜宣政事之日遇往亡则改宣为布。
      if (good.contains('宣政事') &&
          activeRealGods.has(AlmanacGod.wang_wang.index)) {
        good.remove('宣政事');
        good.add('布政事');
      }

      // 凡月厌忌行幸、上官，不注宜颁诏、施恩封拜、诏命公卿、招贤、举正直。遇宜宣政事之日，则改宣为布。
      if (activeRealGods.has(AlmanacGod.yue_yan.index)) {
        good.removeAll(['颁诏', '施恩', '招贤', '举正直', '宣政事']);
        good.add('布政事');

        // 凡土府、土符、地囊，只注忌补垣，亦不注宜塞穴。
        bad.add('补垣');
        if (activeRealGods.has(AlmanacGod.tu_fu.index) ||
            activeRealGods.has(AlmanacGod.di_nang.index)) {
          good.remove('塞穴');
        }
      }

      // 凡开日，不注宜破土、安葬、启攒，亦不注忌。遇忌则注。
      if (dayOfficerIndex == 10 /*开*/ ) {
        good.removeAll(['破土', '安葬', '启攒']);
      }

      // 凡四忌、四穷只忌安葬。如遇鸣吠、鸣吠对亦不注宜破土、启攒。
      if (activeRealGods.has(AlmanacGod.si_ji_taboo.index) ||
          activeRealGods.has(AlmanacGod.si_qiong.index)) {
        bad.add('安葬');
        good.removeAll(['破土', '启攒']);
      }

      if (activeRealGods.has(AlmanacGod.ming_fei.index) ||
          activeRealGods.has(AlmanacGod.ming_fei_dui.index)) {
        good.removeAll(['破土', '启攒']);
      }

      // L1249-1256: 岁薄、逐阵相关赦免（暂时简化）
      // Python 原文注释写了三句话的规则，包含岁薄/逐阵照月厌删等逻辑。
      // 但实际上 Python 源码中只实现了最后一句“XX日遇德合赦愿，诸事不忌”的逻辑。
      // 为了保持与 Python 产出完全一致，这里只翻译了真正生效的代码逻辑。
      List<String> amnestyDays = [
        '空',
        '甲戌',
        '空',
        '丙申',
        '空',
        '甲子',
        '戊申',
        '庚辰',
        '辛卯',
        '甲子',
        '空',
        '甲子',
      ];
      String dStr =
          "甲乙丙丁戊己庚辛壬癸"[dayGanZhiIndex % 10] +
          "子丑寅卯辰巳午未申酉戌亥"[dayGanZhiIndex % 12];
      int lmn = lunarMonth; // 1~12
      if (lmn >= 1 && lmn <= 12 && amnestyDays[lmn - 1] == dStr) {
        bad = {'诸事不忌'};
      }

      bool hasDeHe =
          activeRealGods.has(AlmanacGod.sui_de_he.index) ||
          activeRealGods.has(AlmanacGod.yue_de_he.index) ||
          activeRealGods.has(AlmanacGod.tian_de_he.index);
      bool hasSheYuan =
          activeRealGods.has(AlmanacGod.tian_she.index) ||
          activeRealGods.has(AlmanacGod.tian_yuan.index);
      if (hasDeHe && hasSheYuan) {
        bad = {'诸事不忌'};
      }
    }

    // === Python L1259-1266: 最终清理 ===
    // 书中未明注忌不注宜: 如果某事同时出现在宜和忌中，则从宜中删除
    Set<String> finalOverlap = good.intersection(bad);
    if (finalOverlap.length == 1 && finalOverlap.first.contains('诸事')) {
      // 如果唯一的重叠是 "诸事不宜" 或 "诸事不忌"，则不删
    } else {
      good.removeAll(finalOverlap);
    }

    // Python L1269-1272: 空列表兜底
    if (bad.isEmpty) bad.add('诸事不忌');
    if (good.isEmpty) good.add('诸事不宜');

    return YiJiResult(
      goodThings: good.toList()..sort(),
      badThings: bad.toList()..sort(),
      thingLevel: thingLevel,
    );
  }
}


// 上面说的还没喷完，那个七政四余app竟然有个功能是拿现在的盘还原古代某个时候的星象
// 卧槽这是真牛逼哈哈哈，不是他怎么可能能算准呢？？
// 还有那七政四余经过我的考证是不会算上升点的哈哈哈哈
// 那西方占星和印度占星里面星体位置跟七政四余是不一样的。。
// 前面那俩看我日月金水木都是在2宫，七政四余给我传奇大漂移飘到3宫去了
// 太搞笑了哥们
// 那西洋占星也挺搞笑的，表面上看没啥问题，其实因为岁差的影响跟分宫制的影响不同流派应该差别还是很大的
// 你怎么能同时拿地球的节气和离地球十万八千里的星体同时当锚点呢？这不符合常理
// 西洋占星的规定春分的时候是白羊座0度，说明是跟八字一样与节气挂钩，但是星体的位置跟节气又无关
// 八字的年月都是节气决定的，但是日时又是机械的数数字，也挺难绷的
// 紫微斗数看似是跟月亮位置有关，但是闰月问题也是个死穴
// 这么来看，很多玄学已经没有现实锚点了，但我还是感觉有现实锚点的玄学数术更可靠一点
// 看来印度占星 紫微斗数 八字看起来可信度更高，起码有个现实锚点不是？
// 不过八字在我眼里稍微逊色一点，因为我不知道天干是怎么来的，还有年月和日时有明显的拼接痕迹
// 很显然，八字和占星属于“节气派”，印度占星和紫微斗数属于“天体位置”派
// 七政四余嘛。。我很难评价
// 哈哈