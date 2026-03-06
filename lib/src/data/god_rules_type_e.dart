// Generated file. Do not edit manually.
// Type E god rules: season[0=Spring, 1=Summer, 2=Autumn, 3=Winter] → array of valid indices
// Runtime: if (table[seasonIndex].contains(targetIndex)) → god is active

import 'gods.dart';

/// 类型E神煞查表：季节索引[0-3] (春,夏,秋,冬)
class TypeEGodRules {
  // ==========================================
  // Group 1: Match Day Stem Index (d[0])
  // ==========================================
  /// 四相 (吉) L749: 丙丁 戊己 壬癸 甲乙
  static const List<List<int>> si_xiang = [
    [2, 3], // 春: 丙丁
    [4, 5], // 夏: 戊己
    [8, 9], // 秋: 壬癸
    [0, 1], // 冬: 甲乙
  ];

  /// 天贵 (吉) L776: 甲乙 丙丁 庚辛 壬癸
  static const List<List<int>> tian_gui = [
    [0, 1], // 春: 甲乙
    [2, 3], // 夏: 丙丁
    [6, 7], // 秋: 庚辛
    [8, 9], // 冬: 壬癸
  ];

  // ==========================================
  // Group 2: Match Day Branch Index (d[1])
  // ==========================================
  /// 时德 (吉) L759
  static const List<List<int>> shi_de = [
    [6], // 春: 午
    [4], // 夏: 辰
    [0], // 秋: 子
    [2], // 冬: 寅
  ];

  /// 王日 (吉) L769
  static const List<List<int>> wang_ri = [
    [2], // 春: 寅
    [5], // 夏: 巳
    [8], // 秋: 申
    [11], // 冬: 亥
  ];

  /// 官日 (吉) L771
  static const List<List<int>> guan_ri = [
    [3], // 春: 卯
    [6], // 夏: 午
    [9], // 秋: 酉
    [0], // 冬: 子
  ];

  /// 守日 (吉) L772
  static const List<List<int>> shou_ri = [
    [9], // 春: 酉
    [0], // 夏: 子
    [3], // 秋: 卯
    [6], // 冬: 午
  ];

  /// 相日 (吉) L773
  static const List<List<int>> xiang_ri = [
    [5], // 春: 巳
    [8], // 夏: 申
    [11], // 秋: 亥
    [2], // 冬: 寅
  ];

  /// 民日 (吉) L774
  static const List<List<int>> min_ri = [
    [6], // 春: 午
    [9], // 夏: 酉
    [0], // 秋: 子
    [3], // 冬: 卯
  ];

  /// 福厚 (吉) L799
  static const List<List<int>> fu_hou = [
    [2], // 春: 寅
    [5], // 夏: 巳
    [8], // 秋: 申
    [11], // 冬: 亥
  ];

  /// 母仓 (吉) L807
  static const List<List<int>> mu_cang = [
    [11, 0], // 春: 亥子
    [2, 3], // 夏: 寅卯
    [4, 1, 10, 7], // 秋: 辰丑戌未
    [8, 9], // 冬: 申酉
  ];

  /// 月建转杀 (凶) L971
  static const List<List<int>> yue_jian_zhuan_sha = [
    [3], // 春: 卯
    [6], // 夏: 午
    [9], // 秋: 酉
    [0], // 冬: 子
  ];

  /// 五虚 (凶) L959
  static const List<List<int>> wu_xu = [
    [5, 9, 1], // 春: 巳酉丑
    [8, 0, 4], // 夏: 申子辰
    [11, 3, 7], // 秋: 亥卯未
    [2, 6, 10], // 冬: 寅午戌
  ];

  /// 五离 (凶) L960
  static const List<List<int>> wu_li = [
    [8, 9], // 春: 申酉
    [8, 9], // 夏: 申酉
    [8, 9], // 秋: 申酉
    [8, 9], // 冬: 申酉
  ];

  /// 除神 (吉) L815
  static const List<List<int>> chu_shen = [
    [8, 9], // 春: 申酉
    [8, 9], // 夏: 申酉
    [8, 9], // 秋: 申酉
    [8, 9], // 冬: 申酉
  ];

