// Generated file. Do not edit manually.

import '../utils/fast_bitset.dart';

enum AlmanacActivity {
  shang_ce('上册'),
  shang_guan('上官'),
  shang_biao_zhang('上表章'),
  lin_zheng('临政'),
  ju_zheng_zhi('举正直'),
  cheng_chuan_du_shui('乘船渡水'),
  fa_mu('伐木'),
  xiu_cang_ku('修仓库'),
  xiu_gong_shi('修宫室'),
  xiu_zhi_chan_shi('修置产室'),
  xiu_zao('修造'),
  xiu_shi_yuan_qiang('修饰垣墙'),
  ru_xue('入学'),
  ru_zhai('入宅'),
  guan_dai('冠带'),
  chu_shi('出师'),
  chu_xing('出行'),
  chu_huo_cai('出货财'),
  ti_tou('剃头'),
  qu_yu('取鱼'),
  qi_cuan('启攒'),
  sai_xue('塞穴'),
  jia_qu('嫁娶'),
  an_chuang('安床'),
  an_fu_bian_jing('安抚边境'),
  an_dui_wei('安碓硙'),
  an_zang('安葬'),
  xuan_zheng_shi('宣政事'),
  yan_hui('宴会'),
  bu_zheng_shi('布政事'),
  ping_zhi_dao_tu('平治道涂'),
  qing_ci('庆赐'),
  kai_cang('开仓'),
  kai_cang_ku('开仓库'),
  kai_shi('开市'),
  kai_zhang('开张'),
  kai_qu('开渠'),
  kai_qu_chuan_jing('开渠穿井'),
  xu_gu_qiong('恤孤茕'),
  sao_she_yu('扫舍宇'),
  zhao_xian('招贤'),
  bu_zhuo('捕捉'),
  ban_yi('搬移'),
  zheng_rong('整容'),
  zheng_shou_zu_jia('整手足甲'),
  shi_en('施恩'),
  zai_zhong('栽种'),
  qiu_yi_liao_bing('求医疗病'),
  qiu_si('求嗣'),
  qiu_fu('求福'),
  mu_yu('沐浴'),
  mu_yang('牧养'),
  tian_lie('畋猎'),
  liao_mu('疗目'),
  po_tu('破土'),
  po_wu_huai_yuan('破屋坏垣'),
  qi_si('祈嗣'),
  qi_fu('祈福'),
  ji_si('祭祀'),
  yi_xi('移徙'),
  chuan_jing('穿井'),
  li_quan('立券'),
  li_quan_jiao_yi('立券交易'),
  shu_zhu_shang_liang('竖柱上梁'),
  zhu_di_fang('筑堤防'),
  zhu_di_ti('筑提'), // 死代码：原作笔误，正确应为"筑堤防"，保留以维持索引稳定
  na_chu('纳畜'),
  na_cai('纳财'),
  na_cai_marry('纳采'),
  na_cai_wen_ming('纳采问名'),
  jing_luo('经络'),
  jie_hun_yin('结婚姻'),
  shan_cheng_guo('缮城郭'),
  shan_gai('苫盖'),
  ying_jian('营建'),
  ying_jian_gong_shi('营建宫室'),
  bu_yuan('补垣'),
  bu_yuan_sai_xue('补垣塞穴'),
  cai_zhi('裁制'),
  cai_yi('裁衣'),
  tan_en('覃恩'),
  jie_chu('解除'),
  su_song('诉讼'),
  zhao_ming_gong_qing('诏命公卿'),
  zhu_shi_bu_yi('诸事不宜'),
  zhu_shi_bu_ji('诸事不忌'),
  zhu_shi_jie_ji('诸事皆忌'),
  shang_he('赏贺'),
  fu_ren('赴任'),
  jin_ren_kou('进人口'),
  yuan_hui('远回'),
  xuan_jiang('选将'),
  qian_shi('遣使'),
  yun_niang('酝酿'),
  zhen_ci('针刺'),
  xue_yuan('雪冤'),
  ban_zhao('颁诏'),
  gu_zhu('鼓铸');

  final String label;
  const AlmanacActivity(this.label);

  static AlmanacActivity? fromLabel(String label) {
    for (var value in values) {
      if (value.label == label) return value;
    }
    return null;
  }

