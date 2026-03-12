import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 黄历时辰实体类 (HuangliHour)
///
/// 封装了传统的十二时辰信息，包括干支、时间跨度、以及便利的显示字段。
class HuangliHour {
  /// 时辰的干支
  final GanZhi ganZhi;

  /// 时辰的索引 (0: 子时, 1: 丑时 ... 11: 亥时)
  final int index;

  HuangliHour({required this.ganZhi, required this.index});

  /// 时辰名称，例如 '庚子'
  String get name => '${ganZhi.gan.label}${ganZhi.zhi.label}';

  /// 时辰的地支名，例如 '子'
  String get zhiName => ganZhi.zhi.label;

  String get naYin => ganZhi.naYin;
  String get naYinWuXing => ganZhi.naYinWuXing;

  /// 起始小时 (0-23)
  ///
  /// 注意：子时跨日，从前一晚 23:00 开始。
  int get startHour => (index * 2 - 1 + 24) % 24;

  /// 结束小时 (0-23)
  int get endHour => (index * 2 + 1) % 24;

  /// 格式化时间跨度，例如 '23:00 - 01:00'
  String get timeRange =>
      '${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00';

  /// 判断给定的小时是否属于当前时辰
  ///
  /// [currentHour] 为当地钟表时间的 24 小时制数字 (0-23)
  bool isCurrent(int currentHour) {
    if (index == 0) {
      // 子时跨日特殊处理
      return currentHour >= 23 || currentHour < 1;
    }
    return currentHour >= startHour && currentHour < endHour;
  }

  @override
  String toString() {
    return '$zhiName时($name) $timeRange';
  }
}
