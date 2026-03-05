import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 吉神方位 (God Directions)
///
/// 择吉术中根据日天干推算的五个主要吉神方向：
/// 1. 喜神 (Joy God): 主喜庆、姻缘。
/// 2. 福神 (Fortune God): 主平安、好运。
/// 3. Cai Shen (Wealth God): 主财运、生意。
/// 4. Yang Gui (Positive Noble): 白天（日出后）的贵人位。
/// 5. Yin Gui (Negative Noble): 黑夜（日落后）的贵人位。
class GodDirection {
  /// 获取喜神方位
  static String getXiShen(TianGan dayGan) {
    const directions = [
      '东北',
      '西北',
      '西南',
      '正南',
      '东南',
      '东北',
      '西北',
      '西南',
      '正南',
      '东南',
    ];
    return directions[dayGan.index];
  }

  /// 获取福神方位
  static String getFuShen(TianGan dayGan) {
    const directions = [
      '东南',
      '东南',
      '正东',
      '正东',
      '正北',
      '正南',
      '西南',
      '西南',
      '西北',
      '正西',
    ];
    return directions[dayGan.index];
  }

  /// 获取财神方位
  static String getCaiShen(TianGan dayGan) {
    // 甲乙东北, 丙丁正南, 戊正北, 己正南, 庚辛正东, 壬正南, 癸正北
    const directions = [
      '东北',
      '东北',
      '正南',
      '正南',
      '正北',
      '正南',
      '正东',
      '正东',
      '正南',
      '正北',
    ];
    return directions[dayGan.index];
  }

  /// 获取阳贵人方位 (Day Noble)
  static String getYangGui(TianGan dayGan) {
    // 甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸兔蛇藏，六辛逢马虎，此是贵人方
    const directions = [
      '西南',
      '西南',
      '正西',
      '西北',
      '东北',
      '正北',
      '东北',
      '正东',
      '正东',
      '东南',
    ];
    return directions[dayGan.index];
  }

  /// 获取阴贵人方位 (Night Noble)
  static String getYinGui(TianGan dayGan) {
    const directions = [
      '东北',
      '东北',
      '西北',
      '正西',
      '西南',
      '正南',
      '西南',
      '东南',
      '东南',
      '正东',
    ];
    return directions[dayGan.index];
  }

  /// 获取所有方位的综合描述
  static Map<String, String> getAll(TianGan dayGan) {
    return {
      '喜神': getXiShen(dayGan),
      '福神': getFuShen(dayGan),
      '财神': getCaiShen(dayGan),
      '阳贵': getYangGui(dayGan),
      '阴贵': getYinGui(dayGan),
    };
  }
}
