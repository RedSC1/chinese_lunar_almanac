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

import 'package:chinese_lunar_almanac/src/utils/fast_bitset.dart';

import '../data/yi_ji/yi_ji_data.dart';

class YiJiResult {
  final FastBitSet goodThings;
  final FastBitSet badThings;
  final int thingLevel; // 0: 从宜不从忌, 1: 从宜亦从忌, 2: 从忌不从宜, 3: 诸事皆忌

  YiJiResult({
    required this.goodThings,
    required this.badThings,
    required this.thingLevel,
  });

  List<String> toGoodStringList({FastBitSet? mask}) {
    FastBitSet res = goodThings;
    if (mask != null) {
      res = res & mask;
    }
    if (res.isEmpty) return ['诸事不宜'];
    final indices = res.toList();
    indices.sort(
      (a, b) => AlmanacActivity.sortPriority[a].compareTo(
        AlmanacActivity.sortPriority[b],
      ),
    );
    return indices.map((i) => AlmanacActivity.values[i].label).toList();
  }

  List<String> toBadStringList({FastBitSet? mask}) {
    FastBitSet res = badThings;
    if (mask != null) {
      res = res & mask;
    }
    if (res.isEmpty) return ['诸事不忌'];
    final indices = res.toList();
    indices.sort(
      (a, b) => AlmanacActivity.sortPriority[a].compareTo(
        AlmanacActivity.sortPriority[b],
      ),
    );
    return indices.map((i) => AlmanacActivity.values[i].label).toList();
  }
}

