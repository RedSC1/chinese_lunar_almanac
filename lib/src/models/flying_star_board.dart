import '../calculators/sanyuan_jiuyun_calc.dart';
import 'sanyuan_jiuyun.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

class FlyingStarBoard {
  List<FlyingStar> stars;

  FlyingStarBoard(this.stars);
}

enum Boundary { solar, lunar }

class NineStarBoard {
  DayFlyingStarMethod method;
  bool useHistoricalSolarTerms;
  bool isSplitRatHour;
  bool exactJieQiTime;
  Boundary boundary;
  NineStarBoard({
    this.method = DayFlyingStarMethod.consecutive,
    this.boundary = Boundary.solar,
    this.useHistoricalSolarTerms = false,
    this.isSplitRatHour = false,
    this.exactJieQiTime = false,
  });
  static List<FlyingStar> createNineStarBoard(int index, bool direction) {
    final d = direction ? 1 : -1;
    final stars = List<FlyingStar?>.filled(9, null);
    int s = index;
    for (int i = 0; i < 9; i++) {
      stars[SanYuanJiuYunCalc.flyingStarPath[i]] = FlyingStar.values[s];
      s = (s + d + 9) % 9;
    }
    return stars.cast<FlyingStar>();
  }

  int _getSolarYear(AstroDateTime time) {
    AstroDateTime fixedAstroTime = time;
    if (!isSplitRatHour && time.hour >= 23) {
      fixedAstroTime = time.add(const Duration(hours: 1));
    }
    double lc;
    // 如果是精确模式，用绝对时间；否则对齐到修正后那一天的午夜
    double t = exactJieQiTime
        ? time.toJ2000()
        : (fixedAstroTime.toJ2000() + 0.5).floorToDouble();

    if (!useHistoricalSolarTerms) {
      // 现代模式：找这一年的立春
      lc = getSpecificJieQi(fixedAstroTime.year - 1, 21);
    } else {
      // 历史模式
      final tb = SSQ().calcY(t);
      lc = tb.zq[3];
    }

    if (!exactJieQiTime || useHistoricalSolarTerms) {
      lc = (lc + 0.5).floorToDouble();
    }

    // 完美闭环：判断是否过立春，返回修正后的年份
    return t >= lc ? fixedAstroTime.year : fixedAstroTime.year - 1;
  }

  int _getSolarMonthIdx(AstroDateTime time) {
    int termIndex = 0;

    // 全局统一的时间修正（提到最前面）
    AstroDateTime fixedAstroTime = time;
    if (!isSplitRatHour && time.hour >= 23) {
      fixedAstroTime = time.add(const Duration(hours: 1));
    }

    if (useHistoricalSolarTerms) {
      // ---------------- 【历史分支】 ----------------
      final double fixedTime = (fixedAstroTime.toJ2000() + 0.5).floorToDouble();
      final tb = SSQ().calcY(fixedTime);
      List<double> jqtb = List.generate(
        25,
        (index) => (tb.zq[index] + 0.5).floorToDouble(),
      );

      for (int i = 0; i < 24; i++) {
        if (jqtb[i] <= fixedTime && jqtb[i + 1] > fixedTime) {
          termIndex = (i - 1 + 24) % 24;
          break;
        }
      }

      if (termIndex % 2 != 0) {
        termIndex = (termIndex - 1 + 24) % 24;
      }
    } else {
      // ---------------- 【现代分支】 ----------------
      if (exactJieQiTime) {
        final JieQiResult jq = getPrevJie(time)!; // 精确模式依然用真实物理时间
        termIndex = jq.index;
      } else {
        double r = isSplitRatHour ? 0 : 1 / 24;
        // 这里的 fixedAstroTime 已经是最准的了
        final double fixedJDTime =
            (fixedAstroTime.toJ2000() + 0.5).floorToDouble() + 0.5 - r - 1e-10;
        final JieQiResult jq = getPrevJieFromJd(fixedJDTime)!;
        termIndex = jq.index;
      }
    }

    // 子=0, 丑=1, 寅=2
    return (termIndex ~/ 2 + 1) % 12;
  }

  int _getLunarYear(AstroDateTime time) {
    return LunarDate.fromSolar(time, splitRatHour: isSplitRatHour).lunarYear;
  }

  FlyingStarBoard getYearBoard(AstroDateTime time) {
    if (boundary == Boundary.solar) {
      return FlyingStarBoard(
        createNineStarBoard(
          SanYuanJiuYunCalc.getYearStar(_getSolarYear(time)).index,
          true,
        ),
      );
    } else {
      return FlyingStarBoard(
        createNineStarBoard(
          SanYuanJiuYunCalc.getYearStar(_getLunarYear(time)).index,
          true,
        ),
      );
    }
  }

