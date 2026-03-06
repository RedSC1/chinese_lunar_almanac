/// 罗盘方位枚举 (Compass Directions)
///
/// 用于统一表达黄历系统中所有的方位判定
/// 包括：吉神方位 (财神、福神等) 和 胎神方位 (外围方位)
enum CompassDirection {
  /// 北
  north,

  /// 东北
  northeast,

  /// 东
  east,

  /// 东南
  southeast,

  /// 南
  south,

  /// 西南
  southwest,

  /// 西
  west,

  /// 西北
  northwest,

  /// 中 (主要用于胎神房内中央，或特殊中宫判定)
  center;

  /// 获取对应的中文方位描述 (如：正北、东南)
  String get label {
    switch (this) {
      case CompassDirection.north:
        return '正北';
      case CompassDirection.northeast:
        return '东北';
      case CompassDirection.east:
        return '正东';
      case CompassDirection.southeast:
        return '东南';
      case CompassDirection.south:
        return '正南';
      case CompassDirection.southwest:
        return '西南';
      case CompassDirection.west:
        return '正西';
      case CompassDirection.northwest:
        return '西北';
      case CompassDirection.center:
        return '中';
    }
  }

  /// 对应的后天八卦名 (如：坎、艮)
  String get bagua {
    switch (this) {
      case CompassDirection.north:
        return '坎';
      case CompassDirection.northeast:
        return '艮';
      case CompassDirection.east:
        return '震';
      case CompassDirection.southeast:
        return '巽';
      case CompassDirection.south:
        return '离';
      case CompassDirection.southwest:
        return '坤';
      case CompassDirection.west:
        return '兑';
      case CompassDirection.northwest:
        return '乾';
      case CompassDirection.center:
        return '中宫';
    }
  }

  @override
  String toString() => label;
}
