//这个胎神方位怎么版本这么多？？？
//这里是ai给我的表，经测试跟https://51wnl.com结果是对齐的
//跟常见的lunar库不一样
//仅供参考吧
// * 组01 (停留6天)：00甲子、01乙丑、56庚申、57辛酉、58壬戌、59癸亥 -> 【外东南】
// * 组02 (停留5天)：02丙寅、03丁卯、04戊辰、05己巳、06庚午 -> 【外正南】
// * 组03 (停留7天)：07辛未、08壬申、09癸酉、10甲戌、11乙亥、12丙子、13丁丑 -> 【外西南】
// * 组04 (停留2天)：14戊寅、15己卯 -> 【外正南】 *(奇特短途回马枪)*
// * 组05 (停留2天)：16庚辰、17辛巳 -> 【外正西】 *(极短跳跃)*
// * 组06 (停留6天)：18壬午、19癸未、20甲申、21乙酉、22丙戌、23丁亥 -> 【外西北】
// * 组07 (停留5天)：24戊子、25己丑、26庚寅、27辛卯、28壬辰 -> 【外正北】
// * 组08 (房内5天)：29癸巳、30甲午、31乙未、32丙申、33丁酉 -> 【房内北】
// * 组09 (房内6天)：34戊戌、35己亥、36庚子、37辛丑、38壬寅、39癸卯 -> 【房内南】
// * 组10 (房内5天)：40甲辰、41乙巳、42丙午、43丁未、44戊申 -> 【房内东】
// * 组11 (停留6天)：45己酉、46庚戌、47辛亥、48壬子、49癸丑、50甲寅 -> 【外东北】
// * 组12 (停留5天)：51乙卯、52丙辰、53丁巳、54戊午、55己未 -> 【外正东】

import 'package:sxwnl_spa_dart/sxwnl_spa_dart.dart';
import '../models/compass_direction.dart';

/// 胎神内外位置判定
enum TaiShenLocation {
  /// 房内
  inside,

  /// 外周/房屋外部 (外)
  outside,

  /// 兜底/中宫特别标定
  center,
}

/// 胎神方位完整结果对象
class TaiShenDirection {
  /// 胎神占据的物体 (如: 房床、门、碓磨)
  final String element;

  /// 内外判定
  final TaiShenLocation location;

  /// 对应的罗盘方位
  final CompassDirection direction;

  const TaiShenDirection({
    required this.element,
    required this.location,
    required this.direction,
  });

  /// 格式化为传统黄历描述字串 (如: 房床炉外正南)
  @override
  String toString() {
    final locStr = location == TaiShenLocation.inside ? '房内' : '外';
    return '$element$locStr${direction.label}';
  }
}

/// 胎神占方推算器 (Tai Shen Calculator)
///
/// 胎神是民间信仰中守护胎儿的神明，其方位每日变化。
/// 算法基于干支双指定向法，60甲子不规则跳跃映射表。
// 经测试跟51wnl.com 结果一致
class TaiShenCalculator {
  /// 天干占位映射
  /// 使用取余运算优化 (甲与己同主位，乙与庚同位...)
  /// “甲己之日占在门，乙庚碓磨休移动。丙辛厨灶莫相干，丁壬仓库忌修弄。戊癸房床若移整，犯之孕妇堕孩童。”
  static const List<String> _ganMap = [
    '门', // 0/5: 甲/己
    '碓磨', // 1/6: 乙/庚
    '厨灶', // 2/7: 丙/辛
    '仓库', // 3/8: 丁/壬
    '房床', // 4/9: 戊/癸
  ];

  /// 地支占位映射 (子午二日碓须忌...)
  /// 使用取余运算优化 (子午相对，丑未相对...)
  /// “子午二日碓须忌，丑未厕道莫修移。寅申火炉休要动，卯酉大门修当避。辰戌鸡栖巳亥床，犯着六甲身堕胎。”
  static const List<String> _zhiMap = [
    '碓', // 0/6: 子/午
    '厕', // 1/7: 丑/未
    '炉', // 2/8: 寅/申
    '门', // 3/9: 卯/酉
    '栖', // 4/10: 辰/戌 (部分作厨/栖)
    '床', // 5/11: 巳/亥
  ];

  /// 胎神外围方位 60甲子硬编码跳跃表 (8位索引设计)
  /// 高位(十位)代表 location: 0=outside, 1=inside
  /// 低位(个位)代表 direction 的 index (0-8 对应 CompassDirection)
  ///
  /// 例如:
  /// CompassDirection 索引:
  /// 0: north, 1: northeast, 2: east, 3: southeast, 4: south
  /// 5: southwest, 6: west, 7: northwest, 8: center
  ///
  /// 值 `03` 代表: Outside (0) + Southeast (3) = 外东南
  /// 值 `10` 代表: Inside (1) + North (0) = 房内北
  static const List<int> _directionMap = [
    // 00-09: 甲子 - 癸酉
    03, 03, 04, 04, 04, 04, 04, 05, 05, 05,
    // 10-19: 甲戌 - 癸未
    05, 05, 05, 05, 04, 04, 06, 06, 07, 07,
    // 20-29: 甲申 - 癸巳
    07, 07, 07, 07, 00, 00, 00, 00, 00, 10,
    // 30-39: 甲午 - 癸卯
    10, 10, 10, 10, 14, 14, 14, 14, 14, 14,
    // 40-49: 甲辰 - 癸丑
    12, 12, 12, 12, 12, 01, 01, 01, 01, 01,
    // 50-59: 甲寅 - 癸亥
    01, 02, 02, 02, 02, 02, 03, 03, 03, 03,
  ];

  /// 获取某一日的胎神方位
  static TaiShenDirection getDirection(GanZhi dailyGanZhi) {
    // 1. 解析天干物与地支物
    final ganItem = _ganMap[dailyGanZhi.gan.index % 5];
    final zhiItem = _zhiMap[dailyGanZhi.zhi.index % 6];

    // 去重拼接逻辑
    String element = ganItem;
    if (!ganItem.contains(zhiItem)) {
      element += zhiItem;
    }

    // 2. O(1) 查表获取方位
    final code = _directionMap[dailyGanZhi.index];
    final location = (code ~/ 10) == 1
        ? TaiShenLocation.inside
        : TaiShenLocation.outside;
    final direction = CompassDirection.values[code % 10];

    return TaiShenDirection(
      element: element,
      location: location,
      direction: direction,
    );
  }
}