  FlyingStarBoard getMonthBoard(AstroDateTime time) {
    final year = boundary == Boundary.solar
        ? _getSolarYear(time)
        : _getLunarYear(time);
    final yearIdx = ((year - 1984) % 12 + 12) % 12;
    final branchIdx = boundary == Boundary.solar
        ? _getSolarMonthIdx(time)
        : (LunarDate.fromSolar(time, splitRatHour: isSplitRatHour).month + 1) %
              12;
    final starIdx = SanYuanJiuYunCalc.getMonthStar(
      DiZhi.values[yearIdx],
      DiZhi.values[branchIdx],
    ).index;
    return FlyingStarBoard(createNineStarBoard(starIdx, true));
  }

  FlyingStarBoard getDayBoard(TimePack timePack) {
    final idx = SanYuanJiuYunCalc.getDayStar(
      timePack,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    ).index;
    return FlyingStarBoard(
      createNineStarBoard(
        idx,
        SanYuanJiuYunCalc.getDunYinYang(
          timePack,
          method: method,
          useHistoricalSolarTerms: useHistoricalSolarTerms,
          exactJieQiTime: exactJieQiTime,
        ),
      ),
    );
  }

  FlyingStarBoard getHourBoard(TimePack timePack) {
    final idx = SanYuanJiuYunCalc.getHourStar(
      timePack,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    ).index;
    return FlyingStarBoard(
      createNineStarBoard(
        idx,
        SanYuanJiuYunCalc.getDunYinYang(
          timePack,
          method: method,
          useHistoricalSolarTerms: useHistoricalSolarTerms,
          exactJieQiTime: exactJieQiTime,
        ),
      ),
    );
  }

  FlyingStarBoard getEarthPlate(AstroDateTime time) {
    int year = boundary == Boundary.solar
        ? _getSolarYear(time)
        : _getLunarYear(time);
    int firstIdx = SanYuanJiuYunCalc.getJiuYun(year).index;
    return FlyingStarBoard(createNineStarBoard(firstIdx, true));
  }

  FlyingStarBoard getMountainPlate(
    FlyingStarBoard earthPlate,
    Mountain mountain,
  ) {
    final FlyingStar centerStar = earthPlate
        .stars[SanYuanJiuYunCalc.numToIndexList[mountain.luoShuNum - 1]];
    bool direction = true;
    if (centerStar.index == 4) {
      direction = mountain.isYang;
    } else {
      direction = Mountain.getFlyDirectionByStarNumber(
        centerStar.index + 1,
        mountain.dragon,
      );
    }
    return FlyingStarBoard(createNineStarBoard(centerStar.index, direction));
  }

  // 懒得写了，让ai模仿上面生成一下
  /// 获取向盘 (向星盘 / 水盘)
  /// [earthPlate] 已经排好的地盘
  /// [facingMountain] 建筑的朝向 (例如子山午向，传入的就是午向 Mountain.wu)
  FlyingStarBoard getWaterPlate(
    FlyingStarBoard earthPlate,
    Mountain facingMountain,
  ) {
    // 1. 极速寻址：通过朝向的洛书数字(1-9)，用纯数组直接定位到地盘的真实索引(0-8)
    final int palaceIndex =
        SanYuanJiuYunCalc.numToIndexList[facingMountain.luoShuNum - 1];

    // 2. 揪出地盘对应宫位里的那颗星，准备入中宫
    final FlyingStar centerStar = earthPlate.stars[palaceIndex];

    bool direction = true;

    // 3. 核心顺逆判定
    if (centerStar.index == 4) {
      // index 4 代表 5黄星
      // 5黄星没有老家，直接借用【朝向】本身的阴阳
      direction = facingMountain.isYang;
    } else {
      // 常规星，送回老家查【朝向】所属元龙的阴阳
      direction = Mountain.getFlyDirectionByStarNumber(
        centerStar.index + 1,
        facingMountain.dragon,
      );
    }

    // 4. 调用底层排盘生成向盘
    return FlyingStarBoard(createNineStarBoard(centerStar.index, direction));
  }
}

/// 排龙诀引擎 (PaiLong Engine)
/// 注意：该模块逻辑极其硬编码，纯为兼容部分流派的“十字绞杀阵”而写。
class PaiLongEngine {
  // 核心毒性数组：三步一崩之法
  static const List<String> _stars = [
    '破军',
    '右弼',
    '廉贞',
    '破军',
    '武曲',
    '贪狼',
    '破军',
    '左辅',
    '文曲',
    '破军',
    '巨门',
    '禄存',
  ];

