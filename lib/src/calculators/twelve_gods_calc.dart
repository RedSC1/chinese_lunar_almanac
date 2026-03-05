import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../utils/fast_bitset.dart';

/// 十二值神 (Twelve Value Gods) / 黄黑道抽象基类
///
/// 包含日值神（黄道吉日）和时值神（黄道吉时）共用的基础属性与算法模式。
abstract class TwelveGods {
  final String name;

  /// 是否为黄道 (true: 黄道, false: 黑道)
  final bool isHuangDao;

  const TwelveGods({required this.name, required this.isHuangDao});

  @override
  String toString() => '$name (${isHuangDao ? "黄道" : "黑道"})';

  /// 提取共用的圆环偏移量算法机制
  static int getOffset(int targetIndex, int startIndex) {
    return (targetIndex - startIndex + 12) % 12;
  }
}

/// 日值神 (黄道吉日)
class DailyTwelveGods extends TwelveGods {
  const DailyTwelveGods({required super.name, required super.isHuangDao});

  static const List<DailyTwelveGods> values = [
    DailyTwelveGods(name: '青龙', isHuangDao: true),
    DailyTwelveGods(name: '明堂', isHuangDao: true),
    DailyTwelveGods(name: '天刑', isHuangDao: false),
    DailyTwelveGods(name: '朱雀', isHuangDao: false),
    DailyTwelveGods(name: '金匮', isHuangDao: true),
    DailyTwelveGods(name: '天德', isHuangDao: true),
    DailyTwelveGods(name: '白虎', isHuangDao: false),
    DailyTwelveGods(name: '玉堂', isHuangDao: true),
    DailyTwelveGods(name: '天牢', isHuangDao: false),
    DailyTwelveGods(name: '玄武', isHuangDao: false),
    DailyTwelveGods(name: '司命', isHuangDao: true),
    DailyTwelveGods(name: '勾陈', isHuangDao: false),
  ];

  /// 计算当日的十二值神
  static DailyTwelveGods calculate(DiZhi monthZhi, DiZhi dayZhi) {
    // 日神起点规则：寅申子起，卯酉寅起，辰戌辰起，巳亥午起，午子申起，未丑戌起。
    final startZhiIndex = ((monthZhi.index - 2 + 12) % 6) * 2;
    final offset = TwelveGods.getOffset(dayZhi.index, startZhiIndex);
    return values[offset];
  }
}

/// 时值神 (黄道吉时)
class HourlyTwelveGods extends TwelveGods {
  const HourlyTwelveGods({required super.name, required super.isHuangDao});

  static const List<HourlyTwelveGods> values = [
    HourlyTwelveGods(name: '青龙', isHuangDao: true),
    HourlyTwelveGods(name: '明堂', isHuangDao: true),
    HourlyTwelveGods(name: '天刑', isHuangDao: false),
    HourlyTwelveGods(name: '朱雀', isHuangDao: false),
    HourlyTwelveGods(name: '金匮', isHuangDao: true),
    HourlyTwelveGods(name: '天德', isHuangDao: true),
    HourlyTwelveGods(name: '白虎', isHuangDao: false),
    HourlyTwelveGods(name: '玉堂', isHuangDao: true),
    HourlyTwelveGods(name: '天牢', isHuangDao: false),
    HourlyTwelveGods(name: '玄武', isHuangDao: false),
    HourlyTwelveGods(name: '司命', isHuangDao: true),
    HourlyTwelveGods(name: '勾陈', isHuangDao: false),
  ];

  /// 计算此时的黄道吉时（金符经）
  static HourlyTwelveGods calculate(DiZhi dayZhi, DiZhi hourZhi) {
    // 时神起点规则 (子午申起，丑未戌起，寅申子起，卯酉寅起，辰戌辰起，巳亥午起)
    final startZhiIndex = (((dayZhi.index % 6) * 2) + 8) % 12;
    final offset = TwelveGods.getOffset(hourZhi.index, startZhiIndex);
    return values[offset];
  }

  /// 一键获取今日 12 个时辰的黄道状态表 (FastBitSet 实现)
  ///
  /// 返回一个长度为 12 的位图。
  /// 索引 0 代表子时，索引 1 代表丑时... 若位图该位为 1 (true)，则为黄道吉时。
  static FastBitSet getHuangDaoBitSet(DiZhi dayZhi) {
    final startZhiIndex = (((dayZhi.index % 6) * 2) + 8) % 12;
    List<int> huangDaoIndices = [];

    // 遍历这 12 个神仙，找出黄道的索引（青龙(0), 明堂(1), 金匮(4), 天德(5), 玉堂(7), 司命(10)）
    for (int i = 0; i < 12; i++) {
      // 反推该神落在哪一个时辰上
      // 因为 offset = (hour - start + 12) % 12
      // 所以 hour = (offset + start) % 12
      if (values[i].isHuangDao) {
        int absoluteHourIndex = (i + startZhiIndex) % 12;
        huangDaoIndices.add(absoluteHourIndex);
      }
    }

    return FastBitSet.fromIndices(12, huangDaoIndices);
  }

  // ==========================================
  // 【超高性能：静态位图池】
  // ==========================================

  /// 由于不论输入什么天干地支，黄道吉时的排布只受日地支的【模6】影响，
  /// （即：子午同局、丑未同局...）总共只有 6 种固定的位图模式。
  /// 我们可以预先算好这 6 种模式缓存在内存中，做到 O(1) 极速读取且不产生新对象。
  static final Map<int, FastBitSet> _fixedHuangDaoBitSets = {
    for (int i = 0; i < 6; i++) i: getHuangDaoBitSet(DiZhi.values[i]),
  };

  /// 极限性能版：直接获取固定缓存中的黄道位图 (免重复计算、免创建新对象)
  ///
  /// 使用场景：高并发黄历批处理 / AlmanacEngine 组装层
  static FastBitSet getFixedHuangDaoBitSet(DiZhi dayZhi) {
    return _fixedHuangDaoBitSets[dayZhi.index % 6]!;
  }
}
