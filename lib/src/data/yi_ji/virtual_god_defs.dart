// virtual_god_defs.dart
// 虚拟神煞定义与计算
//
// "虚拟神煞"是指不在 AlmanacGod 枚举中，但在《钦定协纪辨方书》
// 宜忌等第判定表（badGodDic）中被引用的条件属性。
// 包括：十二建除日（建日、除日…闭日）、德大会、长生。
//
// 这些虚神与实神 (AlmanacGod) 共同参与 thing_level_rules 的掩码碰撞，
// 用一个 int (32-bit) 位图存储即可（目前仅需 15 位）。

/// 虚拟神煞枚举
///
/// 用于宜忌等第(badGodDic)规则碰撞中那些不属于 [AlmanacGod] 的条件。
/// 所有虚拟神煞的状态共用一个 int 位图（bit index = enum.index）。
enum VirtualGod {
  // ── 十二建除日 ──
  jian_ri('建日'), // 0
  chu_ri('除日'), // 1
  man_ri('满日'), // 2
  ping_ri('平日'), // 3
  ding_ri('定日'), // 4
  zhi_ri('执日'), // 5
  po_ri('破日'), // 6
  wei_ri('危日'), // 7
  cheng_ri('成日'), // 8
  shou_ri('收日'), // 9
  kai_ri('开日'), // 10
  bi_ri('闭日'), // 11

  // ── 复合 / 推导虚神 ──

  /// 德大会：月德 + 阴阳大会 同时在场时的复合状态。
  /// 具体触发条件：五月丙午日 或 十一月壬子日。
  /// 原理：在这两天，"月德"和"阴阳大会"的推算公式恰好碰撞到同一干支。
  de_da_hui('德大会'), // 12

  /// 长生：五行长生诀的当日命中状态（仅在寅申巳亥月有效）。
  /// 寅月(木旺)→亥日, 巳月(火旺)→寅日, 申月(金旺)→巳日, 亥月(水旺)→申日。
  chang_sheng('长生'), // 13

  /// 月建：当月月建地支与日支相同（badGodDic 中出现的条件之一）。
  /// 注：与 AlmanacGod.yue_jian 不同，这里特指日支 == 月建支的状态。
  yue_jian('月建'); // 14

  final String label;
  const VirtualGod(this.label);
}

/// 计算当天的虚拟神煞位图。
///
/// 返回一个 int，其中 bit[i] == 1 表示 VirtualGod.values[i] 处于激活状态。
///
/// 参数说明：
/// - [officerIndex]: 十二建除索引（0=建, 1=除, ... 11=闭）
/// - [monthBranch]: 月柱地支编号（0=子, 1=丑, ... 11=亥）
/// - [dayBranch]: 日柱地支编号（0=子, 1=丑, ... 11=亥）
/// - [dayStemBranch60]: 日柱六十甲子序号（0=甲子, ... 59=癸亥）
/// - [hasYueDe]: 当天是否命中实神"月德"（AlmanacGod.yue_de）
int computeVirtualGodBits({
  required int officerIndex,
  required int monthBranch,
  required int dayBranch,
  required int dayStemBranch60,
  required bool hasYueDe,
}) {
  int bits = 0;

  // ── 1. 十二建除日：直接点亮对应位 ──
  bits |= (1 << officerIndex);

  // ── 2. 德大会：月德 + 阴阳大会 的复合碰撞 ──
  // 午月(monthBranch==6): 大会日=丙午(index 42), 月德在丙
  // 子月(monthBranch==0): 大会日=壬子(index 48), 月德在壬
  // 只有在这两天，月德和大会同时出现，才触发"德大会"。
  if (hasYueDe) {
    if ((monthBranch == 6 && dayStemBranch60 == 42) || // 午月丙午日
        (monthBranch == 0 && dayStemBranch60 == 48)) {
      // 子月壬子日
      bits |= (1 << VirtualGod.de_da_hui.index);
    }
  }

  // ── 3. 长生：五行长生诀（仅寅申巳亥月有碰撞规则） ──
  // 月建  五行本气  长生位
  // 寅(2)  木       亥(11)
  // 巳(5)  火       寅(2)
  // 申(8)  金       巳(5)
  // 亥(11) 水       申(8)
  //
  // 其余月份（子午卯酉辰戌丑未）在 badGodDic 中没有长生的碰撞规则，
  // 所以即使点亮也不会被匹配到，为了极致性能直接跳过。
  const changShengMap = {
    2: 11, // 寅月 → 亥日
    5: 2, // 巳月 → 寅日
    8: 5, // 申月 → 巳日
    11: 8, // 亥月 → 申日
  };
  final csTarget = changShengMap[monthBranch];
  if (csTarget != null && dayBranch == csTarget) {
    bits |= (1 << VirtualGod.chang_sheng.index);
  }

  // ── 4. 月建（日支 == 月建支） ──
  if (dayBranch == monthBranch) {
    bits |= (1 << VirtualGod.yue_jian.index);
  }

  return bits;
}
