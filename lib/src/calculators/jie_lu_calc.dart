//下面内容是ai建议生成的，我看别的库好像显示每日吉时没有考虑这个截路空亡的啊？？
//留着吧有人用就用

import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../utils/fast_bitset.dart';

/// 截路空亡 (Jie Lu Kong Wang / Intersecting Road Emptiness)
///
/// 择吉术中的时辰煞。出门、求财、远行之大忌。
/// 【注意】：这是高级/硬核规则。在主流 App中，
/// 默认的时辰吉凶通常只参考“黄黑道十二神”，暂不在此处做全局合并。
class JieLu {
  /// 判断指定时辰是否为截路空亡
  /// [hourGan]: 时辰的天干
  static bool isJieLu(TianGan hourGan) {
    return hourGan == TianGan.ren || hourGan == TianGan.gui;
  }

  /// 获取指定日天干对应的 12 个时辰截路空亡位图
  ///
  /// 逻辑：根据“五鼠遁”规律，找出哪些时辰的地支对应的天干是壬、癸。
  static FastBitSet getBitSet(TianGan dayGan) {
    return _fixedJieLuBitSets[dayGan.index % 5]!;
  }

  // ==========================================
  // 【静态缓存池】
  // ==========================================

  /// 由于截路空亡只受日天干影响，且甲己、乙庚、丙辛、丁壬、戊癸同局。
  /// 总共只有 5 种固定的位图模式。
  static final Map<int, FastBitSet> _fixedJieLuBitSets = {
    0: _calculateForDayGan(TianGan.jia), // 甲、己
    1: _calculateForDayGan(TianGan.yi), // 乙、庚
    2: _calculateForDayGan(TianGan.bing), // 丙、辛
    3: _calculateForDayGan(TianGan.ding), // 丁、壬
    4: _calculateForDayGan(TianGan.wu), // 戊、癸
  };

  static FastBitSet _calculateForDayGan(TianGan dayGan) {
    List<int> luckyIndices = [];
    for (int i = 0; i < 12; i++) {
      // 这里的逻辑需要用到“五鼠遁”来根据日干和时支求时干
      // 五鼠遁：
      // 时干索引 = (日干索引 * 2 + 时支索引) % 10
      // 说明：甲(0)*2=0, 子(0)->0(甲子); 己(5)*2=10->0, 子(0)->0(甲子)
      int hourGanIndex = (dayGan.index * 2 + i) % 10;
      TianGan hourGan = TianGan.values[hourGanIndex];

      if (isJieLu(hourGan)) {
        luckyIndices.add(i);
      }
    }
    return FastBitSet.fromIndices(12, luckyIndices);
  }
}
