// 这个类有很多字符串属性，其实我是很不喜欢字符串操作
// 但是也没啥好办法不是？

/// 二十八星宿 (Lunar Mansion) 实体类
///
/// 作为一个不可变的值对象 (Value Object)，存储星宿的固有天文学与术数学属性。
///
class LunarMansion {
  /// 星宿名 (如: 角, 亢, 氐, 房...)
  final String name;

  /// 对应的七政星体 (日、月、金、木、水、火、土)
  final String planet;

  /// 对应的动物图腾 (如: 蛟、龙、貉、兔...)
  final String animal;

  /// 对应的四象方位 (东方青龙、北方玄武、西方白虎、南方朱雀)
  final String direction;

  /// 固有吉凶属性 (true: 吉, false: 凶)
  final bool isGood;

  /// 常量构造函数，保证全局星宿对象的唯一性和内存复用
  const LunarMansion({
    required this.name,
    required this.planet,
    required this.animal,
    required this.direction,
    required this.isGood,
  });

  /// 获取星宿全称 (如: 角木蛟)
  String get fullName => '$name$planet$animal';

  @override
  String toString() => '$fullName ($direction) - ${isGood ? "吉" : "凶"}';

  // ==========================================
  // 【全局常量池】
  // ==========================================

  /// 二十八星宿按标准排序的全局常量列表 (角亢氐房心尾箕...)
  static const List<LunarMansion> mansions = [
    // 东方青龙 (木金土日月火水)
    LunarMansion(
      name: '角',
      planet: '木',
      animal: '蛟',
      direction: '东方青龙',
      isGood: true,
    ),
    LunarMansion(
      name: '亢',
      planet: '金',
      animal: '龙',
      direction: '东方青龙',
      isGood: false,
    ),
    LunarMansion(
      name: '氐',
      planet: '土',
      animal: '貉',
      direction: '东方青龙',
      isGood: false,
    ),
    LunarMansion(
      name: '房',
      planet: '日',
      animal: '兔',
      direction: '东方青龙',
      isGood: true,
    ),
    LunarMansion(
      name: '心',
      planet: '月',
      animal: '狐',
      direction: '东方青龙',
      isGood: false,
    ),
    LunarMansion(
      name: '尾',
      planet: '火',
      animal: '虎',
      direction: '东方青龙',
      isGood: true,
    ),
    LunarMansion(
      name: '箕',
      planet: '水',
      animal: '豹',
      direction: '东方青龙',
      isGood: true,
    ),

    // 北方玄武
    LunarMansion(
      name: '斗',
      planet: '木',
      animal: '獬',
      direction: '北方玄武',
      isGood: true,
    ),
    LunarMansion(
      name: '牛',
      planet: '金',
      animal: '牛',
      direction: '北方玄武',
      isGood: false,
    ),
    LunarMansion(
      name: '女',
      planet: '土',
      animal: '蝠',
      direction: '北方玄武',
      isGood: false,
    ),
    LunarMansion(
      name: '虚',
      planet: '日',
      animal: '鼠',
      direction: '北方玄武',
      isGood: false,
    ),
    LunarMansion(
      name: '危',
      planet: '月',
      animal: '燕',
      direction: '北方玄武',
      isGood: false,
    ),
    LunarMansion(
      name: '室',
      planet: '火',
      animal: '猪',
      direction: '北方玄武',
      isGood: true,
    ),
    LunarMansion(
      name: '壁',
      planet: '水',
      animal: '㺄',
      direction: '北方玄武',
      isGood: true,
    ),

    // 西方白虎
    LunarMansion(
      name: '奎',
      planet: '木',
      animal: '狼',
      direction: '西方白虎',
      isGood: false,
    ),
    LunarMansion(
      name: '娄',
      planet: '金',
      animal: '狗',
      direction: '西方白虎',
      isGood: true,
    ),
    LunarMansion(
      name: '胃',
      planet: '土',
      animal: '雉',
      direction: '西方白虎',
      isGood: true,
    ),
    LunarMansion(
      name: '昴',
      planet: '日',
      animal: '鸡',
      direction: '西方白虎',
      isGood: false,
    ),
    LunarMansion(
      name: '毕',
      planet: '月',
      animal: '乌',
      direction: '西方白虎',
      isGood: true,
    ),
    LunarMansion(
      name: '觜',
      planet: '火',
      animal: '猴',
      direction: '西方白虎',
      isGood: false,
    ),
    LunarMansion(
      name: '参',
      planet: '水',
      animal: '猿',
      direction: '西方白虎',
      isGood: true,
    ),

    // 南方朱雀
    LunarMansion(
      name: '井',
      planet: '木',
      animal: '犴',
      direction: '南方朱雀',
      isGood: true,
    ),
    LunarMansion(
      name: '鬼',
      planet: '金',
      animal: '羊',
      direction: '南方朱雀',
      isGood: false,
    ),
    LunarMansion(
      name: '柳',
      planet: '土',
      animal: '獐',
      direction: '南方朱雀',
      isGood: false,
    ),
    LunarMansion(
      name: '星',
      planet: '日',
      animal: '马',
      direction: '南方朱雀',
      isGood: false,
    ),
    LunarMansion(
      name: '张',
      planet: '月',
      animal: '鹿',
      direction: '南方朱雀',
      isGood: true,
    ),
    LunarMansion(
      name: '翼',
      planet: '火',
      animal: '蛇',
      direction: '南方朱雀',
      isGood: false,
    ),
    LunarMansion(
      name: '轸',
      planet: '水',
      animal: '蚓',
      direction: '南方朱雀',
      isGood: true,
    ),
  ];

  // ==========================================
  // 【计算方法】
  // ==========================================

  /// 根据儒略日 (J2000 起点) 计算当天的二十八星宿
  ///
  /// 以2000年1月1日 己卯年(还没到立春) 丙子月 戊午日 周六 胃宿（胃土雉）作为基准
  ///
  /// 这里是0：00换日，如果要实现子时换日，请自行传入假时间
  // 应该不会有商业软件故意算错这一天不让别人写竞品吧？哈哈
  static LunarMansion calculateFromJulianDay(double jD2000) {
    int dtd = (jD2000 + 0.5).floor();
    return _calculateFromJulianDay(dtd);
  }

  static LunarMansion _calculateFromJulianDay(int daysSinceJ2000) {
    final weiIndex = 16;
    final index = ((weiIndex + daysSinceJ2000) % 28 + 28) % 28;
    return mansions[index];
  }
}