  // 12地支宫位环形数组（顺时针）
  static const List<String> _palaces = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ];

  /// 排龙诀专属：24山降维映射12宫 (私有字典表)
  /// 注意映射规则：子癸同宫，丑艮同宫，寅甲同宫...
  static String _getPalace(Mountain mountain) {
    switch (mountain) {
      case Mountain.zi:
      case Mountain.gui:
        return '子';
      case Mountain.chou:
      case Mountain.gen:
        return '丑';
      case Mountain.yin:
      case Mountain.jia:
        return '寅';
      case Mountain.mao:
      case Mountain.yi:
        return '卯';
      case Mountain.chen:
      case Mountain.xun:
        return '辰';
      case Mountain.si:
      case Mountain.bing:
        return '巳';
      case Mountain.wu:
      case Mountain.ding:
        return '午';
      case Mountain.wei:
      case Mountain.kun:
        return '未';
      case Mountain.shen:
      case Mountain.geng:
        return '申';
      case Mountain.you:
      case Mountain.xin:
        return '酉';
      case Mountain.xu:
      case Mountain.qian:
        return '戌';
      case Mountain.hai:
      case Mountain.ren:
        return '亥';
    }
  }

  /// 排龙诀专属阴阳判定：与玄空飞星的 isYang 完全无关！
  /// 阴（12地支）：顺排 (+1)
  /// 阳（8干4维）：逆排 (-1)
  static int _getStep(Mountain mountain) {
    const List<Mountain> branches = [
      Mountain.zi,
      Mountain.chou,
      Mountain.yin,
      Mountain.mao,
      Mountain.chen,
      Mountain.si,
      Mountain.wu,
      Mountain.wei,
      Mountain.shen,
      Mountain.you,
      Mountain.xu,
      Mountain.hai,
    ];
    // 地支为阴顺排(+1)，干维为阳逆排(-1)
    return branches.contains(mountain) ? 1 : -1;
  }

  /// ### 📥 参数说明 (Parameter Specifications)
  /// | 参数名 | 类型 | 说明 |
  /// | :--- | :--- | :--- |
  /// | `laiLong` | [Mountain] | 实际测得的水口/动气方。**直接传原始测量值**，底层已自动封装对宫寻址逻辑，请勿在前端重复计算。 |
  /// | `facing` | [Mountain] | 受穴/建筑之向首。用于在环形序列中定位最终星曜。 |
  ///
  /// -------------------------------------------------------------------------
  ///
  /// ### 📤 返回值 (Return Value)
  /// * [String] : 返回命中的十二星名。（含 33.3% 概率触发的『破军』🤡）
  ///
  /// ════════════════════════════════════════════════════════════════════════════
  ///
  /// ⚖️ 【术数逻辑清源疏 · 卷一 · 排龙真伪考】
  ///
  /// 呜呼哀哉！臣等复核此排龙真诀，竟见其以『破军』为步进。
  /// 每隔二星，必现破军。十二山中，破军竟居其四！
  ///
  /// 夫天地万物之运行，莫不循『正态分布』之理；
  /// 然观此法之排布，乖舛悖乱，全无半分正态之象，实乃概率之贼，数理之灾。
  /// 似此等『三步一岗、五步一哨』之分布，显系术数界之 Hardcode。
  /// 编撰者想必是深得『取模运算』之精髓，却忘了天文历法之本原。
  ///
  /// 虽为兼容市场写就此函数，然心实耻之。后世观者，慎调用此『三步一崩』之法。
  static String calculateFacingStar(Mountain laiLong, Mountain facing) {
    // 1. 找水口（来龙）对应的宫位，并获取其在12地支数组里的索引
    String laiLongPalace = _getPalace(laiLong);
    int laiLongIndex = _palaces.indexOf(laiLongPalace);

    // 2. 找对宫起破军 (环形数组直接 +6 即可拿到 180 度对宫)
    int startIndex = (laiLongIndex + 6) % 12;

    // 3. 找大门（向首）对应的宫位及索引
    String facingPalace = _getPalace(facing);
    int targetIndex = _palaces.indexOf(facingPalace);

    // 4. 判断顺逆步长
    int step = _getStep(laiLong);

    // 5. 核心：计算偏移量（考虑环形和顺逆方向）
    // 数学逻辑：((目标点 - 起始点) * 步长) 算出正向绝对距离
    int distance = (targetIndex - startIndex) * step;

    // 处理负数，转为纯正数的索引余数
    int finalIndex = distance % 12;
    if (finalIndex < 0) finalIndex += 12;

    // 直接输出对应星曜，命中破军概不负责
    return _stars[finalIndex];
  }
}
