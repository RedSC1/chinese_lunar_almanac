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
  print('        Chinese Almanac Demo');
  print('========================================');

  // 时间显示
  print('本地时间 (Local): ${day.solarDate}');
  print('星期: ${["日", "一", "二", "三", "四", "五", "六"][day.weekday % 7]}');
  print('');

  // 阴历信息
  final lunar = day.lunarDate;
  print('【阴历/农历】');
  if (lunar != null) {
     try {
       print('农历汉字: ${lunar.fullCNString}');
     } catch (e) {
       print('农历信息: $lunar');
     }
  }
  print('月相: ${day.moonPhase ?? "未知"}');
  print('');

  // 命理干支 (八字) 与 纳音五行
  print('【命理干支 (八字门面) & 纳音五行】');
  print('年柱: ${day.yearGanZhi} [${day.yearGanZhi.naYin}] (${day.yearGanZhi.zhi.animal}年)');
  print('月柱: ${day.monthGanZhi} [${day.monthGanZhi.naYin}]');
  print('日柱: ${day.ganZhi} [${day.ganZhi.naYin}] (${day.ganZhi.naYinWuXing}命)');
  
  print('');
  print('【日级神煞 (黄黑道)】');
  final dayGod = day.shenSha.dayTwelveGod;
  print('当日值神: ${dayGod.name} (${dayGod.isHuangDao ? "黄道吉日" : "黑道凶日"})');
  print('建除十二神: ${day.shenSha.jianChu.name}');
  
  print('');
  print('【本日时辰详细预览 (含黄道吉时)】');
  final hours = day.dayHours;
  final currentHourIdx = (localNow.hour + 1) ~/ 2 % 12;
  
  for (int i = 0; i < hours.length; i++) {
    final hour = hours[i];
    final isCurrent = i == currentHourIdx;
    final prefix = isCurrent ? ' -> ' : '    ';
    
    // 展示时辰干支、纳音、黄黑道神煞
    final hourInfo = [
      '$prefix${hour.zhiName}时(${hour.name})',
      '[${hour.naYin}]',
      '${hour.godName}(${hour.isHuangDao ? "吉" : "---"})',
      hour.timeRange,
    ].join(' ');
    
    print(hourInfo);
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
