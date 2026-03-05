import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 针对历法展示的扩展
extension DiZhiAnimalExt on DiZhi {
  /// 获取地支对应的生肖
  String get animal {
    const animals = [
      '鼠',
      '牛',
      '虎',
      '兔',
      '龙',
      '蛇',
      '马',
      '羊',
      '猴',
      '鸡',
      '狗',
      '猪',
    ];
    return animals[index];
  }
}
