import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 彭祖百忌 (Peng Zu Bai Ji)
///
/// 择吉术中的重要民俗口诀。
/// 根据每日的天干、地支，各有一句禁忌。
class PengZu {
  /// 获取天干禁忌 (Peng Zu Gan Taboo)
  /// [gan]: 每日的天干
  static String getGanTaboo(TianGan gan) {
    return _ganTaboos[gan.index];
  }

  /// 获取地支禁忌 (Peng Zu Zhi Taboo)
  /// [zhi]: 每日的地支
  static String getZhiTaboo(DiZhi zhi) {
    return _zhiTaboos[zhi.index];
  }

  /// 获取完整的彭祖百忌描述
  /// 例如：戊不受田田主不祥，寅不祭祀神鬼不尝
  static String getFullTaboo(GanZhi ganZhi) {
    return '${getGanTaboo(ganZhi.gan)}，${getZhiTaboo(ganZhi.zhi)}';
  }

  // ==========================================
  // 【数据映射表】
  // ==========================================

  static const List<String> _ganTaboos = [
    '甲不开仓财物耗散',
    '乙不栽植千株不长',
    '丙不修灶必见灾殃',
    '丁不剃头头必生疮',
    '戊不受田田主不祥',
    '己不破券二比并亡',
    '庚不经络织机虚张',
    '辛不合酱主人不尝',
    '壬不汲水更难提防',
    '癸不词讼理弱敌强',
  ];

  static const List<String> _zhiTaboos = [
    '子不问卜自惹祸殃',
    '丑不冠带主不还乡',
    '寅不祭祀神鬼不尝',
    '卯不穿井水道不香',
    '辰不哭泣必主重丧',
    '巳不远行财物伏藏',
    '午不苫盖屋主更张',
    '未不服药毒气入肠',
    '申不安床鬼祟入房',
    '酉不会客醉坐颠狂',
    '戌不吃犬作怪上床',
    '亥不嫁娶不利新郎',
  ];
}
