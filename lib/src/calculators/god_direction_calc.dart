//。。。这个福神方位两个版本口诀哪个对？？？
//我懒得找了，我对齐一下tyme库好了(https://6tail.cn/tyme.html)
//哎哟卧槽，这个阴阳贵人的方位算法怎么和紫微斗数天魁天钺算法不一样？？？
//为什么tyme源码两个口诀？？
//作者没懂“甲戊庚牛羊”意思是甲戊庚的阳贵人在丑阴贵人在未？
//不管了跟紫微斗数对齐一下好了。。我看《钦定协纪辨方书》和紫微斗数是一样的，原文放下面了
/*
 * 【天乙贵人底层映射推导算法】
 * * 《蠡海集》曰：
 * “天乙贵人，当有阳贵、阴贵之分。盖阳贵起于子而顺，阴贵起于申而逆。
 * 此神实得阴阳配合之和，故能为吉庆，可解凶厄也。
 * * 且如阳贵（顺推法）：
 * 以甲加子，甲与己合，所以【己】用子为贵人；
 * 以乙加丑，乙与庚合，所以【庚】用丑为贵人；
 * 以丙加寅，丙与辛合，所以【辛】用寅为贵人；（注：六辛逢虎出处）
 * 以丁加卯，丁与壬合，所以【壬】用卯为贵人；
 * 辰为天罡，贵人不临（注：Exception跳过）；
 * 以戊加巳，戊与癸合，所以【癸】用巳为贵人；
 * 午冲子，原不数（注：Exception跳过）；
 * 以己加未，己与甲合，所以【甲】用未为贵人；
 * 以庚加申，庚与乙合，所以【乙】用申为贵人；
 * 以辛加酉，辛与丙合，所以【丙】用酉为贵人；
 * 戌为河魁，贵人不临（注：Exception跳过）；
 * 以壬加亥，壬与丁合，所以【丁】用亥为贵人；
 * 子原宫，不数（注：Exception跳过）；
 * 以癸加丑，癸与戊合，所以【戊】用丑为贵人。
 * 此乃阳贵顺取也。
 * * 且如阴贵（逆推法）：
 * 以甲加申，甲与己合，所以【己】用申为贵人；
 * 以乙加未，乙与庚合，所以【庚】用未为贵人；
 * 以丙加午，丙与辛合，所以【辛】用午为贵人；（注：六辛逢马出处）
 * 以丁加巳，丁与壬合，所以【壬】用巳为贵人；
 * 辰为天罡，贵人不临（注：Exception跳过）；
 * 以戊加卯，戊与癸合，所以【癸】用卯为贵人；
 * 寅冲申，原不数（注：Exception跳过）；
 * 以己加丑，己与甲合，所以【甲】用丑为贵人；
 * 以庚加子，庚与乙合，所以【乙】用子为贵人；
 * 以辛加亥，辛与丙合，所以【丙】用亥为贵人；
 * 戌为河魁，贵人不临（注：Exception跳过）；
 * 以壬加酉，壬与丁合，所以【丁】用酉为贵人；
 * 申原宫，不数（注：Exception跳过）；
 * 以癸加未，癸与戊合，所以【戊】用未为贵人。
 * 此乃阴贵逆取也。
 * * 古云：‘丑未为天乙贵人出入之门。’
 * 缘阳贵以甲起子，循丑顺行至癸，复归于丑；
 * 阴贵以甲起申，由未逆行至癸，复归于未。
 * 岂非丑未为贵人出入之门乎？”
 * * ==========================================
 * * ○ 曹震圭曰：
 * “天乙者，乃紫微垣左枢傍之一星，万神之主掌也。一日二者，阴阳分治内外之义也。
 * 辰戌为魁罡之位，故贵人不临。
 * 戊以配中央之位，乃勾陈后宫之象，故与甲同其起例。
 * 以丑乃紫微后门之左、阳界之辰也；未乃紫微南门之右、阴界之辰也。
 * 甲者，十干之首，故阳贵以甲加丑逆行：
 * 甲得丑，乙得子，丙得亥，丁得酉，巳得申，庚得未，辛得午，壬得巳，癸得卯，此昼日之贵也。
 * 阴贵以甲加未顺行：
 * 甲得未，乙得申，丙得酉，丁得亥，巳得子，庚得丑，辛得寅，壬得卯，癸得巳，此暮夜之贵也。
 * 戊以助甲成功，故亦得丑未。
 * 若【六辛之独得寅午】，则自然所致，更无疑矣。”
 * * ==========================================
 * * ○《通书》云：
 * “郭景纯以十干贵人为吉神之首，至静而能制群动，至尊而能镇飞浮。
 * 以其为坤黄中通理，乃贵人之德，是以阳贵人出于先天之坤而顺，阴贵人出于后天之坤而逆。
 * 天干之德未足为贵，而【干德之合气】乃为贵也。
 * （注：阳贵起于先天坤位“子”顺行，阴贵起于后天坤位“申”逆行，推导同蠡海集，表略）...”
 * * ==========================================
 * * 【官方 Code Review 裁决】
 * 《考原》曰：
 * “曹氏与《通书》二说各有意义，但曹氏则以阳为阴，以阴为阳。
 * 夫阳顺阴逆，阳前阴后，自然之理也，当以起未而顺者为阳，起丑而逆者为阴方是。
 * 按贵人云者，干德合方之神也，何以不用干德而用其合？
 * 干德，体也；合，则其用也。合干之德，其所用必大吉矣，故以贵人名之。
 * 合方之论，考历书所载审矣。
 * 而曹震圭阴阳顺逆倒置者，则世俗并如其说。
 * 考其根原，则以《元女经》有‘旦大吉、夕小吉’之文故也。
 * 然其理良不可通，则亦未得以《元女经》有其文而可遽信也。
 * 且大、小二字易以淆讹，安知非浅学之人，转以俗说改窜《元女经》，遂传刻袭谬耶？
 * * 【昼夜动态计算规则】
 * 至其昼夜之分，则或以卯酉为限，或以日出入为限。
 * 今考其义，【自当以日出入为定也】。”
 */

