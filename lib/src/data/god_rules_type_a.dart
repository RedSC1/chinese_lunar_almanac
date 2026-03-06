// Generated file. Do not edit manually.
// Type A god rules: month[men] → branch index → match day branch
// Usage: if (dayBranchIndex == table[monthIndex]) → god is active

import 'gods.dart';

/// 类型A神煞查表：月份索引[0-11] → 触发地支索引[0-11]
/// 运行时判定：dayBranchIndex == table[monthIndex]
class TypeAGodRules {
  /// 五富 (吉) L754: 巳申亥寅巳申亥寅巳申亥寅
  static const wu_fu = [5, 8, 11, 2, 5, 8, 11, 2, 5, 8, 11, 2];

  /// 六合 (吉) L755: 丑子亥戌酉申未午巳辰卯寅
  static const liu_he = [1, 0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2];

  /// 六仪 (吉) L756: 午巳辰卯寅丑子亥戌酉申未
  static const liu_yi = [6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8, 7];

  /// 临日 (吉) L775: 辰酉午亥申丑戌卯子巳寅未
  static const lin_ri = [4, 9, 6, 11, 8, 1, 10, 3, 0, 5, 2, 7];

  /// 天富 (吉) L778: 寅卯辰巳午未申酉戌亥子丑
  static const tian_fu = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1];

  /// 天医 (吉) L794: 亥子丑寅卯辰巳午未申酉戌
  static const tian_yi = [11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  /// 天马 (吉) L795: 寅辰午申戌子寅辰午申戌子
  static const tian_ma = [2, 4, 6, 8, 10, 0, 2, 4, 6, 8, 10, 0];

  /// 驿马 (吉) L796: 寅亥申巳寅亥申巳寅亥申巳
  static const yi_ma = [2, 11, 8, 5, 2, 11, 8, 5, 2, 11, 8, 5];

  /// 天财 (吉) L797: 子寅辰午申戌子寅辰午申戌
  static const tian_cai = [0, 2, 4, 6, 8, 10, 0, 2, 4, 6, 8, 10];

  /// 福生 (吉) L798: 寅申酉卯戌辰亥巳子午丑未
  static const fu_sheng = [2, 8, 9, 3, 10, 4, 11, 5, 0, 6, 1, 7];

  /// 福德 (吉) L800: 寅卯辰巳午未申酉戌亥子丑
  static const fu_de = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1];

  /// 天巫 (吉) L801: 寅卯辰巳午未申酉戌亥子丑
  static const tian_wu = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1];

  /// 地财 (吉) L803: 丑卯巳未酉亥丑卯巳未酉亥
  static const di_cai = [1, 3, 5, 7, 9, 11, 1, 3, 5, 7, 9, 11];

  /// 月财 (吉) L804: 酉亥午巳巳未酉亥午巳巳未
  static const yue_cai = [9, 11, 6, 5, 5, 7, 9, 11, 6, 5, 5, 7];

  /// 圣心 (吉) L809: 辰戌亥巳子午丑未寅申卯酉
  static const sheng_xin = [4, 10, 11, 5, 0, 6, 1, 7, 2, 8, 3, 9];

  /// 禄库 (吉) L810: 寅卯辰巳午未申酉戌亥子丑
  static const lu_ku = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1];

  /// 吉庆 (吉) L812: 未子酉寅亥辰丑午卯申巳戌
  static const ji_qing = [7, 0, 9, 2, 11, 4, 1, 6, 3, 8, 5, 10];

  /// 阴德 (吉) L813: 丑亥酉未巳卯丑亥酉未巳卯
  static const yin_de = [1, 11, 9, 7, 5, 3, 1, 11, 9, 7, 5, 3];

  /// 活曜 (吉) L814: 卯申巳戌未子酉寅亥辰丑午
  static const huo_yao = [3, 8, 5, 10, 7, 0, 9, 2, 11, 4, 1, 6];

  /// 解神 (吉) L816: 午午申申戌戌子子寅寅辰辰
  static const jie_shen = [6, 6, 8, 8, 10, 10, 0, 0, 2, 2, 4, 4];

  /// 生气 (吉) L817: 戌亥子丑寅卯辰巳午未申酉
  static const sheng_qi = [10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  /// 普护 (吉) L818: 丑卯申寅酉卯戌辰亥巳子午
  static const pu_hu = [1, 3, 8, 2, 9, 3, 10, 4, 11, 5, 0, 6];

  /// 益后 (吉) L819: 巳亥子午丑未寅申卯酉辰戌
  static const yi_hou = [5, 11, 0, 6, 1, 7, 2, 8, 3, 9, 4, 10];

  /// 续世 (吉) L820: 午子丑未寅申卯酉辰戌巳亥
  static const xu_shi = [6, 0, 1, 7, 2, 8, 3, 9, 4, 10, 5, 11];

  /// 要安 (吉) L821: 未丑寅申卯酉辰戌巳亥午子
  static const yao_an = [7, 1, 2, 8, 3, 9, 4, 10, 5, 11, 6, 0];

  /// 天后 (吉) L822: 寅亥申巳寅亥申巳寅亥申巳
  static const tian_hou = [2, 11, 8, 5, 2, 11, 8, 5, 2, 11, 8, 5];

  /// 天仓 (吉) L823: 辰卯寅丑子亥戌酉申未午巳
  static const tian_cang = [4, 3, 2, 1, 0, 11, 10, 9, 8, 7, 6, 5];

  /// 敬安 (吉) L825: 子午未丑申寅酉卯戌辰亥巳
  static const jing_an = [0, 6, 7, 1, 8, 2, 9, 3, 10, 4, 11, 5];

  /// 玉宇 (吉) L826: 申寅卯酉辰戌巳亥午子未丑
  static const yu_yu = [8, 2, 3, 9, 4, 10, 5, 11, 6, 0, 7, 1];

  /// 金堂 (吉) L827: 酉卯辰戌巳亥午子未丑申寅
  static const jin_tang = [9, 3, 4, 10, 5, 11, 6, 0, 7, 1, 8, 2];

  /// 吉期 (吉) L828: 丑寅卯辰巳午未申酉戌亥子
  static const ji_qi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0];

  /// 小时 (吉) L829: 子丑寅卯辰巳午未申酉戌亥
  static const xiao_shi = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  /// 兵福 (吉) L830: 子丑寅卯辰巳午未申酉戌亥
  static const bing_fu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  /// 兵宝 (吉) L831: 丑寅卯辰巳午未申酉戌亥子
  static const bing_bao = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0];

  /// 天成 (吉) L792: 卯巳未酉亥丑卯巳未酉亥丑
  static const tian_cheng = [3, 5, 7, 9, 11, 1, 3, 5, 7, 9, 11, 1];

  /// 天官 (吉) L793: 午申戌子寅辰午申戌子寅辰
  static const tian_guan = [6, 8, 10, 0, 2, 4, 6, 8, 10, 0, 2, 4];

  /// 天罡 (凶) L839: 卯戌巳子未寅酉辰亥午丑申
  static const tian_gang = [3, 10, 5, 0, 7, 2, 9, 4, 11, 6, 1, 8];

  /// 河魁 (凶) L840: 酉辰亥午丑申卯戌巳子未寅
  static const he_kui = [9, 4, 11, 6, 1, 8, 3, 10, 5, 0, 7, 2];

  /// 死神 (凶) L841: 卯辰巳午未申酉戌亥子丑寅
  static const si_shen = [3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2];

  /// 死气 (凶) L843: 辰巳午未申酉戌亥子丑寅卯
  static const si_qi = [4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3];

  /// 官符 (凶) L846: 辰巳午未申酉戌亥子丑寅卯
  static const guan_fu = [4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3];

  /// 月建 (凶) L847: 子丑寅卯辰巳午未申酉戌亥
  static const yue_jian = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  /// 月破 (凶) L850: 午未申酉戌亥子丑寅卯辰巳
  static const yue_po = [6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5];

  /// 月煞 (凶) L855: 未辰丑戌未辰丑戌未辰丑戌
  static const yue_sha = [7, 4, 1, 10, 7, 4, 1, 10, 7, 4, 1, 10];

  /// 月害 (凶) L860: 未午巳辰卯寅丑子亥戌酉申
  static const yue_hai = [7, 6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8];

  /// 月刑 (凶) L863: 卯戌巳子辰申午丑寅酉未亥
  static const yue_xing = [3, 10, 5, 0, 4, 8, 6, 1, 2, 9, 7, 11];

  /// 月厌 (凶) L868: 子亥戌酉申未午巳辰卯寅丑
  static const yue_yan = [0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];

  /// 月虚 (凶) L874: 未辰丑戌未辰丑戌未辰丑戌
  static const yue_xu = [7, 4, 1, 10, 7, 4, 1, 10, 7, 4, 1, 10];

  /// 灾煞 (凶) L875: 午卯子酉午卯子酉午卯子酉
  static const zai_sha = [6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0, 9];

  /// 劫煞 (凶) L880: 巳寅亥申巳寅亥申巳寅亥申
  static const jie_sha = [5, 2, 11, 8, 5, 2, 11, 8, 5, 2, 11, 8];

  /// 厌对 (凶) L885: 午巳辰卯寅丑子亥戌酉申未
  static const yan_dui = [6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8, 7];

  /// 招摇 (凶) L886: 午巳辰卯寅丑子亥戌酉申未
  static const zhao_yao = [6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8, 7];

  /// 小红砂 (凶) L887: 酉丑巳酉丑巳酉丑巳酉丑巳
  static const xiao_hong_sha = [9, 1, 5, 9, 1, 5, 9, 1, 5, 9, 1, 5];

  /// 往亡 (凶) L889: 戌丑寅巳申亥卯午酉子辰未
  static const wang_wang = [10, 1, 2, 5, 8, 11, 3, 6, 9, 0, 4, 7];

  /// 神号 (凶) L895: 申酉戌亥子丑寅卯辰巳午未
  static const shen_hao = [8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7];

  /// 妨择 (凶) L896: 辰辰午午申申戌戌子子寅寅
  static const fang_ze = [4, 4, 6, 6, 8, 8, 10, 10, 0, 0, 2, 2];

  /// 披麻 (凶) L897: 午卯子酉午卯子酉午卯子酉
  static const pi_ma = [6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0, 9];

  /// 大耗 (凶) L899: 辰巳午未申酉戌亥子丑寅卯
  static const da_hao = [4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3];

  /// 天吏 (凶) L902: 卯子酉午卯子酉午卯子酉午
  static const tian_li = [3, 0, 9, 6, 3, 0, 9, 6, 3, 0, 9, 6];

  /// 天瘟 (凶) L906: 丑卯未戌辰寅午子酉申巳亥
  static const tian_wen = [1, 3, 7, 10, 4, 2, 6, 0, 9, 8, 5, 11];

  /// 天狱 (凶) L907: 午酉子卯午酉子卯午酉子卯
  static const tian_yu = [6, 9, 0, 3, 6, 9, 0, 3, 6, 9, 0, 3];

  /// 天火 (凶) L908: 午酉子卯午酉子卯午酉子卯
  static const tian_huo = [6, 9, 0, 3, 6, 9, 0, 3, 6, 9, 0, 3];

  /// 天棒 (凶) L909: 寅辰午申戌子寅辰午申戌子
  static const tian_bang = [2, 4, 6, 8, 10, 0, 2, 4, 6, 8, 10, 0];

  /// 天狗 (凶) L910: 寅卯辰巳午未申酉戌亥子丑
  static const tian_gou = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1];

  /// 天狗下食 (凶) L911: 戌亥子丑寅卯辰巳午未申酉
  static const tian_gou_xia_shi = [10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  /// 天贼 (凶) L912: 卯寅丑子亥戌酉申未午巳辰
  static const tian_zei = [3, 2, 1, 0, 11, 10, 9, 8, 7, 6, 5, 4];

  /// 地火 (凶) L917: 子亥戌酉申未午巳辰卯寅丑
  static const di_huo = [0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];

  /// 独火 (凶) L918: 未午巳辰卯寅丑子亥戌酉申
  static const du_huo = [7, 6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8];

  /// 受死 (凶) L919: 卯酉戌辰亥巳子午丑未寅申
  static const shou_si = [3, 9, 10, 4, 11, 5, 0, 6, 1, 7, 2, 8];

  /// 黄沙 (凶) L920: 寅子午寅子午寅子午寅子午
  static const huang_sha = [2, 0, 6, 2, 0, 6, 2, 0, 6, 2, 0, 6];

  /// 六不成 (凶) L921: 卯未寅午戌巳酉丑申子辰亥
  static const liu_bu_cheng = [3, 7, 2, 6, 10, 5, 9, 1, 8, 0, 4, 11];

  /// 小耗 (凶) L922: 卯辰巳午未申酉戌亥子丑寅
  static const xiao_hao = [3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2];

  /// 神隔 (凶) L923: 酉未巳卯丑亥酉未巳卯丑亥
  static const shen_ge = [9, 7, 5, 3, 1, 11, 9, 7, 5, 3, 1, 11];

  /// 朱雀 (凶) L924: 亥丑卯巳未酉亥丑卯巳未酉
  static const zhu_que = [11, 1, 3, 5, 7, 9, 11, 1, 3, 5, 7, 9];

  /// 白虎 (凶) L925: 寅辰午申戌子寅辰午申戌子
  static const bai_hu = [2, 4, 6, 8, 10, 0, 2, 4, 6, 8, 10, 0];

  /// 玄武 (凶) L926: 巳未酉亥丑卯巳未酉亥丑卯
  static const xuan_wu = [5, 7, 9, 11, 1, 3, 5, 7, 9, 11, 1, 3];

  /// 勾陈 (凶) L927: 未酉亥丑卯巳未酉亥丑卯巳
  static const gou_chen = [7, 9, 11, 1, 3, 5, 7, 9, 11, 1, 3, 5];

  /// 木马 (凶) L928: 辰午巳未酉申戌子亥丑卯寅
  static const mu_ma = [4, 6, 5, 7, 9, 8, 10, 0, 11, 1, 3, 2];

  /// 破败 (凶) L929: 辰午申戌子寅辰午申戌子寅
  static const po_bai = [4, 6, 8, 10, 0, 2, 4, 6, 8, 10, 0, 2];

  /// 殃败 (凶) L930: 巳辰卯寅丑子亥戌酉申未午
  static const yang_bai = [5, 4, 3, 2, 1, 0, 11, 10, 9, 8, 7, 6];

  /// 雷公 (凶) L931: 巳申寅亥巳申寅亥巳申寅亥
  static const lei_gong = [5, 8, 2, 11, 5, 8, 2, 11, 5, 8, 2, 11];

  /// 飞廉 (凶) L932: 申酉戌巳午未寅卯辰亥子丑
  static const fei_lian = [8, 9, 10, 5, 6, 7, 2, 3, 4, 11, 0, 1];

  /// 大煞 (凶) L933: 申酉戌巳午未寅卯辰亥子丑
  static const da_sha = [8, 9, 10, 5, 6, 7, 2, 3, 4, 11, 0, 1];

  /// 枯鱼 (凶) L935: 申巳辰丑戌未卯子酉午寅亥
  static const ku_yu = [8, 5, 4, 1, 10, 7, 3, 0, 9, 6, 2, 11];

  /// 九空 (凶) L936: 申巳辰丑戌未卯子酉午寅亥
  static const jiu_kong = [8, 5, 4, 1, 10, 7, 3, 0, 9, 6, 2, 11];

  /// 八座 (凶) L937: 酉戌亥子丑寅卯辰巳午未申
  static const ba_zuo = [9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8];

  /// 血忌 (凶) L939: 午子丑未寅申卯酉辰戌巳亥
  static const xue_ji = [6, 0, 1, 7, 2, 8, 3, 9, 4, 10, 5, 11];

  /// 四击 (凶) L944: 未未戌戌戌丑丑丑辰辰辰未
  static const si_ji = [7, 7, 10, 10, 10, 1, 1, 1, 4, 4, 4, 7];

  /// 五鬼 (凶) L961: 未戌午寅辰酉卯申丑巳子亥
  static const wu_gui = [7, 10, 6, 2, 4, 9, 3, 8, 1, 5, 0, 11];

  /// 九坎 (凶) L963: 申巳辰丑戌未卯子酉午寅亥
  static const jiu_kan = [8, 5, 4, 1, 10, 7, 3, 0, 9, 6, 2, 11];

  /// 九焦 (凶) L965: 申巳辰丑戌未卯子酉午寅亥
  static const jiu_jiao = [8, 5, 4, 1, 10, 7, 3, 0, 9, 6, 2, 11];

  /// 大时 (凶) L975: 酉午卯子酉午卯子酉午卯子
  static const da_shi = [9, 6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0];

  /// 大败 (凶) L980: 酉午卯子酉午卯子酉午卯子
  static const da_bai = [9, 6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0];

  /// 咸池 (凶) L984: 酉午卯子酉午卯子酉午卯子
  static const xian_chi = [9, 6, 3, 0, 9, 6, 3, 0, 9, 6, 3, 0];

  /// 土符 (凶) L986: 申子丑巳酉寅午戌卯未亥辰
  static const tu_fu_symbol = [8, 0, 1, 5, 9, 2, 6, 10, 3, 7, 11, 4];

  /// 土府 (凶) L989: 子丑寅卯辰巳午未申酉戌亥
  static const tu_fu = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  /// 血支 (凶) L995: 亥子丑寅卯辰巳午未申酉戌
  static const xue_zhi = [11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  /// 游祸 (凶) L997: 亥申巳寅亥申巳寅亥申巳寅
  static const you_huo = [11, 8, 5, 2, 11, 8, 5, 2, 11, 8, 5, 2];

  /// 归忌 (凶) L999: 寅子丑寅子丑寅子丑寅子丑
  static const gui_ji = [2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1];

  /// 所有类型A规则的索引表：AlmanacGod → 查表数组
  static const Map<AlmanacGod, List<int>> all = {
    AlmanacGod.wu_fu: wu_fu,
    AlmanacGod.liu_he: liu_he,
    AlmanacGod.liu_yi: liu_yi,
    AlmanacGod.lin_ri: lin_ri,
    AlmanacGod.tian_fu: tian_fu,
    AlmanacGod.tian_yi: tian_yi,
    AlmanacGod.tian_ma: tian_ma,
    AlmanacGod.yi_ma: yi_ma,
    AlmanacGod.tian_cai: tian_cai,
    AlmanacGod.fu_sheng: fu_sheng,
    AlmanacGod.fu_de: fu_de,
    AlmanacGod.tian_wu: tian_wu,
    AlmanacGod.di_cai: di_cai,
    AlmanacGod.yue_cai: yue_cai,
    AlmanacGod.sheng_xin: sheng_xin,
    AlmanacGod.lu_ku: lu_ku,
    AlmanacGod.ji_qing: ji_qing,
    AlmanacGod.yin_de: yin_de,
    AlmanacGod.huo_yao: huo_yao,
    AlmanacGod.jie_shen: jie_shen,
    AlmanacGod.sheng_qi: sheng_qi,
    AlmanacGod.pu_hu: pu_hu,
    AlmanacGod.yi_hou: yi_hou,
    AlmanacGod.xu_shi: xu_shi,
    AlmanacGod.yao_an: yao_an,
    AlmanacGod.tian_hou: tian_hou,
    AlmanacGod.tian_cang: tian_cang,
    AlmanacGod.jing_an: jing_an,
    AlmanacGod.yu_yu: yu_yu,
    AlmanacGod.jin_tang: jin_tang,
    AlmanacGod.ji_qi: ji_qi,
    AlmanacGod.xiao_shi: xiao_shi,
    AlmanacGod.bing_fu: bing_fu,
    AlmanacGod.bing_bao: bing_bao,
    AlmanacGod.tian_cheng: tian_cheng,
    AlmanacGod.tian_guan: tian_guan,
    AlmanacGod.tian_gang: tian_gang,
    AlmanacGod.he_kui: he_kui,
    AlmanacGod.si_shen: si_shen,
    AlmanacGod.si_qi: si_qi,
    AlmanacGod.guan_fu: guan_fu,
    AlmanacGod.yue_jian: yue_jian,
    AlmanacGod.yue_po: yue_po,
    AlmanacGod.yue_sha: yue_sha,
    AlmanacGod.yue_hai: yue_hai,
    AlmanacGod.yue_xing: yue_xing,
    AlmanacGod.yue_yan: yue_yan,
    AlmanacGod.yue_xu: yue_xu,
    AlmanacGod.zai_sha: zai_sha,
    AlmanacGod.jie_sha: jie_sha,
    AlmanacGod.yan_dui: yan_dui,
    AlmanacGod.zhao_yao: zhao_yao,
    AlmanacGod.xiao_hong_sha: xiao_hong_sha,
    AlmanacGod.wang_wang: wang_wang,
    AlmanacGod.shen_hao: shen_hao,
    AlmanacGod.fang_ze: fang_ze,
    AlmanacGod.pi_ma: pi_ma,
    AlmanacGod.da_hao: da_hao,
    AlmanacGod.tian_li: tian_li,
    AlmanacGod.tian_wen: tian_wen,
    AlmanacGod.tian_yu: tian_yu,
    AlmanacGod.tian_huo: tian_huo,
    AlmanacGod.tian_bang: tian_bang,
    AlmanacGod.tian_gou: tian_gou,
    AlmanacGod.tian_gou_xia_shi: tian_gou_xia_shi,
    AlmanacGod.tian_zei: tian_zei,
    AlmanacGod.di_huo: di_huo,
    AlmanacGod.du_huo: du_huo,
    AlmanacGod.shou_si: shou_si,
    AlmanacGod.huang_sha: huang_sha,
    AlmanacGod.liu_bu_cheng: liu_bu_cheng,
    AlmanacGod.xiao_hao: xiao_hao,
    AlmanacGod.shen_ge: shen_ge,
    AlmanacGod.zhu_que: zhu_que,
    AlmanacGod.bai_hu: bai_hu,
    AlmanacGod.xuan_wu: xuan_wu,
    AlmanacGod.gou_chen: gou_chen,
    AlmanacGod.mu_ma: mu_ma,
    AlmanacGod.po_bai: po_bai,
    AlmanacGod.yang_bai: yang_bai,
    AlmanacGod.lei_gong: lei_gong,
    AlmanacGod.fei_lian: fei_lian,
    AlmanacGod.da_sha: da_sha,
    AlmanacGod.ku_yu: ku_yu,
    AlmanacGod.jiu_kong: jiu_kong,
    AlmanacGod.ba_zuo: ba_zuo,
    AlmanacGod.xue_ji: xue_ji,
    AlmanacGod.si_ji: si_ji,
    AlmanacGod.wu_gui: wu_gui,
    AlmanacGod.jiu_kan: jiu_kan,
    AlmanacGod.jiu_jiao: jiu_jiao,
    AlmanacGod.da_shi: da_shi,
    AlmanacGod.da_bai: da_bai,
    AlmanacGod.xian_chi: xian_chi,
    AlmanacGod.tu_fu_symbol: tu_fu_symbol,
    AlmanacGod.tu_fu: tu_fu,
    AlmanacGod.xue_zhi: xue_zhi,
    AlmanacGod.you_huo: you_huo,
    AlmanacGod.gui_ji: gui_ji,
  };
}
