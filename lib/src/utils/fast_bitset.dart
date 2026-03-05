import 'dart:collection';

/// 动态扩展的位向量（BitSet）
///
/// 考虑到 Dart 编译到 Web(JS) 时，位运算被限制在 32 位有符号整数，
/// 我们统一使用 32-bit 为一个 Chunk，确保在所有平台（App、Web、Server）表现完全一致且绝对安全。
///
/// 继承自 `IterableMixin<int>`，支持直接被迭代（只 yield 被点亮的位的 index）。
class FastBitSet extends Object with IterableMixin<int> {
  static const int _bitsPerChunk = 32;

  // 存储位数据的底层数组
  final List<int> _chunks;

  // 记录初始化时申请的最大位容量
  final int _bitCapacity;

  /// 初始化一个能够存储 [bitLength] 个标志位的位向量。
  FastBitSet(int bitLength)
    : _bitCapacity = bitLength,
      _chunks = List<int>.filled(
        (bitLength + _bitsPerChunk - 1) ~/ _bitsPerChunk,
        0,
      );

  /// 位向量的最大支持长度容量
  int get bitCapacity => _bitCapacity;

  /// 从现有的位向量克隆（深拷贝）
  FastBitSet.clone(FastBitSet other)
    : _bitCapacity = other._bitCapacity,
      _chunks = List<int>.from(other._chunks);

  /// 从一个给定的索引列表，直接一键点亮位图！
  /// 示例: `var mask = FastBitSet.fromIndices(130, [Taboo.jiSi.index, Taboo.qiFu.index]);`
  factory FastBitSet.fromIndices(int bitLength, Iterable<int> activeIndices) {
    var bitSet = FastBitSet(bitLength);
    for (var index in activeIndices) {
      bitSet[index] = true;
    }
    return bitSet;
  }

  /// 添加（点亮）某个索引的标志位 -> 对应 O(1) 的 `|` 运算
  void add(int index) {
    if (index < 0) return;
    final chunkIndex = index ~/ _bitsPerChunk;
    final bitOffset = index % _bitsPerChunk;
    if (chunkIndex < _chunks.length) {
      _chunks[chunkIndex] |= (1 << bitOffset);
    }
  }

  /// 支持像数组一样针对某一位进行赋值
  /// 示例：`bitSet[42] = true;` 或 `bitSet[42] = false;`
  void operator []=(int index, bool value) {
    if (value) {
      add(index);
    } else {
      remove(index);
    }
  }

  /// 移除（熄灭）某个索引的标志位 -> 对应 O(1) 的 `& ~` 运算
  void remove(int index) {
    if (index < 0) return;
    final chunkIndex = index ~/ _bitsPerChunk;
    final bitOffset = index % _bitsPerChunk;
    if (chunkIndex < _chunks.length) {
      _chunks[chunkIndex] &= ~(1 << bitOffset);
    }
  }

  /// 检查某个索引是否已被点亮 -> 对应 O(1) 的 `&` 运算
  bool has(int index) {
    if (index < 0) return false;
    final chunkIndex = index ~/ _bitsPerChunk;
    final bitOffset = index % _bitsPerChunk;
    if (chunkIndex < _chunks.length) {
      return (_chunks[chunkIndex] & (1 << bitOffset)) != 0;
    }
    return false;
  }

  /// 支持像数组一样读取某一位的值
  /// 示例：`bool isGood = bitSet[42];`
  bool operator [](int index) {
    return has(index);
  }

  // ------------------------------------------------------------------------
  // 运算符重载
  // ------------------------------------------------------------------------

  /// 并集运算 (相当于 merge)。示例： `setC = setA | setB`
  FastBitSet operator |(FastBitSet other) {
    var result = FastBitSet.clone(this);
    for (int i = 0; i < result._chunks.length; i++) {
      if (i < other._chunks.length) {
        result._chunks[i] |= other._chunks[i];
      }
    }
    return result;
  }

  /// 交集运算。示例： `setC = setA & setB`
  FastBitSet operator &(FastBitSet other) {
    var result = FastBitSet.clone(this);
    for (int i = 0; i < result._chunks.length; i++) {
      if (i < other._chunks.length) {
        result._chunks[i] &= other._chunks[i];
      } else {
        result._chunks[i] = 0; // other 里没有的位，交集必须是 0
      }
    }
    return result;
  }

  /// 差集运算 / 剔除操作 (相当于 oppress)。示例： `setA = setA - setB` (从A中减去B)
  FastBitSet operator -(FastBitSet other) {
    var result = FastBitSet.clone(this);
    for (int i = 0; i < result._chunks.length; i++) {
      if (i < other._chunks.length) {
        result._chunks[i] &= ~other._chunks[i];
      }
    }
    return result;
  }

  /// 异或运算 (XOR)。示例： `setC = setA ^ setB` (两者有且只有一个被点亮的位)
  FastBitSet operator ^(FastBitSet other) {
    var result = FastBitSet.clone(this);
    for (int i = 0; i < result._chunks.length; i++) {
      if (i < other._chunks.length) {
        result._chunks[i] ^= other._chunks[i];
      }
    }
    return result;
  }

  /// 翻转所有位 (取反) -> 得到一个从0到最高位满状态取反的结果
  FastBitSet operator ~() {
    var result = FastBitSet.clone(this);
    for (int i = 0; i < result._chunks.length; i++) {
      result._chunks[i] = ~result._chunks[i];
    }
    return result;
  }

  /// 等同于 | 运算
  FastBitSet operator +(FastBitSet other) => this | other;

  // ------------------------------------------------------------------------

  /// 批量覆写操作（从集合中剔除 other 中的位）
  /// 将 [other] 中拥有的标志位，从当前集合中强制移除 (原地修改)。
  void oppress(FastBitSet other) {
    for (int i = 0; i < _chunks.length; i++) {
      if (i < other._chunks.length) {
        _chunks[i] &= ~other._chunks[i];
      }
    }
  }

  /// 批量合并（并集）
  /// 将 [other] 中的所有位叠加到当前集合中。
  void merge(FastBitSet other) {
    for (int i = 0; i < _chunks.length; i++) {
      if (i < other._chunks.length) {
        _chunks[i] |= other._chunks[i];
      }
    }
  }

  /// 清空所有状态
  void clear() {
    for (int i = 0; i < _chunks.length; i++) {
      _chunks[i] = 0;
    }
  }

  // ------------------------------------------------------------------------
  // Iterable 接口实现，使得 FastBitSet 可以像 List 一样被遍历
  // ------------------------------------------------------------------------

  @override
  Iterator<int> get iterator => _activeIndices().iterator;

  /// 极速生成器：按序吐出所有被点亮的索引值
  /// 优化：直接扫描整个 32-bit 内存块，如果整块为 0 则瞬间跳过 32 个检查点！
  Iterable<int> _activeIndices() sync* {
    for (int i = 0; i < _chunks.length; i++) {
      int chunk = _chunks[i];
      if (chunk == 0) continue; // 🚀 关键性能飞跃：如果这 32 位全是 0，瞬间跳过！

      // 只有这一块有数据，才进去细查
      for (int bit = 0; bit < _bitsPerChunk; bit++) {
        // 防止最后一块的溢出（因为按 chunk 分配的内存可能大于 bitCapacity）
        int absoluteIndex = (i * _bitsPerChunk) + bit;
        if (absoluteIndex >= _bitCapacity) break;

        if ((chunk & (1 << bit)) != 0) {
          yield absoluteIndex;
        }
      }
    }
  }
}