import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../models/compass_direction.dart';

/// 吉神方位 (God Directions)
///
/// 择吉术中根据日天干推算的五个主要吉神方向：
/// 1. 喜神 (Joy God): 主喜庆、姻缘。
/// 2. 福神 (Fortune God): 主平安、好运。
/// 3. Cai Shen (Wealth God): 主财运、生意。
/// 4. Yang Gui (Positive Noble): 白天（日出后）的贵人位。
/// 5. Yin Gui (Negative Noble): 黑夜（日落后）的贵人位。
class GodDirection {
  /// 喜神方位
  /// 口诀：甲己在艮(东北)，乙庚在乾(西北)，丙辛在坤(西南)，丁壬在离(正南)，戊癸在巽(东南)。
  static CompassDirection getXiShen(TianGan dayGan) {
    const directions = [
      CompassDirection.northeast,
      CompassDirection.northwest,
      CompassDirection.southwest,
      CompassDirection.south,
      CompassDirection.southeast,
    ];
    return directions[dayGan.index % 5];
  }

  /// 财神方位
  /// 口诀：甲乙东北是财神，丙丁向在西南寻，戊己正北坐方位，庚辛正东去安身，壬癸原来正南坐。
  static CompassDirection getCaiShen(TianGan dayGan) {
    const directions = [
      CompassDirection.northeast,
      CompassDirection.southwest,
      CompassDirection.north,
      CompassDirection.east,
      CompassDirection.south,
    ];
    return directions[dayGan.index ~/ 2];
  }

  /// 福神方位 (采用民间通传版本，对标主流万年历 App)
  /// 口诀：甲乙东南是福神，丙丁正东是其真，戊北己南庚辛坤，壬在乾方癸在西。
  static CompassDirection getFuShen(TianGan dayGan) {
    const directions = [
      CompassDirection.southeast,
      CompassDirection.southeast,
      CompassDirection.east,
      CompassDirection.east,
      CompassDirection.north,
      CompassDirection.south,
      CompassDirection.southwest,
      CompassDirection.southwest,
      CompassDirection.northwest,
      CompassDirection.west,
    ];
    return directions[dayGan.index];
  }

  /// 阳贵神方位 (等同于紫微斗数：天魁星方位)
  /// 逻辑依据：《钦定协纪辨方书》及其“阳贵起于丑而顺”推导算法
  /// 白天（日出后）的贵人位。
  ///
  /// “甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸兔蛇藏，六辛逢虎马，此是贵人方。”
  static CompassDirection getYangGui(TianGan dayGan) {
    const directions = [
      CompassDirection.northeast, // 0: 甲 (丑)
      CompassDirection.north, // 1: 乙 (子)
      CompassDirection.northwest, // 2: 丙 (亥)
      CompassDirection.northwest, // 3: 丁 (亥)
      CompassDirection.northeast, // 4: 戊 (丑)
      CompassDirection.north, // 5: 己 (子)
      CompassDirection.northeast, // 6: 庚 (丑)
      CompassDirection.south, // 7: 辛 (午)
      CompassDirection.east, // 8: 壬 (卯)
      CompassDirection.east, // 9: 癸 (卯)
    ];
    return directions[dayGan.index];
  }

  /// 阴贵神方位 (等同于紫微斗数：天钺星方位)
  /// 黑夜（日落后）的贵人位。
  ///
  /// “甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸兔蛇藏，六辛逢虎马，此是贵人方。”
  static CompassDirection getYinGui(TianGan dayGan) {
    const directions = [
      CompassDirection.southwest, // 0: 甲 (未)
      CompassDirection.southwest, // 1: 乙 (申)
      CompassDirection.west, // 2: 丙 (酉)
      CompassDirection.west, // 3: 丁 (酉)
      CompassDirection.southwest, // 4: 戊 (未)
      CompassDirection.southwest, // 5: 己 (申)
      CompassDirection.southwest, // 6: 庚 (未)
      CompassDirection.northeast, // 7: 辛 (寅)
      CompassDirection.southeast, // 8: 壬 (巳)
      CompassDirection.southeast, // 9: 癸 (巳)
    ];
    return directions[dayGan.index];
  }

  /// 获取所有方位的综合描述
  static Map<String, CompassDirection> getAll(TianGan dayGan) {
    return {
      '喜神': getXiShen(dayGan),
      '福神': getFuShen(dayGan),
      '财神': getCaiShen(dayGan),
      '阳贵': getYangGui(dayGan),
      '阴贵': getYinGui(dayGan),
    };
  }
}
