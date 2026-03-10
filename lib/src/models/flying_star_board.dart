import 'package:chinese_lunar_almanac/src/calculators/sanyuan_jiuyun_calc.dart';
import 'package:chinese_lunar_almanac/src/models/sanyuan_jiuyun.dart';
import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

class FlyingStarBoard {
  List<FlyingStar> stars;

  FlyingStarBoard(this.stars);

}

enum Boundary{
  solar,
  lunar,
}

class NineStarBoard{
  DayFlyingStarMethod method;
  bool useHistoricalSolarTerms;
  bool isSpiltRatHour;
  bool exactJieQiTime;
  Boundary boundary;
  NineStarBoard({
    this.method = DayFlyingStarMethod.consecutive,
    this.boundary = Boundary.solar,
    this.useHistoricalSolarTerms = false,
    this.isSpiltRatHour = false,
    this.exactJieQiTime = false,
  });
  static List<FlyingStar> createNineStarBoard(int index, bool direction){
    final d = direction ? 1 : -1;
    final stars = List<FlyingStar?>.filled(9, null);
    int s = index;
    for(int i = 0; i < 9; i++){
      stars[SanYuanJiuYunCalc.flyingStarPath[i]] = FlyingStar.values[s];
      s = (s + d + 9) % 9;
    }
    return stars.cast<FlyingStar>();
  }

int _getSolarYear(AstroDateTime time) {
    AstroDateTime fixedAstroTime = time;
    if (!isSpiltRatHour && time.hour >= 23) {
      fixedAstroTime = time.add(const Duration(hours: 1));
    }
    double lc;
    // 如果是精确模式，用绝对时间；否则对齐到修正后那一天的午夜
    double t = exactJieQiTime ? time.toJ2000() : (fixedAstroTime.toJ2000() + 0.5).floorToDouble();

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
    if (!isSpiltRatHour && time.hour >= 23) {
      fixedAstroTime = time.add(const Duration(hours: 1));
    }

    if (useHistoricalSolarTerms) {
      // ---------------- 【历史分支】 ----------------
      final double fixedTime = (fixedAstroTime.toJ2000() + 0.5).floorToDouble(); 
      final tb = SSQ().calcY(fixedTime);
      List<double> jqtb = List.generate(25, (index) => (tb.zq[index] + 0.5).floorToDouble());
      
      for (int i = 0; i < 24; i++) {
        if (jqtb[i] <= fixedTime && jqtb[i+1] > fixedTime) {
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
        double r = isSpiltRatHour ? 0 : 1/24;
        // 这里的 fixedAstroTime 已经是最准的了
        final double fixedJDTime = (fixedAstroTime.toJ2000() + 0.5).floorToDouble() + 0.5 - r - 1e-10;
        final JieQiResult jq = getPrevJieFromJd(fixedJDTime)!;
        termIndex = jq.index;
      }
    }

    // 子=0, 丑=1, 寅=2
    return (termIndex ~/ 2 + 1) % 12;
  }

  int _getLunarYear(AstroDateTime time){
    return LunarDate.fromSolar(time, splitRatHour: isSpiltRatHour).lunarYear;
  }

  FlyingStarBoard getYearBoard(AstroDateTime time){
    if(boundary == Boundary.solar){
      return FlyingStarBoard(createNineStarBoard(SanYuanJiuYunCalc.getYearStar(_getSolarYear(time)).index, true));
    }else{
      return FlyingStarBoard(createNineStarBoard(SanYuanJiuYunCalc.getYearStar(_getLunarYear(time)).index, true));
    }
  }
  FlyingStarBoard getMonthBoard(AstroDateTime time){
    final year = boundary == Boundary.solar ? _getSolarYear(time) : _getLunarYear(time);
    final yearIdx = ((year - 1984) % 12 + 12) % 12;
    final branchIdx = boundary == Boundary.solar ? _getSolarMonthIdx(time) : (LunarDate.fromSolar(time, splitRatHour: isSpiltRatHour).month+1)%12;
    final starIdx = SanYuanJiuYunCalc.getMonthStar(DiZhi.values[yearIdx], DiZhi.values[branchIdx]).index;
    return FlyingStarBoard(createNineStarBoard(starIdx, true));
  }
  FlyingStarBoard getDayBoard(AstroDateTime time){
    final idx = SanYuanJiuYunCalc.getDayStar(
      time, 
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      isSpiltRatHour: isSpiltRatHour,
      exactJieQiTime: exactJieQiTime,
    ).index;
    return FlyingStarBoard(createNineStarBoard(idx, SanYuanJiuYunCalc.getDunYinYang(
      time,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    )));
  }
  FlyingStarBoard getHourBoard(AstroDateTime time){
    final idx = SanYuanJiuYunCalc.getHourStar(
      time,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      isSpiltRatHour: isSpiltRatHour,
      exactJieQiTime: exactJieQiTime
    ).index;
    return FlyingStarBoard(createNineStarBoard(idx, SanYuanJiuYunCalc.getDunYinYang(
      time,
      method: method,
      useHistoricalSolarTerms: useHistoricalSolarTerms,
      exactJieQiTime: exactJieQiTime,
    )));
  }
  FlyingStarBoard getEarthPlate(AstroDateTime time){
    int year = _getSolarYear(time);
    int firstIdx = SanYuanJiuYunCalc.getJiuYun(year).index;
    return FlyingStarBoard(createNineStarBoard(firstIdx, true));
  }
  FlyingStarBoard getMountainPlate(FlyingStarBoard earthPlate, Mountain mountain){
    final FlyingStar centerStar = earthPlate.stars[SanYuanJiuYunCalc.numToIndexList[mountain.luoShuNum - 1]];
    bool direction = true;
    if(centerStar.index == 4){
      direction = mountain.isYang;
    }else{
      direction = Mountain.getFlyDirectionByStarNumber(centerStar.index+1, mountain.dragon);
    }
    return FlyingStarBoard(createNineStarBoard(centerStar.index, direction));
  }

  // 懒得写了，让ai模仿上面生成一下
  /// 获取向盘 (向星盘 / 水盘)
  /// [earthPlate] 已经排好的地盘
  /// [facingMountain] 建筑的朝向 (例如子山午向，传入的就是午向 Mountain.wu)
  FlyingStarBoard getWaterPlate(FlyingStarBoard earthPlate, Mountain facingMountain) {
    // 1. 极速寻址：通过朝向的洛书数字(1-9)，用纯数组直接定位到地盘的真实索引(0-8)
    final int palaceIndex = SanYuanJiuYunCalc.numToIndexList[facingMountain.luoShuNum - 1];
    
    // 2. 揪出地盘对应宫位里的那颗星，准备入中宫
    final FlyingStar centerStar = earthPlate.stars[palaceIndex];
    
    bool direction = true;
    
    // 3. 核心顺逆判定
    if (centerStar.index == 4) { // index 4 代表 5黄星
      // 5黄星没有老家，直接借用【朝向】本身的阴阳
      direction = facingMountain.isYang;
    } else {
      // 常规星，送回老家查【朝向】所属元龙的阴阳
      direction = Mountain.getFlyDirectionByStarNumber(centerStar.index + 1, facingMountain.dragon);
    }
    
    // 4. 调用底层排盘生成向盘
    return FlyingStarBoard(createNineStarBoard(centerStar.index, direction));
  }
}

