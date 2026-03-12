import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 黄历计算中的通用时间修正工具
class TimeUtils {
  /// 将原始儒略日 (JD) 映射为唯一的整数天索引
  ///
  /// 该方法假定 JD 已经是该日历天（干支日）内的某个时刻。
  /// 它仅仅执行"JD 对齐到北京时间子夜并截断"的数学操作。
  static int jdToFixedIndex(double jd) {
    // 算法逻辑：JD + 0.5 将 12:00 起点拨至 00:00，再减去一个微小的 epsilon 防抖
    return (jd + 0.5 - 1e-11).floor();
  }

  /// 获取 AstroDateTime 对应的干支日整数索引
  ///
  /// [isSpiltRatHour] 为 false 时，23:00 会被视为下一天。
  static int getFixedJdDaySafe(AstroDateTime time, bool isSpiltRatHour) {
    AstroDateTime effectiveTime = time;
    if (!isSpiltRatHour && time.hour >= 23) {
      effectiveTime = time.add(const Duration(hours: 1));
    }
    return jdToFixedIndex(effectiveTime.toJ2000());
  }

  /// 投射北京时间的物理瞬间 (如节气) 到用户本地的【命理日索引】
  ///
  /// 用于处理"某刻的节气，在用户当地到底属于干支的哪一天"
  /// [bjJd]      天文学事件的精确北京时间 JD
  /// [timePack]  包含用户时区和早晚子时配置的容器
  static int getLocalMetaDayIdx(double bjJd, TimePack timePack) {
    // 1. 转成 UTC
    final utcJd = bjJd - 8.0 / 24.0;
    // 2. 转成用户本地钟表时间的 JD
    final localJd = utcJd + timePack.timezone / 24.0;
    // 3. 应用子时换日规则
    double metaJd = localJd;
    // 提取本地小时数 (JD 的小数部分 + 0.5 即为 0点起到现在的比例)
    final double hourFraction = (localJd + 0.5) - (localJd + 0.5).floorToDouble();
    final double localHour = hourFraction * 24.0;
    
    if (!timePack.splitRatHour && localHour >= 23.0) {
      metaJd += 1.0 / 24.0; // 加一小时进入新的一天
    }
    
    return jdToFixedIndex(metaJd);
  }
}

/// TimePack 命理锚点时间扩展
extension TimePackMeta on TimePack {
  /// 命理排盘锚点时间 (Meta Time)
  ///
  /// 在 [virtualTime]（真太阳时或钟表时间）的基础上，应用子时换日规则：
  /// - [splitRatHour] = false（默认）：23:00 起视为命理上的下一天，自动 +1小时。
  /// - [splitRatHour] = true（早晚子时派）：23:00 仍属今天晚子时，不做调整。
  ///
  /// 用途：节气月柱判断、廿八宿、日柱等所有"命理时间"相关的计算，应统一使用此字段。
  AstroDateTime get metaTime {
    if (!splitRatHour && virtualTime.hour >= 23) {
      return virtualTime.add(const Duration(hours: 1));
    }
    return virtualTime;
  }
}
