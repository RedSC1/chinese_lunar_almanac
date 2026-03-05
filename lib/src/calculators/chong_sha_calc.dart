import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../utils/almanac_ext.dart';

/// 冲煞 (Chong Sha / Conflict and Directional Clash)
///
/// 冲（正冲）：地支相冲（子午冲、丑未冲等）。冲代表动荡、冲突、不可用。
/// 煞（煞方）：基于地支三合局算出的劫煞、灾煞、岁煞的方向。代表该方向不吉。
class ChongSha {
  // ==========================================
  // 【一】冲 (Chong / 正冲)
  // ==========================================

  /// 获取与指定地支相冲的地支（六冲）
  /// 规律：地支环相差 6 个位置（对冲）
  /// 例如：子(0) 冲 午(6)； 丑(1) 冲 未(7)
  static DiZhi getChongZhi(DiZhi zhi) {
    return DiZhi.values[(zhi.index + 6) % 12];
  }

  /// 获取正冲的描述 (例如：生肖)
  /// 在黄历中通常显示为：“冲马”、“冲羊”
  /// [zhi] 为当天的日支（或当前的时支）
  static String getChongAnimal(DiZhi zhi) {
    final chongZhi = getChongZhi(zhi);
    return chongZhi.animal;
  }

  /// 计算“正冲” (对于指定的日主生年，是否被当天的日柱正冲)
  /// 真正的“正冲”不仅看地支相冲，还要看天干相克（天克地冲）。
  /// 但在普通万年历中，通常只看地支相冲即可。
  /// 比如今天庚午日，你是属鼠（子年生人），那你今天就是“被冲”了，诸事不宜。
  static bool isChong(DiZhi dayZhi, DiZhi userYearZhi) {
    return getChongZhi(dayZhi) == userYearZhi;
  }

  // ==========================================
  // 【二】煞 (Sha / 煞向)
  // ==========================================

  /// 获取指定地支的煞方 (Directional Clash)
  /// 规律：基于地支三合局的对冲方
  /// - 申子辰（水局，正北）：煞在南方（南）
  /// - 亥卯未（木局，正东）：煞在西方（西）
  /// - 寅午戌（火局，正南）：煞在北方（北）
  /// - 巳酉丑（金局，正西）：煞在东方（东）
  static String getShaDirection(DiZhi zhi) {
    switch (zhi) {
      case DiZhi.shen:
      case DiZhi.zi:
      case DiZhi.chen:
        return '南'; // 水局冲火（南）
      case DiZhi.hai:
      case DiZhi.mao:
      case DiZhi.wei:
        return '西'; // 木局冲金（西）
      case DiZhi.yin:
      case DiZhi.wu:
      case DiZhi.xu:
        return '北'; // 火局冲水（北）
      case DiZhi.si:
      case DiZhi.you:
      case DiZhi.chou:
        return '东'; // 金局冲木（东）
    }
  }

  // ==========================================
  // 【辅助工具】
  // ==========================================

  /// 综合输出黄历常见的冲煞描述
  /// 例如输入“子”，输出：冲马 (戊午) 煞南
  /// 大多数黄历里，天干的推导常常使用五虎遁/五鼠遁或直接根据日柱干支的对冲。
  /// 这里提供一个极其经典的天干推导法（比如庚午冲甲子）。
  static String getChongShaString(GanZhi currentGanZhi) {
    final chongZhi = getChongZhi(currentGanZhi.zhi);
    final animal = chongZhi.animal;
    final shaDir = getShaDirection(currentGanZhi.zhi);

    // 天干的正冲：一般是天干第六位。比如甲(0)冲庚(6)。
    // 所以庚辰日，冲的是甲戌。
    final chongGan = TianGan.values[(currentGanZhi.gan.index + 6) % 10];

    return '冲$animal(${chongGan.label}${chongZhi.label}) 煞$shaDir';
  }
}
