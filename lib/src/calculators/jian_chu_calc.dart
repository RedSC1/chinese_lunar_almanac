import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';

/// 十二建除 (Jian Chu / Twelve Gods) 实体类
///
/// 建筑术数学中的“十二值日”，根据月建（月地支）与当日地支的位移关系得出。
// 这里不写吉凶了，因为这个吉凶是条件触发
class JianChu {
  /// 索引 (0-11, 对应 建、除、满、平、定、执、破、危、成、收、开、闭)
  final int index;

  /// 名称 (建、除、满、平、定、执、破、危、成、收、开、闭)
  final String name;

  /// 是否为黄道吉日 (true: 黄道, false: 黑道)
  final bool isHuangDao;

  const JianChu({
    required this.index,
    required this.name,
    required this.isHuangDao,
  });

  @override
  String toString() => '$name (${isHuangDao ? "黄道" : "黑道"})';

  // ==========================================
  // 【全局常量池】
  // ==========================================

  /// 十二建除口诀：建满平收黑，除定执危开成黄
  static const List<JianChu> values = [
    JianChu(index: 0, name: '建', isHuangDao: false),
    JianChu(index: 1, name: '除', isHuangDao: true),
    JianChu(index: 2, name: '满', isHuangDao: false),
    JianChu(index: 3, name: '平', isHuangDao: false),
    JianChu(index: 4, name: '定', isHuangDao: true),
    JianChu(index: 5, name: '执', isHuangDao: true),
    JianChu(index: 6, name: '破', isHuangDao: false),
    JianChu(index: 7, name: '危', isHuangDao: true),
    JianChu(index: 8, name: '成', isHuangDao: true),
    JianChu(index: 9, name: '收', isHuangDao: false),
    JianChu(index: 10, name: '开', isHuangDao: true),
    JianChu(index: 11, name: '闭', isHuangDao: false),
  ];

  // ==========================================
  // 【核心计算逻辑】
  // ==========================================

  /// 根据月地支与日地支计算当天的建除十二神
  ///
  /// 逻辑：以月建为起点（建），顺推。
  /// [monthZhi] 月地支 (交节后的月建)
  /// [dayZhi] 日地支
  static JianChu calculate(DiZhi monthZhi, DiZhi dayZhi) {
    // 偏移量 = (日支索引 - 月支索引 + 12) % 12
    final index = (dayZhi.index - monthZhi.index + 12) % 12;
    return values[index];
  }
}
