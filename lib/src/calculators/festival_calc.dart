import '../data/cnlunar_festivals.dart';

class FestivalCalculator {
  /// 获取给定日期的所有节日
  /// [solarMonth] (1-12)
  /// [solarDay] (1-31)
  /// [lunarMonth] (1-12)
  /// [lunarDay] (1-30)
  /// [isLeapMonth] 是否为农历闰月
  /// [isLastLunarDay] 是否是农历本月最后一天（针对除夕可能发生在大年二十九）
  /// [solarTerm] 当天的节气名称（若有）
  static List<String> getFestivals({
    required int solarMonth,
    required int solarDay,
    required int lunarMonth,
    required int lunarDay,
    required bool isLeapMonth,
    required bool isLastLunarDay,
    String? solarTerm,
  }) {
    final List<String> results = [];

    // 1. 公历固定日期节日 (legalSolarHolidays)
    final solarLegal = CnlunarFestivals.legalSolarHolidays[solarMonth]?[solarDay];
    if (solarLegal != null) {
      results.add(solarLegal);
    }

    // 2. 农历固定日期节日 (legalLunarHolidays)
    if (!isLeapMonth) {
      final lunarLegal = CnlunarFestivals.legalLunarHolidays[lunarMonth]?[lunarDay];
      if (lunarLegal != null) {
        results.add(lunarLegal);
      }
    }

    // 3. 公历其他纪念日 (otherSolarHolidays)
    if (solarMonth >= 1 && solarMonth <= 12) {
      final solarOther = CnlunarFestivals.otherSolarHolidays[solarMonth - 1][solarDay];
      if (solarOther != null) {
        // cnlunar 数据中有些节日用逗号分隔，拆分后加入
        results.addAll(solarOther.split(','));
      }
    }

    // 4. 农历其他纪念日/神佛诞辰 (otherLunarHolidays)
    if (!isLeapMonth) {
      if (lunarMonth >= 1 && lunarMonth <= 12) {
        String? lunarOther;
        
        // 特殊处理除夕：如果今天是本月最后一天且是腊月（12月），
        // 即使是 29 号（小月），也要触发原本在 30 号的“除夕”。
        if (lunarMonth == 12 && isLastLunarDay) {
          lunarOther = CnlunarFestivals.otherLunarHolidays[11][30];
        } else {
          lunarOther = CnlunarFestivals.otherLunarHolidays[lunarMonth - 1][lunarDay];
        }

        if (lunarOther != null) {
          results.addAll(lunarOther.split(','));
        }
      }
    }

    // 5. 节气节日 (solarTermHolidays)
    if (solarTerm != null) {
      final termFtv = CnlunarFestivals.solarTermHolidays[solarTerm];
      if (termFtv != null) {
        results.add(termFtv);
      }
    }

    // 去重并返回
    return results.toSet().toList();
  }
}