/// 宜忌最终管线 (Yi Ji Calculator)
/// 负责将神煞、建除、八字日柱、时令特殊规则和等第判定揉合在一起，得出最终宜忌
// 沟槽的ai把我的bitset退化成Set<String>了卧槽，我还得手动改
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
    FastBitSet good = FastBitSet(AlmanacActivity.values.length);
    FastBitSet bad = FastBitSet(AlmanacActivity.values.length);

    void extractActivities(FastBitSet bitset, FastBitSet tb) {
      tb.merge(bitset);
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
      good.add(AlmanacActivity.qu_yu.index);
      // good.add('取鱼');
    }
    // 4.2 霜降后立春前 (nextSolarTermIndex 20~23 或 0~2, 即立冬到立春) 执日、危日、收日 宜 畋猎
    if ((nextSolarTermIndex >= 20 || nextSolarTermIndex <= 2) &&
        (dayOfficerIndex == 5 ||
            dayOfficerIndex == 7 ||
            dayOfficerIndex == 9)) {
      good.add(AlmanacActivity.tian_lie.index);
      // good.add('畋猎');
    }
    // 4.3 立冬后立春前 (nextSolarTermIndex 21~23 或 0~2, 即小雪到立春) 危日 午日(地支午=7) 申日(地支申=9) 宜 伐木
    // 注意: Python 源码写的是 `d in ['午', '申']` (d是两字日柱)。
    // 这个由于逻辑错误，'丙申' in ['午', '申'] 永远是 False，所以 Python 实际上从未在午日/申日加过伐木。
    // 为了和 Python 产出完全一致，这里故意保留原作者的 Bug，只在 危日 (dayOfficerIndex == 7) 时添加伐木。
    if ((nextSolarTermIndex >= 21 || nextSolarTermIndex <= 2) &&
        (dayOfficerIndex == 7)) {
      good.add(AlmanacActivity.fa_mu.index);
      //good.add('伐木');
    }
    // 4.4 每月一日 六日 十五 十九日 二十一日 二十三日 忌 整手足甲
    if (const [1, 6, 15, 19, 21, 23].contains(lunarDay)) {
      bad.add(AlmanacActivity.zheng_shou_zu_jia.index);
      //bad.add('整手足甲');
    }
    // 4.5 每月十二日 十五日 忌 整容剃头
    if (lunarDay == 12 || lunarDay == 15) {
      bad.addAll([
        AlmanacActivity.zheng_rong.index,
        AlmanacActivity.ti_tou.index,
      ]);
      //bad.addAll(['整容', '剃头']);
    }
    // 4.6 每月十五日 朔弦望月 忌 求医疗病
    if (lunarDay == 15 || isPhaseOfMoon) {
      bad.add(AlmanacActivity.qiu_yi_liao_bing.index);
      //bad.add('求医疗病');
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
    FastBitSet intersection = good & bad;
    //Set<String> intersection = good.intersection(bad);

    if (thingLevel == 3) {
      good = FastBitSet.fromIndices(AlmanacActivity.values.length, [
        AlmanacActivity.zhu_shi_bu_yi.index,
      ]);
      //good = {'诸事不宜'};
      bad = FastBitSet.fromIndices(AlmanacActivity.values.length, [
        AlmanacActivity.zhu_shi_bu_yi.index,
      ]);
      //bad = {'诸事不宜'};
    } else if (thingLevel == 2) {
      // 从忌不从宜：冲突的删去“宜”
      good.oppress(intersection);
      // good.removeAll(intersection);
    } else if (thingLevel == 1) {
      // 从宜亦从忌：冲突的双方全部取消
      good.oppress(intersection);
      bad.oppress(intersection);
      // good.removeAll(intersection);
      // bad.removeAll(intersection);
    } else if (thingLevel == 0) {
      // 从宜不从忌：冲突的删去“忌”
      bad.oppress(intersection);
      //bad.removeAll(intersection);
    }

    if (thingLevel != 3) {
      // 凡宜宣政事，布政事之日，只注宜宣政事。
      if (good.contains(AlmanacActivity.xuan_zheng_shi.index) &&
          good.contains(AlmanacActivity.bu_zheng_shi.index)) {
        good.remove(AlmanacActivity.bu_zheng_shi.index);
      }
      // if (good.contains('宣政事') && good.contains('布政事')) {
      //   good.remove('布政事');
      // }

      // 凡宜营建宫室、修宫室之日，只注宜营建宫室。
      if (good.contains(AlmanacActivity.ying_jian_gong_shi.index) &&
          good.contains(AlmanacActivity.xiu_gong_shi.index)) {
        good.remove(AlmanacActivity.xiu_gong_shi.index);
      }
      // if (good.contains('营建宫室') && good.contains('修宫室')) {
      //   good.remove('修宫室');
      // }

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
          AlmanacActivity.jin_ren_kou.index,
          AlmanacActivity.an_chuang.index,
          AlmanacActivity.jing_luo.index,
          AlmanacActivity.yun_niang.index,
          AlmanacActivity.kai_shi.index,
          AlmanacActivity.li_quan_jiao_yi.index,
          AlmanacActivity.na_cai.index,
          AlmanacActivity.kai_cang_ku.index,
          AlmanacActivity.chu_huo_cai.index,
        ]);
        // bad.removeAll([
        //   '进人口',
        //   '安床',
        //   '经络',
        //   '酝酿',
        //   '开市',
        //   '立券交易',
        //   '纳财',
        //   '开仓库',
        //   '出货财',
        // ]);

        // Restore "遇德犹忌" (bad things from the 6 De gods)
        // var deGods = [
        //   AlmanacGod.sui_de,
        //   AlmanacGod.sui_de_he,
        //   AlmanacGod.yue_de,
        //   AlmanacGod.yue_de_he,
        //   AlmanacGod.tian_de,
        //   AlmanacGod.tian_de_he,
        // ];
        FastBitSet deGodsMask =
            FastBitSet.fromIndices(AlmanacGod.values.length, [
              AlmanacGod.sui_de.index,
              AlmanacGod.sui_de_he.index,
              AlmanacGod.yue_de.index,
              AlmanacGod.yue_de_he.index,
              AlmanacGod.tian_de.index,
              AlmanacGod.tian_de_he.index,
            ]);
        if (isDe) {
          for (int dg in deGodsMask) {
            if (activeRealGods.has(dg)) {
              var t = GodActivities.table[dg];
              if (t != null) {
                // Extract bad activities for this god and add them back
                bad.merge(t.$2);
                // for (int i = 0; i < AlmanacActivity.values.length; i++) {
                //   if (t.$2.has(i)) {
                //     bad.add(AlmanacActivity.values[i].label);
                //   }
                // }
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
        bad.add(AlmanacActivity.ji_si.index);
        // bad.add('祭祀');
        good.removeAll([
          AlmanacActivity.ji_si.index,
          AlmanacActivity.qiu_fu.index,
          AlmanacActivity.qi_si.index,
        ]);
        // good.removeAll(['祭祀', '求福', '祈嗣']);
      }

      // 凡卯日忌穿井，不注宜开渠。壬日忌开渠，不注宜穿井。
      if (dayEarthBranch == 3 /*卯*/ ) {
        bad.add(AlmanacActivity.chuan_jing.index);
        good.add(AlmanacActivity.kai_qu.index);
        // bad.add('穿井');
        // good.removeAll(['穿井', '开渠']);
      }
      if (dayStemStr == '壬') {
        bad.add(AlmanacActivity.kai_qu.index);
        good.removeAll([
          AlmanacActivity.kai_qu.index,
          AlmanacActivity.chuan_jing.index,
        ]);
        // bad.add('开渠');
        // good.removeAll(['开渠', '穿井']);
      }

      // 凡巳日忌出行，不注宜出师、遣使。
      if (dayEarthBranch == 5 /*巳*/ ) {
        bad.add(AlmanacActivity.chu_xing.index);
        good.removeAll([
          AlmanacActivity.chu_xing.index,
          AlmanacActivity.chu_shi.index,
          AlmanacActivity.qian_shi.index,
        ]);
        // bad.add('出行');
        // good.removeAll(['出行', '出师', '遣使']);
      }

      // 凡酉日忌宴会，亦不注宜庆赐、赏贺。
      if (dayEarthBranch == 9 /*酉*/ ) {
        bad.add(AlmanacActivity.yan_hui.index);
        good.removeAll([
          AlmanacActivity.yan_hui.index,
          AlmanacActivity.qing_ci.index,
          AlmanacActivity.shang_he.index,
        ]);
        // bad.add('宴会');
        // good.removeAll(['宴会', '庆赐', '赏贺']);
      }

      // 凡丁日忌剃头，亦不注宜整容。
      if (dayStemStr == '丁') {
        bad.add(AlmanacActivity.ti_tou.index);
        good.removeAll([
          AlmanacActivity.ti_tou.index,
          AlmanacActivity.zheng_rong.index,
        ]);
        // bad.add('剃头');
        // good.removeAll(['剃头', '整容']);
      }

      // 凡吉足胜凶，从宜不从忌者，如遇德犹忌之事，则仍注忌。
      // L1161: Python logic self.todayLevel == 0 and thingLevel == 0 adds deIsBadThing
      // 我们之前的 isDeSheEnSixiang 逻辑已经部分处理了 "遇德犹忌"。但是这里我们针对 maxLevel == 0 加一个补丁
      if (maxLevel == 0 && thingLevel == 0 && isDe) {
        // (AlmanacGod enum reuse logic)
        for (int dg in [
          AlmanacGod.sui_de.index,
          AlmanacGod.sui_de_he.index,
          AlmanacGod.yue_de.index,
          AlmanacGod.yue_de_he.index,
          AlmanacGod.tian_de.index,
          AlmanacGod.tian_de_he.index,
        ]) {
          if (activeRealGods.has(dg)) {
            var t = GodActivities.table[dg];
            if (t != null) {
              bad.merge(t.$2);
              // for (int i = 0; i < AlmanacActivity.values.length; i++) {
              //   if (t.$2.has(i)) bad.add(AlmanacActivity.values[i].label);
              // }
            }
          }
        }
      }

      // --- 凡吉凶相抵 (maxLevel == 1) 的各种连带豁免 ---
      if (maxLevel == 1) {
        // L1164: 如遇德犹忌之事，则仍注忌。 (已经在 isDeSheEnSixiang / maxLevel==0 覆盖了部分，为了绝对安全再补充)
        if (isDe) {
          for (int dg in [
            AlmanacGod.sui_de.index,
            AlmanacGod.sui_de_he.index,
            AlmanacGod.yue_de.index,
            AlmanacGod.yue_de_he.index,
            AlmanacGod.tian_de.index,
            AlmanacGod.tian_de_he.index,
          ]) {
            if (activeRealGods.has(dg)) {
              var t = GodActivities.table[dg];
              if (t != null) {
                bad.merge(t.$2);
                // for (int i = 0; i < AlmanacActivity.values.length; i++) {
                //   if (t.$2.has(i)) bad.add(AlmanacActivity.values[i].label);
                // }
              }
            }
          }
        }

        // 不注忌祈福，亦不注忌求嗣。
        if (!bad.has(AlmanacActivity.qi_fu.index)) {
          bad.remove(AlmanacActivity.qiu_si.index);
        }
        // if (!bad.contains('祈福')) bad.remove('求嗣');

        // 不注忌结婚姻，亦不注忌冠带、纳采问名、嫁娶、进人口
        if (!bad.has(AlmanacActivity.jie_hun_yin.index) && !isDe) {
          bad.removeAll([
            AlmanacActivity.guan_dai.index,
            AlmanacActivity.na_cai_wen_ming.index,
            AlmanacActivity.jia_qu.index,
            AlmanacActivity.jin_ren_kou.index,
          ]);
          // bad.removeAll(['冠带', '纳采问名', '嫁娶', '进人口']);
        }
        // === 严密判断：今天的【忌嫁娶】是否100%仅由5个特异孤煞导致 ===
        // 古书原文："遇亥日、厌对、八专、四忌、四穷而仍注忌嫁娶者，
        //          只注所忌之事，其不忌者仍不注忌。"
        bool hasSpecialGods =
            (dayEarthBranch == 11) ||
            activeRealGods.has(AlmanacGod.yan_dui.index) ||
            activeRealGods.has(AlmanacGod.ba_zhuan.index) ||
            activeRealGods.has(AlmanacGod.si_ji_taboo.index) ||
            activeRealGods.has(AlmanacGod.si_qiong.index);

        // 严格溯源：如果今天忌嫁娶且有特异孤煞在场，
        // 需排查是否有其他普通神煞也贡献了【忌嫁娶】
        bool isSolelyBlamedOnSpecialGods = false;
        if (hasSpecialGods && bad.has(AlmanacActivity.jia_qu.index)) {
          isSolelyBlamedOnSpecialGods = true; // 先假设是孤煞独自所为
          for (final godIndex in activeRealGods) {
            // 跳过这4个孤煞自身（亥日不是神煞，不在此循环中）
            if (godIndex == AlmanacGod.yan_dui.index ||
                godIndex == AlmanacGod.ba_zhuan.index ||
                godIndex == AlmanacGod.si_ji_taboo.index ||
                godIndex == AlmanacGod.si_qiong.index) {
              continue;
            }
            // 查这个普通神煞的忌项表里有没有【嫁娶】
            final rule = GodActivities.table[godIndex];
            if (rule != null && rule.$2.has(AlmanacActivity.jia_qu.index)) {
              isSolelyBlamedOnSpecialGods = false; // 有内鬼！
              break;
            }
          }
        }

        // 不注忌嫁娶，或经严格排查确认忌嫁娶100%由孤煞导致 → 豁免周边小弟
        // 古人原话："只注所忌之事，其不忌者仍不注忌"
        if ((!bad.has(AlmanacActivity.jia_qu.index) ||
                isSolelyBlamedOnSpecialGods) &&
            !isDe) {
          if (!activeRealGods.has(AlmanacGod.bu_jiang.index)) {
            bad.removeAll([
              AlmanacActivity.guan_dai.index,
              AlmanacActivity.na_cai_wen_ming.index,
              AlmanacActivity.jie_hun_yin.index,
              AlmanacActivity.jin_ren_kou.index,
              AlmanacActivity.ban_yi.index,
              AlmanacActivity.an_chuang.index,
            ]);
            // bad.removeAll(['冠带', '纳采问名', '结婚姻', '进人口', '搬移', '安床']);
          }
        }
      }

      // 遇亥日而仍注忌嫁娶者，只注所忌之事，其不忌者仍不注忌。【已妥善解决，这里仅补充忌嫁娶的主犯】
      if (dayEarthBranch == 11 /*亥*/ ) {
        bad.add(AlmanacActivity.jia_qu.index);
        // bad.add('嫁娶');
      }

      // 凡吉凶相抵，不注忌搬移，亦不注忌安床。不注忌安床，亦不注忌搬移。
      if (maxLevel == 1 && !isDe) {
        if (!bad.has(AlmanacActivity.ban_yi.index)) {
          bad.remove(AlmanacActivity.an_chuang.index);
        }
        if (!bad.has(AlmanacActivity.an_chuang.index)) {
          bad.remove(AlmanacActivity.ban_yi.index);
        }
        // if (!bad.contains('搬移')) bad.remove('安床');
        // if (!bad.contains('安床')) bad.remove('搬移');

        // 不注忌解除，亦不注忌整容、剃头、整手足甲。
        if (!bad.has(AlmanacActivity.jie_chu.index)) {
          bad.removeAll([
            AlmanacActivity.zheng_rong.index,
            AlmanacActivity.ti_tou.index,
            AlmanacActivity.zheng_shou_zu_jia.index,
          ]);
          // bad.removeAll(['整容', '剃头', '整手足甲']);
        }

        // 不注忌修造动土、竖柱上梁，亦不注忌...
        if (!bad.has(AlmanacActivity.xiu_zao.index) ||
            !bad.has(AlmanacActivity.shu_zhu_shang_liang.index)) {
          bad.removeAll([
            AlmanacActivity.xiu_gong_shi.index,
            AlmanacActivity.shan_cheng_guo.index,
            AlmanacActivity.zheng_shou_zu_jia.index,
            AlmanacActivity.zhu_di_fang.index, // 原作写的'筑提'是笔误，正确为'筑堤防'
            AlmanacActivity.xiu_cang_ku.index,
            AlmanacActivity.gu_zhu.index,
            AlmanacActivity.shan_gai.index,
            AlmanacActivity.xiu_zhi_chan_shi.index,
            AlmanacActivity.kai_qu_chuan_jing.index, // 连体版
            AlmanacActivity.kai_qu.index, // 拆分版：开渠
            AlmanacActivity.chuan_jing.index, // 拆分版：穿井
            AlmanacActivity.an_dui_wei.index,
            AlmanacActivity.bu_yuan_sai_xue.index, // 连体版
            AlmanacActivity.bu_yuan.index, // 拆分版：补垣
            AlmanacActivity.sai_xue.index, // 拆分版：塞穴
            AlmanacActivity.xiu_shi_yuan_qiang.index,
            AlmanacActivity.ping_zhi_dao_tu.index,
            AlmanacActivity.po_wu_huai_yuan.index,
          ]);
          /*
            bad.removeAll([
              '修宫室',
              '缮城郭',
              '整手足甲',
              '筑提',
              '修仓库',
              '鼓铸',
              '苫盖',
              '修置产室',
              '开渠穿井',
              '安碓硙',
              '补垣塞穴',
              '修饰垣墙',
              '平治道涂',
              '破屋坏垣',
            ]);
            */
        }
      }

      // Python L1199-1204: 开市/纳财/立券交易 cascading removal
      if (maxLevel == 1) {
        if (!bad.has(AlmanacActivity.kai_shi.index)) {
          bad.removeAll([
            AlmanacActivity.li_quan_jiao_yi.index,
            AlmanacActivity.na_cai.index,
            AlmanacActivity.kai_cang_ku.index,
            AlmanacActivity.chu_huo_cai.index,
          ]);
          // bad.removeAll(['立券交易', '纳财', '开仓库', '出货财']);
        }
        if (!bad.has(AlmanacActivity.na_cai.index)) {
          bad.removeAll([
            AlmanacActivity.li_quan_jiao_yi.index,
            AlmanacActivity.kai_shi.index,
          ]);
          // bad.removeAll(['立券交易', '开市']);
        }
        if (!bad.has(AlmanacActivity.li_quan_jiao_yi.index)) {
          bad.removeAll([
            AlmanacActivity.na_cai.index,
            AlmanacActivity.kai_shi.index,
            AlmanacActivity.kai_cang_ku.index,
            AlmanacActivity.chu_huo_cai.index,
          ]);
          // bad.removeAll(['纳财', '开市', '开仓库', '出货财']);
        }
      }

      // 凡吉凶相抵，不注忌牧养，亦不注忌纳畜。不注忌纳畜，亦不注忌牧养。
      if (maxLevel == 1) {
        if (!bad.has(AlmanacActivity.mu_yang.index)) {
          bad.remove(AlmanacActivity.na_chu.index);
        }
        if (!bad.has(AlmanacActivity.na_chu.index)) {
          bad.remove(AlmanacActivity.mu_yang.index);
        }
        // if (!bad.contains('牧养')) bad.remove('纳畜');
        // if (!bad.contains('纳畜')) bad.remove('牧养');

        // 凡吉凶相抵，有宜安葬不注忌启攒，有宜启攒不注忌安葬。
        if (good.has(AlmanacActivity.an_zang.index)) {
          bad.remove(AlmanacActivity.qi_cuan.index);
        }
        if (good.has(AlmanacActivity.qi_cuan.index)) {
          bad.remove(AlmanacActivity.an_zang.index);
        }
        // if (good.contains('安葬')) bad.remove('启攒');
        // if (good.contains('启攒')) bad.remove('安葬');
      }

      // 凡忌诏命公卿、招贤，不注宜施恩、封拜、举正直、袭爵受封。
      if (bad.has(AlmanacActivity.zhao_ming_gong_qing.index) ||
          bad.has(AlmanacActivity.zhao_xian.index)) {
        good.removeAll([
          AlmanacActivity.shi_en.index,
          AlmanacActivity.ju_zheng_zhi.index,
        ]);
        // good.removeAll(['施恩', '举正直']);
      }
      // 凡忌施恩、封拜、举正直、袭爵受封，亦不注宜诏命公卿、招贤。
      if (bad.has(AlmanacActivity.shi_en.index) ||
          bad.has(AlmanacActivity.ju_zheng_zhi.index)) {
        good.removeAll([
          AlmanacActivity.zhao_ming_gong_qing.index,
          AlmanacActivity.zhao_xian.index,
        ]);
        // good.removeAll(['诏命公卿', '招贤']);
      }

      // 凡宜宣政事之日遇往亡则改宣为布。
      if (good.has(AlmanacActivity.xuan_zheng_shi.index) &&
          activeRealGods.has(AlmanacGod.wang_wang.index)) {
        good.remove(AlmanacActivity.xuan_zheng_shi.index);
        good.add(AlmanacActivity.bu_zheng_shi.index);
        // good.remove('宣政事');
        // good.add('布政事');
      }

      // 凡月厌忌行幸、上官，不注宜颁诏、施恩封拜、诏命公卿、招贤、举正直。遇宜宣政事之日，则改宣为布。
      if (activeRealGods.has(AlmanacGod.yue_yan.index)) {
        good.removeAll([
          AlmanacActivity.ban_zhao.index,
          AlmanacActivity.shi_en.index,
          AlmanacActivity.zhao_xian.index,
          AlmanacActivity.ju_zheng_zhi.index,
          AlmanacActivity.xuan_zheng_shi.index,
        ]);
        good.add(AlmanacActivity.bu_zheng_shi.index);
        // good.removeAll(['颁诏', '施恩', '招贤', '举正直', '宣政事']);
        // good.add('布政事');

        // 凡土府、土符、地囊，只注忌补垣，亦不注宜塞穴。
        bad.add(AlmanacActivity.bu_yuan.index);
        // bad.add('补垣');
        if (activeRealGods.has(AlmanacGod.tu_fu.index) ||
            activeRealGods.has(AlmanacGod.di_nang.index)) {
          good.remove(AlmanacActivity.sai_xue.index);
          // good.remove('塞穴');
        }
      }

      // 凡开日，不注宜破土、安葬、启攒，亦不注忌。遇忌则注。
      if (dayOfficerIndex == 10 /*开*/ ) {
        good.removeAll([
          AlmanacActivity.po_tu.index,
          AlmanacActivity.an_zang.index,
          AlmanacActivity.qi_cuan.index,
        ]);
        // good.removeAll(['破土', '安葬', '启攒']);
      }

      // 凡四忌、四穷只忌安葬。如遇鸣吠、鸣吠对亦不注宜破土、启攒。
      if (activeRealGods.has(AlmanacGod.si_ji_taboo.index) ||
          activeRealGods.has(AlmanacGod.si_qiong.index)) {
        bad.add(AlmanacActivity.an_zang.index);
        good.removeAll([
          AlmanacActivity.po_tu.index,
          AlmanacActivity.qi_cuan.index,
        ]);
        // bad.add('安葬');
        // good.removeAll(['破土', '启攒']);
      }

      if (activeRealGods.has(AlmanacGod.ming_fei.index) ||
          activeRealGods.has(AlmanacGod.ming_fei_dui.index)) {
        good.removeAll([
          AlmanacActivity.po_tu.index,
          AlmanacActivity.qi_cuan.index,
        ]);
        // good.removeAll(['破土', '启攒']);
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
        bad = FastBitSet.fromIndices(AlmanacActivity.values.length, [
          AlmanacActivity.zhu_shi_bu_ji.index,
        ]);
        // bad = {'诸事不忌'};
      }

      bool hasDeHe =
          activeRealGods.has(AlmanacGod.sui_de_he.index) ||
          activeRealGods.has(AlmanacGod.yue_de_he.index) ||
          activeRealGods.has(AlmanacGod.tian_de_he.index);
      bool hasSheYuan =
          activeRealGods.has(AlmanacGod.tian_she.index) ||
          activeRealGods.has(AlmanacGod.tian_yuan.index);
      if (hasDeHe && hasSheYuan) {
        bad = FastBitSet.fromIndices(AlmanacActivity.values.length, [
          AlmanacActivity.zhu_shi_bu_ji.index,
        ]);
        // bad = {'诸事不忌'};
      }
    }

    // === Python L1259-1266: 最终清理 ===
    // 书中未明注忌不注宜: 如果某事同时出现在宜和忌中，则从宜中删除
    FastBitSet finalOverlap = good & bad;
    // Set<String> finalOverlap = good.intersection(bad);
    if (finalOverlap.length == 1 &&
        (finalOverlap.has(AlmanacActivity.zhu_shi_bu_yi.index) ||
            finalOverlap.has(AlmanacActivity.zhu_shi_bu_ji.index))) {
      // 如果唯一的重叠是 "诸事不宜" 或 "诸事不忌"，则不删
    } else {
      good.oppress(finalOverlap);
      // good.removeAll(finalOverlap);
    }

    // Python L1269-1272: 空列表兜底
    if (bad.isEmpty) {
      bad.add(AlmanacActivity.zhu_shi_bu_ji.index);
    }
    if (good.isEmpty) {
      good.add(AlmanacActivity.zhu_shi_bu_yi.index);
    }

    return YiJiResult(goodThings: good, badThings: bad, thingLevel: thingLevel);
  }
}
