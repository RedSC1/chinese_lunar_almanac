import 'package:chinese_lunar_almanac/src/models/compass_direction.dart';
import 'package:chinese_lunar_almanac/src/models/sanyuan_jiuyun.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

class SanYuanJiuYunCalc {
  /// 计算三元九运中的元
  ///
  /// 以1864年为上元起点（一白贪狼星，一运开始）
  ///
  /// [year]: 公历年份
  static SanYuan getSanYuan(int year) {
    int enableOffset = ((year - 1864) % 180 + 180) % 180;
    int index = enableOffset ~/ 60;
    return SanYuan.values[index];
  }

  static FlyingStar getJiuYun(int year) {
    int enableOffset = ((year - 1864) % 180 + 180) % 180;
    int index = enableOffset ~/ 20;
    return FlyingStar.values[index];
  }

  /*
 * ========================================================
 * 九宫飞星底图 (洛书元旦盘)
 * ========================================================
 * 排盘原则：上南下北，左东右西
 * 数据结构：建议采用 1D List (长度为9)，索引对应如下：
 *
 *     [0]东南          [1]正南          [2]西南
 *     ┌────────────┬────────────┬────────────┐
 *     │            │            │            │
 *     │   巽 4     │   离 9      │   坤 2     │
 *     │            │            │            │
 *     ├────────────┼────────────┼────────────┤
 *     │            │            │            │
 * [3] │   震 3     │   中 5      │   兑 7     │ [5]
 * 正东 │            │            │            │ 正西
 *     ├────────────┼────────────┼────────────┤
 *     │            │            │            │
 *     │   艮 8     │   坎 1      │   乾 6     │
 *     │            │            │            │
 *     └────────────┴────────────┴────────────┘
 *     [6]东北          [7]正北          [8]西北
 *
 * --------------------------------------------------------
 * 【量天尺（顺飞）绝对路径 - Index步法】
 * 中(4) -> 乾(8) -> 兑(5) -> 艮(6) -> 离(1) -> 坎(7) -> 坤(2) -> 震(3) -> 巽(0)
 * --------------------------------------------------------
 */
  /// 定义洛书九宫格的物理索引（0-8）对应的后天八卦与原生飞星数字
  static const List<({CompassDirection direction, int baseStarNumber})> luoshuGrid = [
    (direction: CompassDirection.southeast, baseStarNumber: 4), // 0: 东南
    (direction: CompassDirection.south,     baseStarNumber: 9), // 1: 正南
    (direction: CompassDirection.southwest, baseStarNumber: 2), // 2: 西南
    (direction: CompassDirection.east,      baseStarNumber: 3), // 3: 正东
    (direction: CompassDirection.center,    baseStarNumber: 5), // 4: 中宫
    (direction: CompassDirection.west,      baseStarNumber: 7), // 5: 正西
    (direction: CompassDirection.northeast, baseStarNumber: 8), // 6: 东北
    (direction: CompassDirection.north,     baseStarNumber: 1), // 7: 正北
    (direction: CompassDirection.northwest, baseStarNumber: 6), // 8: 西北
  ];
  static const List<int> numToIndexList = [
    7, // 对应数字 1 (正北)
    2, // 对应数字 2 (西南)
    3, // 对应数字 3 (正东)
    0, // 对应数字 4 (东南)
    4, // 对应数字 5 (中宫)
    8, // 对应数字 6 (西北)
    5, // 对应数字 7 (正西)
    6, // 对应数字 8 (东北)
    1  // 对应数字 9 (正南)
  ];
  
  static const List<int> flyingStarPath = [4, 8, 5, 6, 1, 7, 2, 3, 0];

  ///计算年运飞星中宫
  ///
  ///2027年中宫为九紫右弼星
  static FlyingStar getYearStar(int year) {
    int mIdx = ((year - 2027) % 9 + 9) % 9;
    return FlyingStar.values[8 - mIdx];
  }

