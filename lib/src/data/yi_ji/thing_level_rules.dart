// Generated file. Do not edit manually.
// 宜忌等第平铺判定表 (Thing Level Rules)

import '../../utils/fast_bitset.dart';

class ThingLevelRule {
  /// 月份掩码 (bit 0=子, bit 11=亥)
  final int monthMask;
  /// 所需实神掩码 (171-bit)
  final FastBitSet realGodMask;
  /// 所需虚神掩码 (15-bit)
  final int virtualGodMask;
  /// 降级等级 (0~5)
  final int level;

  const ThingLevelRule({
    required this.monthMask,
    required this.realGodMask,
    required this.virtualGodMask,
    required this.level,
  });
}

class ThingLevelRules {
  static final List<ThingLevelRule> rules = [
    // 平日: 亥 + ['相日'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0800,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 0,
    ),
    // 平日: 亥 + ['时德'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0800,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000080, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 0,
    ),
    // 平日: 亥 + ['六合'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0800,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 0,
    ),
    // 平日: 巳 + ['相日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 1,
    ),
    // 平日: 巳 + ['六合'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 1,
    ),
    // 平日: 巳 + ['月刑'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 1,
    ),
    // 平日: 申 + ['相日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0100,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 2,
    ),
    // 平日: 申 + ['月害'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0100,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 2,
    ),
    // 平日: 寅 + ['相日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 平日: 寅 + ['月害'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 平日: 寅 + ['月刑'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 平日: 卯午酉 + ['天吏'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0248,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 平日: 辰戌丑未 + ['月煞'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00080000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 4,
    ),
    // 平日: 子 + ['天吏'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 4,
    ),
    // 平日: 子 + ['月刑'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 4,
    ),
    // 收日: 寅申 + ['长生'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet(171),
      virtualGodMask: 0x2200,
      level: 0,
    ),
    // 收日: 寅申 + ['六合'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 0,
    ),
    // 收日: 寅申 + ['劫煞'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 0,
    ),
    // 收日: 巳亥 + ['长生'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet(171),
      virtualGodMask: 0x2200,
      level: 2,
    ),
    // 收日: 巳亥 + ['劫煞'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 2,
    ),
    // 收日: 巳亥 + ['月害'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 2,
    ),
    // 收日: 辰未 + ['月害'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0090,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 2,
    ),
    // 收日: 子午酉 + ['大时'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0241,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 3,
    ),
    // 收日: 丑戌 + ['月刑'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0402,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 3,
    ),
    // 收日: 卯 + ['大时'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0008,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 4,
    ),
    // 闭日: 子午卯酉 + ['王日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0249,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000100, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 3,
    ),
    // 闭日: 辰戌丑未 + ['官日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00800000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 3,
    ),
    // 闭日: 辰戌丑未 + ['天吏'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 3,
    ),
    // 闭日: 寅申巳亥 + ['月煞'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0924,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00080000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 4,
    ),
    // 劫煞: 寅申 + ['长生'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x2000,
      level: 0,
    ),
    // 劫煞: 寅申 + ['六合'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet.fromChunks(171, [0x20800000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 0,
    ),
    // 劫煞: 辰戌丑未 + ['除日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0002,
      level: 1,
    ),
    // 劫煞: 辰戌丑未 + ['相日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 1,
    ),
    // 劫煞: 巳亥 + ['长生'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x2000,
      level: 2,
    ),
    // 劫煞: 巳亥 + ['月害'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 劫煞: 子午卯酉 + ['执日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0249,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0020,
      level: 3,
    ),
    // 灾煞: 寅申巳亥 + ['开日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0924,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000010, 0x00000000]),
      virtualGodMask: 0x0400,
      level: 1,
    ),
    // 灾煞: 辰戌丑未 + ['满日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000010, 0x00000000]),
      virtualGodMask: 0x0004,
      level: 2,
    ),
    // 灾煞: 辰戌丑未 + ['民日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000011, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 灾煞: 子午 + ['月破'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0041,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00100000, 0x00000010, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 灾煞: 卯酉 + ['月破'] -> Level 5
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00100000, 0x00000010, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 5,
    ),
    // 灾煞: 卯酉 + ['月厌'] -> Level 5
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000010, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 5,
    ),
    // 月煞: 卯酉 + ['六合'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00000000, 0x00000000, 0x00080000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 1,
    ),
    // 月煞: 卯酉 + ['危日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00080000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0080,
      level: 1,
    ),
    // 月煞: 子午 + ['月害'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0041,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00081000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月煞: 子午 + ['危日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0041,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00080000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0080,
      level: 3,
    ),
    // 月刑: 巳 + ['平日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 1,
    ),
    // 月刑: 巳 + ['六合'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 1,
    ),
    // 月刑: 巳 + ['相日'] -> Level 1
    ThingLevelRule(
      monthMask: 0x0020,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 1,
    ),
    // 月刑: 寅 + ['相日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月刑: 寅 + ['月害'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月刑: 寅 + ['平日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 月刑: 辰酉亥 + ['建日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0a10,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0001,
      level: 3,
    ),
    // 月刑: 子 + ['平日'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 4,
    ),
    // 月刑: 子 + ['天吏'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月刑: 卯 + ['收日'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0008,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 4,
    ),
    // 月刑: 卯 + ['大时'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0008,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月刑: 未申 + ['月破'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0180,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00100400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月刑: 午 + ['月建'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00002400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月刑: 午 + ['月厌'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000c00, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月刑: 午 + ['德大会'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x1000,
      level: 4,
    ),
    // 月害: 卯酉 + ['守日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00400000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 月害: 卯酉 + ['除日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0002,
      level: 2,
    ),
    // 月害: 丑未 + ['执日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0082,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0020,
      level: 2,
    ),
    // 月害: 丑未 + ['大时'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0082,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 月害: 巳亥 + ['长生'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x2000,
      level: 2,
    ),
    // 月害: 巳亥 + ['劫煞'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x20000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 月害: 申 + ['相日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0100,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 月害: 申 + ['平日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0100,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 2,
    ),
    // 月害: 子午 + ['月煞'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0041,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00081000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月害: 辰戌 + ['官日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00800000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月害: 辰戌 + ['闭日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 3,
    ),
    // 月害: 辰戌 + ['天吏'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月害: 寅 + ['相日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00001000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月害: 寅 + ['平日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 月害: 寅 + ['月刑'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0004,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00001400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 3,
    ),
    // 月厌: 寅申 + ['成日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0104,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0100,
      level: 2,
    ),
    // 月厌: 丑未 + ['开日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0082,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0400,
      level: 2,
    ),
    // 月厌: 辰戌 + ['定日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0010,
      level: 3,
    ),
    // 月厌: 巳亥 + ['满日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0820,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0004,
      level: 3,
    ),
    // 月厌: 子 + ['月建'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00002800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月厌: 子 + ['德大会'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x1000,
      level: 4,
    ),
    // 月厌: 午 + ['月建'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00002800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月厌: 午 + ['月刑'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000c00, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 月厌: 午 + ['德大会'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0040,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00000800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x1000,
      level: 4,
    ),
    // 月厌: 卯酉 + ['月破'] -> Level 5
    ThingLevelRule(
      monthMask: 0x0208,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00000000, 0x00000000, 0x00100800, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 5,
    ),
    // 大时: 寅申巳亥 + ['除日'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0924,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0002,
      level: 0,
    ),
    // 大时: 寅申巳亥 + ['官日'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0924,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00800000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 0,
    ),
    // 大时: 辰戌 + ['执日'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0020,
      level: 0,
    ),
    // 大时: 辰戌 + ['六合'] -> Level 0
    ThingLevelRule(
      monthMask: 0x0410,
      realGodMask: FastBitSet.fromChunks(171, [0x00800000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 0,
    ),
    // 大时: 丑未 + ['执日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0082,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0020,
      level: 2,
    ),
    // 大时: 丑未 + ['月害'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0082,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00001000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 2,
    ),
    // 大时: 子午酉 + ['收日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0241,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 3,
    ),
    // 大时: 卯 + ['收日'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0008,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0200,
      level: 4,
    ),
    // 大时: 卯 + ['月刑'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0008,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x00200000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
    // 天吏: 寅申巳亥 + ['危日'] -> Level 2
    ThingLevelRule(
      monthMask: 0x0924,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0080,
      level: 2,
    ),
    // 天吏: 辰戌丑未 + ['闭日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0492,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0800,
      level: 3,
    ),
    // 天吏: 卯午酉 + ['平日'] -> Level 3
    ThingLevelRule(
      monthMask: 0x0248,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 3,
    ),
    // 天吏: 子 + ['平日'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0008,
      level: 4,
    ),
    // 天吏: 子 + ['月刑'] -> Level 4
    ThingLevelRule(
      monthMask: 0x0001,
      realGodMask: FastBitSet.fromChunks(171, [0x00000000, 0x40000000, 0x00000000, 0x00000400, 0x00000000, 0x00000000]),
      virtualGodMask: 0x0000,
      level: 4,
    ),
  ];
}