  /// 荒芜 (凶) L972
  static const List<List<int>> huang_wu = [
    [5, 9, 1], // 春: 巳酉丑
    [8, 0, 4], // 夏: 申子辰
    [11, 3, 7], // 秋: 亥卯未
    [2, 6, 10], // 冬: 寅午戌
  ];

  // ==========================================
  // Group 3: Match Day GanZhi Index (0-59)
  // ==========================================
  /// 天转 (凶) L969
  static const List<List<int>> tian_zhuan = [
    [51], // 春: 乙卯
    [42], // 夏: 丙午
    [57], // 秋: 辛酉
    [48], // 冬: 壬子
  ];

  /// 地转 (凶) L970
  static const List<List<int>> di_zhuan = [
    [27], // 春: 辛卯
    [54], // 夏: 戊午
    [9], // 秋: 癸酉
    [12], // 冬: 丙子
  ];

  /// 四耗 (凶) L947
  static const List<List<int>> si_hao = [
    [48], // 春: 壬子
    [51], // 夏: 乙卯
    [54], // 秋: 戊午
    [57], // 冬: 辛酉
  ];

  /// 四穷 (凶) L948
  static const List<List<int>> si_qiong = [
    [11], // 春: 乙亥
    [23], // 夏: 丁亥
    [47], // 秋: 辛亥
    [59], // 冬: 癸亥
  ];

  /// 四忌 (凶) L950
  static const List<List<int>> si_ji_taboo = [
    [0], // 春: 甲子
    [12], // 夏: 丙子
    [36], // 秋: 庚子
    [48], // 冬: 壬子
  ];

  /// 四废 (凶) L951
  static const List<List<int>> si_fei = [
    [56, 57], // 春: 庚申辛酉
    [48, 59], // 夏: 壬子癸亥
    [50, 51], // 秋: 甲寅乙卯
    [53, 42], // 冬: 丁巳丙午
  ];

  /// 八风触水龙 (凶) L938
  static const List<List<int>> ba_feng_chu_shui_long = [
    [13, 45], // 春: 丁丑己酉
    [20, 40], // 夏: 甲申甲辰
    [7, 43], // 秋: 辛未丁未
    [10, 50], // 冬: 甲戌甲寅
  ];

  /// 匹配日天干的规则集合
  static const Map<AlmanacGod, List<List<int>>> stemMatch = {
    AlmanacGod.si_xiang: si_xiang,
    AlmanacGod.tian_gui: tian_gui,
  };

  /// 匹配日地支的规则集合
  static const Map<AlmanacGod, List<List<int>>> branchMatch = {
    AlmanacGod.shi_de: shi_de,
    AlmanacGod.wang_ri: wang_ri,
    AlmanacGod.guan_ri: guan_ri,
    AlmanacGod.shou_ri: shou_ri,
    AlmanacGod.xiang_ri: xiang_ri,
    AlmanacGod.min_ri: min_ri,
    AlmanacGod.fu_hou: fu_hou,
    AlmanacGod.mu_cang: mu_cang,
    AlmanacGod.yue_jian_zhuan_sha: yue_jian_zhuan_sha,
    AlmanacGod.wu_xu: wu_xu,
    AlmanacGod.wu_li: wu_li,
    AlmanacGod.chu_shen: chu_shen,
    AlmanacGod.huang_wu: huang_wu,
  };

  /// 匹配日柱的规则集合
  static const Map<AlmanacGod, List<List<int>>> pillarMatch = {
    AlmanacGod.tian_zhuan: tian_zhuan,
    AlmanacGod.di_zhuan: di_zhuan,
    AlmanacGod.si_hao: si_hao,
    AlmanacGod.si_qiong: si_qiong,
    AlmanacGod.si_ji_taboo: si_ji_taboo,
    AlmanacGod.si_fei: si_fei,
    AlmanacGod.ba_feng_chu_shui_long: ba_feng_chu_shui_long,
  };
}