  ///古人口诀：“子午卯酉八白起，辰戌丑未五黄求，寅申巳亥居何处，逆寻二黑是根由。”
  //哎我操这么点代码好多坑啊
  static FlyingStar getMonthStar(DiZhi yearBranch, DiZhi monthBranch) {
    int startStar = 7 - 3 * (yearBranch.index % 3);
    int monthIdx = (monthBranch.index - 2 + 12) % 12;
    int idx = (startStar - monthIdx + 18) % 9;
    return FlyingStar.values[idx];
  }



  
/// 获取日家/时家飞星
///
/// 整合了天文历算精度、干支周期连贯性、以及多种流派的交节切换逻辑。
///
/// [method] - 甲子周期的处理逻辑：
/// * [DayFlyingStarMethod.consecutive]: 强制保证60天周期的完整。即使已过节气，
///   只要当前甲子周期未完，则继续沿用旧遁局，直到遇到节气后的首个甲子日才切换。
/// * [DayFlyingStarMethod.discontinuous]: 节气当天即视为遁局切换点，
///   甲子周期会被拦腰截断，重新计算最近的甲子锚点。
///
/// [useHistoricalSolarTerms] - 节气计算模式：
/// * [false] (现代定气): 基于现代天文算法，精度达分秒级。
/// * [true] (古代平气): 对齐老黄历。注意：古历模式由于底层数据特性（SSQ tb.zq），
///   仅具备天级精度，开启后 [exactJieQiTime] 将失效。
///
/// [isSpiltRatHour] - 子时换日策略：
/// * [false] (标准模式): 23:00 强制执行换日，日柱切换为明日。
/// * [true] (早晚子时): 23:00 - 00:00 视为“夜子时”，日柱依然保持为今日。
///
/// [exactJieQiTime] - 交节瞬间的逻辑切换（仅对现代定气有效）：
/// * [false] (0点对齐): 保证全天12个时辰的遁局统一。只要夏至落于今日，今日0点起即统一切换。
/// * [true] (分秒): 严格按交节时刻切换，交接当天节气交界点会从阳遁顺飞直接跳跃到阴遁逆飞的绝对坐标）。
  static FlyingStar getDayStar(AstroDateTime time, {
    DayFlyingStarMethod method = DayFlyingStarMethod.consecutive,
    bool useHistoricalSolarTerms = false,
    bool isSpiltRatHour = false,
    bool exactJieQiTime = false,
  }) {
    var fixedTime = time;
    if(!isSpiltRatHour && time.hour >= 23){
      fixedTime = fixedTime.add(const Duration(hours: 1));
    }
    final bool isConsecutive = (method == DayFlyingStarMethod.consecutive);
    final idx = useHistoricalSolarTerms ? _historicalMode(fixedTime, isConsecutive) : _preciseDayMode(fixedTime, isConsecutive, exactJieQiTime);
    return FlyingStar.values[idx];
  }


/// 获取日家/时家飞星
///
/// 整合了天文历算精度、干支周期连贯性、以及多种流派的交节切换逻辑。
///
/// [method] - 甲子周期的处理逻辑：
/// * [DayFlyingStarMethod.consecutive]: 强制保证60天周期的完整。即使已过节气，
///   只要当前甲子周期未完，则继续沿用旧遁局，直到遇到节气后的首个甲子日才切换。
/// * [DayFlyingStarMethod.discontinuous]: 节气当天即视为遁局切换点，
///   甲子周期会被拦腰截断，重新计算最近的甲子锚点。
///
/// [useHistoricalSolarTerms] - 节气计算模式：
/// * [false] (现代定气): 基于现代天文算法，精度达分秒级。
/// * [true] (古代平气): 对齐老黄历。注意：古历模式由于底层数据特性（SSQ tb.zq），
///   仅具备天级精度，开启后 [exactJieQiTime] 将失效。
///
/// [isSpiltRatHour] - 子时换日策略：
/// * [false] (标准模式): 23:00 强制执行换日，日柱切换为明日。
/// * [true] (早晚子时): 23:00 - 00:00 视为“夜子时”，日柱依然保持为今日。
///
/// [exactJieQiTime] - 交节瞬间的逻辑切换（仅对现代定气有效）：
/// * [false] (0点对齐): 保证全天12个时辰的遁局统一。只要夏至落于今日，今日0点起即统一切换。
/// * [true] (分秒): 严格按交节时刻切换，交接当天节气交界点会从阳遁顺飞直接跳跃到阴遁逆飞的绝对坐标）。
  static FlyingStar getHourStar(AstroDateTime time, {
    DayFlyingStarMethod method = DayFlyingStarMethod.consecutive,
    bool useHistoricalSolarTerms = false,
    bool isSpiltRatHour = false,
    bool exactJieQiTime = false,
  }){
    var fixedTime = time;
    if(!isSpiltRatHour && time.hour >= 23){
      fixedTime = fixedTime.add(const Duration(hours: 1));
    }
    final int idx = _getHourStarIdx(fixedTime,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    );
    return FlyingStar.values[idx];
  }

