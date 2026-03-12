import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../lib/src/models/huangli_day.dart';
import '../lib/src/data/activities.dart';

void main() {
  // 1. 初始化数据
  final testTime = AstroDateTime(2026, 3, 11, 22, 54, 48);
  final tp = TimePack.createBySolarTime(clockTime: testTime, timezone: 8.0);
  final day = HuangliDay.from(tp);

  print('=== 农历演示 Demo ===\n');

  // 2. 基础信息访问
  print('【基础日期】');
  print('公历: ${day.solarDate.year}年${day.solarDate.month}月${day.solarDate.day}日');
  print('农历: ${day.lunarDate}');
  print('干支: ${day.yearGanZhi}年 ${day.monthGanZhi}月 ${day.ganZhi}日');
  print('');

  // 3. 展现层分离：如何优雅地处理“难绷”的宜忌
  print('【宜忌展现 - 两种模式】');
  
  // 模式 A：全量模式（适合专业研究）
  print('--- 专业全量版 ---');
  print('宜: ${day.suitableActivities.join(", ")}');
  print('忌: ${day.tabooActivities.join(", ")}');
  
  // 模式 B：生活精简模式 (通过 Mask 过滤)
  print('\n--- 现代生活精简版 (精简 70% 杂项) ---');
  final cleanSuitable = day.yiJi.getSuitableLabels(mask: AlmanacActivity.civilian37);
  final cleanTaboo = day.yiJi.getTabooLabels(mask: AlmanacActivity.civilian37);
  print('宜: ${cleanSuitable.join(", ")}');
  print('忌: ${cleanTaboo.join(", ")}');
  print('');

  // 4. 语义化访问 (前端最爱)
  print('【语义化 - 前端逻辑判断】');
  final enums = day.yiJi.getSuitableEnums();
  if (enums.contains(AlmanacActivity.jia_qu)) {
    print('💡 逻辑触发：今天是个好日子，适合【嫁娶】，UI 可以显示心形图标!');
  }
  
  // 5. 神煞展现
  print('\n【神煞方位】');
  day.godDirections.forEach((key, value) {
    print('$key: ${value.label}');
  });

  print('\n【吉神/凶神 (过滤示例)】');
  // 只显示现代人比较熟悉的吉神
  final myInterests = day.shenSha.getAuspiciousGodsLabels();
  print('今日吉神: ${myInterests.take(5).join(" ")} ...等共 ${myInterests.length} 位');

  print('\n=== Demo 演示完毕 ===');
}