  static const List<int> sortPriority = [
    3, // [ 0] shang_ce(上册)
    26, // [ 1] shang_guan(上官)
    3, // [ 2] shang_biao_zhang(上表章)
    27, // [ 3] lin_zheng(临政)
    9, // [ 4] ju_zheng_zhi(举正直)
    72, // [ 5] cheng_chuan_du_shui(乘船渡水)
    68, // [ 6] fa_mu(伐木)
    49, // [ 7] xiu_cang_ku(修仓库)
    44, // [ 8] xiu_gong_shi(修宫室)
    60, // [ 9] xiu_zhi_chan_shi(修置产室)
    47, // [10] xiu_zao(修造)
    65, // [11] xiu_shi_yuan_qiang(修饰垣墙)
    19, // [12] ru_xue(入学)
    32, // [13] ru_zhai(入宅)
    20, // [14] guan_dai(冠带)
    25, // [15] chu_shi(出师)
    79, // [16] chu_xing(出行)
    59, // [17] chu_huo_cai(出货财)
    37, // [18] ti_tou(剃头)
    71, // [19] qu_yu(取鱼)
    78, // [20] qi_cuan(启攒)
    63, // [21] sai_xue(塞穴)
    30, // [22] jia_qu(嫁娶)
    34, // [23] an_chuang(安床)
    23, // [24] an_fu_bian_jing(安抚边境)
    62, // [25] an_dui_wei(安碓硙)
    77, // [26] an_zang(安葬)
    12, // [27] xuan_zheng_shi(宣政事)
    18, // [28] yan_hui(宴会)
    13, // [29] bu_zheng_shi(布政事)
    66, // [30] ping_zhi_dao_tu(平治道涂)
    17, // [31] qing_ci(庆赐)
    58, // [32] kai_cang(开仓)
    58, // [33] kai_cang_ku(开仓库)
    54, // [34] kai_shi(开市)
    54, // [35] kai_zhang(开张)
    61, // [36] kai_qu(开渠)
    61, // [37] kai_qu_chuan_jing(开渠穿井)
    11, // [38] xu_gu_qiong(恤孤茕)
    64, // [39] sao_she_yu(扫舍宇)
    8, // [40] zhao_xian(招贤)
    69, // [41] bu_zhuo(捕捉)
    32, // [42] ban_yi(搬移)
    37, // [43] zheng_rong(整容)
    38, // [44] zheng_shou_zu_jia(整手足甲)
    6, // [45] shi_en(施恩)
    73, // [46] zai_zhong(栽种)
    39, // [47] qiu_yi_liao_bing(求医疗病)
    2, // [48] qiu_si(求嗣)
    1, // [49] qiu_fu(求福)
    36, // [50] mu_yu(沐浴)
    74, // [51] mu_yang(牧养)
    70, // [52] tian_lie(畋猎)
    40, // [53] liao_mu(疗目)
    76, // [54] po_tu(破土)
    67, // [55] po_wu_huai_yuan(破屋坏垣)
    2, // [56] qi_si(祈嗣)
    1, // [57] qi_fu(祈福)
    0, // [58] ji_si(祭祀)
    32, // [59] yi_xi(移徙)
    61, // [60] chuan_jing(穿井)
    55, // [61] li_quan(立券)
    55, // [62] li_quan_jiao_yi(立券交易)
    48, // [63] shu_zhu_shang_liang(竖柱上梁)
    46, // [64] zhu_di_fang(筑堤防)
    46, // [65] zhu_di_ti(筑提)
    75, // [66] na_chu(纳畜)
    57, // [67] na_cai(纳财)
    29, // [68] na_cai_marry(纳采)
    29, // [69] na_cai_wen_ming(纳采问名)
    52, // [70] jing_luo(经络)
    28, // [71] jie_hun_yin(结婚姻)
    45, // [72] shan_cheng_guo(缮城郭)
    51, // [73] shan_gai(苫盖)
    43, // [74] ying_jian(营建)
    43, // [75] ying_jian_gong_shi(营建宫室)
    63, // [76] bu_yuan(补垣)
    63, // [77] bu_yuan_sai_xue(补垣塞穴)
    42, // [78] cai_zhi(裁制)
    42, // [79] cai_yi(裁衣)
    5, // [80] tan_en(覃恩)
    35, // [81] jie_chu(解除)
    16, // [82] su_song(诉讼)
    7, // [83] zhao_ming_gong_qing(诏命公卿)
    79, // [84] zhu_shi_bu_yi(诸事不宜)
    79, // [85] zhu_shi_bu_ji(诸事不忌)
    79, // [86] zhu_shi_jie_ji(诸事皆忌)
    17, // [87] shang_he(赏贺)
    26, // [88] fu_ren(赴任)
    31, // [89] jin_ren_kou(进人口)
    33, // [90] yuan_hui(远回)
    24, // [91] xuan_jiang(选将)
    22, // [92] qian_shi(遣使)
    53, // [93] yun_niang(酝酿)
    41, // [94] zhen_ci(针刺)
    15, // [95] xue_yuan(雪冤)
    4, // [96] ban_zhao(颁诏)
    50, // [97] gu_zhu(鼓铸)
  ];

  /// 御用六十七事 (65项匹配)
  static final FastBitSet imperial67 = FastBitSet.fromChunks(98, [
    0xfbccdf5f,
    0xe61dffe4,
    0x9b8b59ed,
    0x00000001,
  ]);

  /// 民用三十七事 (36项匹配)
  static final FastBitSet civilian37 = FastBitSet.fromChunks(98, [
    0x46d55646,
    0xecdcc2a4,
    0x020080c8,
    0x00000000,
  ]);

  /// 通书六十事 (59项匹配)
  static final FastBitSet tongshu60 = FastBitSet.fromChunks(98, [
    0x46df5eef,
    0xeefdd2a6,
    0x6702a2ed,
    0x00000002,
  ]);

  /// 原版 CNLunar 遗留三十八事 (为保持完全向下兼容)
  /// 这张表是原作者私改的，既非御用也非民用，排序也错乱，但如果用户想跟原 Python 库100%对齐可以使用
  static final FastBitSet cnlunarLegacy38 = FastBitSet.fromChunks(98, [
    0x56d55646,
    0xfcdcc294,
    0x030080c8,
    0x00000000,
  ]);
}