  static int _getHourStarIdx(AstroDateTime time,{
      DayFlyingStarMethod method = DayFlyingStarMethod.consecutive,
      bool useHistoricalSolarTerms = false,
      bool exactJieQiTime = false,
  }){
    //2000年1月7日 甲子日 j2000JD=7
    final int fixedDay = (time.toJ2000() + 0.5).floor();
    final int branchIdx = ((fixedDay - 7) % 12 + 12) % 12;
    final int startIdx = (branchIdx % 3) * 3;
    int fixedIdx = startIdx;
    final int direction = getDunYinYang(
      time, 
      method: method, 
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    )? 1 : -1;
    if(direction == -1){
      fixedIdx = 8 - startIdx;
    }
    final int hourIdx = ((time.hour + 1) ~/ 2) % 12;
    return ((fixedIdx + hourIdx * direction) % 9 + 9) % 9;
  }

  static bool getDunYinYang(AstroDateTime time, {
    DayFlyingStarMethod method = DayFlyingStarMethod.consecutive,
    bool useHistoricalSolarTerms = false,
    bool exactJieQiTime = false,
  }){
    bool enableOffset = (method == DayFlyingStarMethod.consecutive);
    bool direction = (!useHistoricalSolarTerms) ? _preciseDay(time, enableOffset, exactJieQiTime).$2 : _historicalDay(time, enableOffset).$2;
    return direction;
  } 


  ///获取距离最近的甲子日的偏移量
  ///
  ///2000年1月7日 甲子日 j2000JD=7
  static int  _getNearestJiaZi(double j2000JD, {bool enableOffset = true}){
    int fixedDay = (j2000JD + 0.5).floor();
    if(!enableOffset){
      return fixedDay;
    }
    int idx =((fixedDay - 7) % 60 + 60) % 60;
    int offset = idx > 29 ? 60 - idx : -idx;
    return fixedDay+offset;
  }

  static int _getStarIdx(double targetDay, int jzDay, bool direction){
    final int td = (targetDay+0.5).floor();
    final int idx = ((td - jzDay) % 9 + 9) % 9;
    return direction ? idx : 8 - idx;
  }

  static int _preciseDayMode(AstroDateTime time, bool enableOffset, bool exactJieQiTime){
    int jzDay;
    bool direction = true;
    (jzDay, direction) = _preciseDay(time, enableOffset, exactJieQiTime);
    return _getStarIdx(time.toJ2000(), jzDay, direction);
  }

  static (int jzDay, bool direction) _preciseDay(AstroDateTime time, bool enableOffset, bool exactJieQiTime){
    int jzDay;
    bool direction = true;
    //本年冬至
    double dz = getSpecificJieQi(time.year, 18);
    double xz = getSpecificJieQi(time.year, 6);
    double prevDz = getSpecificJieQi(time.year-1, 18);
    double fixedTime = time.toJ2000();
    if(!exactJieQiTime){
      dz = (dz + 0.5).floorToDouble();
      xz = (xz + 0.5).floorToDouble();
      prevDz = (prevDz + 0.5).floorToDouble();
      fixedTime = (time.toJ2000() + 0.5).floorToDouble();
    }
    if(dz <= fixedTime){
      jzDay = _getNearestJiaZi(dz, enableOffset: enableOffset);
    }else if(xz <= fixedTime){
      jzDay = _getNearestJiaZi(xz, enableOffset: enableOffset);
      direction = false;
    }else{
      jzDay = _getNearestJiaZi(prevDz, enableOffset: enableOffset);
    }
    return (jzDay, direction);
  }


  static int _historicalMode(AstroDateTime time, bool enableOffset){
    int jzDay;
    bool direction = true;
    (jzDay, direction) = _historicalDay(time, enableOffset);
    return _getStarIdx(time.toJ2000(), jzDay, direction);
  }

