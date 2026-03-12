import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

void main() {
  // 1. 设置时间与时区 (示例：2026年春节)
  final localNow = AstroDateTime(2026, 2, 17, 10, 30);
  final tp = TimePack.createBySolarTime(
    clockTime: localNow, 
    timezone: 8.0,
  );

  // 2. 初始化核心对象
  final day = HuangliDay.from(tp);

  print('========================================');
  print('        中华农历 (Chinese Almanac) Demo');
  print('========================================');

  // 时间显示
  print('本地时间 (Local): ${day.solarDate}');
  print('星期: ${["日", "一", "二", "三", "四", "五", "六"][day.weekday % 7]}');
  print('');

  // 阴历信息 (注意: lunarDate 可能是 null 或动态类型，取决于底层实现)
  final lunar = day.lunarDate;
  print('【阴历/农历】');
  if (lunar != null) {
     // 尝试打印一些基础信息，避免直接打印整个对象导致 crash
     try {
       print('农历汉字: ${lunar.fullCNString}');
     } catch (e) {
       print('农历信息: $lunar');
     }
  }
  print('月相: ${day.moonPhase ?? "未知"}');
  print('');

  // 命理干支 (八字)
  print('【命理干支 (八字门面)】');
  print('年柱: ${day.yearGanZhi} (${day.yearGanZhi.zhi.animal}年)');
  print('月柱: ${day.monthGanZhi}');
  print('日柱: ${day.ganZhi}');
  
  print('本日时辰预览:');
  final hours = day.dayHours;
  final h = localNow.hour;
  
  for (final hour in hours) {
    bool isCurrent = hour.isCurrent(h);
    final prefix = isCurrent ? ' -> ' : '    ';
    print('$prefix$hour');
  }
  print('');

  // 节气与天象
  print('【节气与天象】');
  print('当前节气: ${day.solarTerm ?? "今日无节气"}');
  if (day.solarTermTime != null) {
      print('交节时刻: ${day.solarTermTime}');
  }
  print('所属星座: ${day.constellation}');
  print('廿八星宿: ${day.star28}');
  
  // 宜忌演示 (使用封装的 Getter)
  print('');
  print('【今日宜忌预览】');
  print('宜: ${day.suitableActivities.take(5).join(", ")}...');
  print('忌: ${day.tabooActivities.take(5).join(", ")}...');

  print('\n========================================');
}
