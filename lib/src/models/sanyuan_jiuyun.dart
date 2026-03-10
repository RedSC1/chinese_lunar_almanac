enum SanYuan {
  upper('上元'),
  middle('中元'),
  lower('下元');

  final String label;
  const SanYuan(this.label);
}

enum FlyingStar {
  star1(1, '一白', '贪狼', '水', '坎'),
  star2(2, '二黑', '巨门', '土', '坤'),
  star3(3, '三碧', '禄存', '木', '震'),
  star4(4, '四绿', '文曲', '木', '巽'),
  star5(5, '五黄', '廉贞', '土', '中'),
  star6(6, '六白', '武曲', '金', '乾'),
  star7(7, '七赤', '破军', '金', '兑'),
  star8(8, '八白', '左辅', '土', '艮'),
  star9(9, '九紫', '右弼', '火', '离');

  final int number;
  final String color;
  final String name;
  final String wuxing;
  final String gua;

  const FlyingStar(this.number, this.color, this.name, this.wuxing, this.gua);

  /// 方便查阅的完整全称，比如：一白贪狼水
  String get fullName => '$color$name$wuxing';

  /// 传入 1-9 的数字，返回对应的飞星。支持超过 9 或小于 1 的自动环绕
  static FlyingStar fromNumber(int n) {
    int normalized = ((n - 1) % 9 + 9) % 9;
    return values[normalized];
  }
}