  static (int jzDay, bool direction) _historicalDay(AstroDateTime time, bool enableOffset){
    final ssq = SSQ();
    final SSQResult tb = ssq.calcY(time.toJ2000());
    final double dz = (tb.zq[24] + 0.5).floorToDouble();
    final double xz = (tb.zq[12] + 0.5).floorToDouble();
    final double prevDz = (tb.zq[0] + 0.5).floorToDouble();
    final double fixedTime = (time.toJ2000() + 0.5).floorToDouble();
    int jzDay;
    bool direction = true;
    if(dz <= fixedTime){
      jzDay = _getNearestJiaZi(dz, enableOffset: enableOffset);
    }else if(xz <= fixedTime){
      jzDay = _getNearestJiaZi(xz, enableOffset: enableOffset);
      direction = false;
    }else{
      jzDay = _getNearestJiaZi(prevDz, enableOffset: enableOffset);
    }
    return (jzDay, direction);
  }
}



enum DayFlyingStarMethod{
  consecutive,
  discontinuous,
}

enum YuanLong {
  earth,  // 地元龙
  heaven, // 天元龙
  human,  // 人元龙
}


// 懒得写了，让ai生成一下。。。。


/// 二十四山
enum Mountain {
  // ---------------- 坎宫 (1白星) ----------------
  ren('壬', 1, YuanLong.earth, true),   // 阳
  zi('子', 1, YuanLong.heaven, false),  // 阴
  gui('癸', 1, YuanLong.human, false),  // 阴

  // ---------------- 坤宫 (2黑星) ----------------
  wei('未', 2, YuanLong.earth, false),  // 阴
  kun('坤', 2, YuanLong.heaven, true),  // 阳
  shen('申', 2, YuanLong.human, true),  // 阳

  // ---------------- 震宫 (3碧星) ----------------
  jia('甲', 3, YuanLong.earth, true),   // 阳
  mao('卯', 3, YuanLong.heaven, false), // 阴
  yi('乙', 3, YuanLong.human, false),   // 阴

  // ---------------- 巽宫 (4绿星) ----------------
  chen('辰', 4, YuanLong.earth, false), // 阴
  xun('巽', 4, YuanLong.heaven, true),  // 阳
  si('巳', 4, YuanLong.human, true),    // 阳

  // ---------------- 乾宫 (6白星) ----------------
  xu('戌', 6, YuanLong.earth, false),   // 阴
  qian('乾', 6, YuanLong.heaven, true), // 阳
  hai('亥', 6, YuanLong.human, true),   // 阳

  // ---------------- 兑宫 (7赤星) ----------------
  geng('庚', 7, YuanLong.earth, true),  // 阳
  you('酉', 7, YuanLong.heaven, false), // 阴
  xin('辛', 7, YuanLong.human, false),  // 阴

  // ---------------- 艮宫 (8白星) ----------------
  chou('丑', 8, YuanLong.earth, false), // 阴
  gen('艮', 8, YuanLong.heaven, true),  // 阳
  yin('寅', 8, YuanLong.human, true),   // 阳

  // ---------------- 离宫 (9紫星) ----------------
  bing('丙', 9, YuanLong.earth, true),  // 阳
  wu('午', 9, YuanLong.heaven, false),  // 阴
  ding('丁', 9, YuanLong.human, false); // 阴

  final String chineseName;
  final int luoShuNum;      // 对应的老家宫位数字 (1-9，跳过5)
  final YuanLong dragon;    // 所属元龙
  final bool isYang;        // true为阳(顺飞)，false为阴(逆飞)

  const Mountain(this.chineseName, this.luoShuNum, this.dragon, this.isYang);

  /// 通过星数 index 和元龙，直接计算出该星应该顺飞还是逆飞
  /// 返回 true 为顺飞(阳)，false 为逆飞(阴)
  static bool getFlyDirectionByStarNumber(int starNumber, YuanLong targetDragon) {
    //五黄星没有老家，必须在外面单独用坐山/朝向的阴阳判断
    if (starNumber == 5) {
      throw Exception('5黄星没有老家，不能调用此方法查替身，请直接使用建筑原坐山/朝向的阴阳');
    }

    // 判断老家宫位是奇数还是偶数
    // 奇数宫 (1坎, 3震, 7兑, 9离)
    // 偶数宫 (2坤, 4巽, 6乾, 8艮)
    bool isOddPalace = starNumber % 2 != 0;
    if (targetDragon == YuanLong.earth) {
      // 地元龙法则：奇数宫为顺(true)，偶数宫为逆(false)
      return isOddPalace;
    } else {
      // 天元龙、人元龙法则：奇数宫为逆(false)，偶数宫为顺(true)
      return !isOddPalace;
    }
  }
}


//写晕了哥们，真写晕了。。卧槽谁发明的这玩意。。。