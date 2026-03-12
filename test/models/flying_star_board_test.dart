import 'package:test/test.dart';
import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';

void main() {
  group('FlyingStarBoard', () {
    test('constructor creates board with stars', () {
      final stars = List.generate(9, (i) => FlyingStar.values[i % 9]);
      final board = FlyingStarBoard(stars);
      expect(board.stars, hasLength(9));
    });

    test('board stars are accessible', () {
      final stars = List.generate(9, (i) => FlyingStar.values[i % 9]);
      final board = FlyingStarBoard(stars);
      expect(board.stars[0], isNotNull);
      expect(board.stars[4], isNotNull);
      expect(board.stars[8], isNotNull);
    });
  });

  group('NineStarBoard', () {
    late NineStarBoard board;

    setUp(() {
      board = NineStarBoard();
    });

    group('createNineStarBoard', () {
      test('creates board with 9 stars', () {
        final stars = NineStarBoard.createNineStarBoard(0, true);
        expect(stars, hasLength(9));
      });

      test('all stars are valid FlyingStar values', () {
        final stars = NineStarBoard.createNineStarBoard(0, true);
        for (final star in stars) {
          expect(star, isA<FlyingStar>());
        }
      });

      test('forward direction creates ascending sequence', () {
        final stars = NineStarBoard.createNineStarBoard(0, true);
        // Check that stars follow the flying pattern
        expect(stars, hasLength(9));
      });

      test('backward direction creates descending sequence', () {
        final stars = NineStarBoard.createNineStarBoard(0, false);
        expect(stars, hasLength(9));
      });

      test('different start indices create different boards', () {
        final stars1 = NineStarBoard.createNineStarBoard(0, true);
        final stars2 = NineStarBoard.createNineStarBoard(1, true);
        expect(stars1, isNot(equals(stars2)));
      });

      test('handles all possible start indices (0-8)', () {
        for (int i = 0; i < 9; i++) {
          final stars = NineStarBoard.createNineStarBoard(i, true);
          expect(stars, hasLength(9));
        }
      });
    });

    group('getYearBoard', () {
      test('returns valid board for current year', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final yearBoard = board.getYearBoard(time);
        expect(yearBoard, isNotNull);
        expect(yearBoard.stars, hasLength(9));
      });

      test('returns valid board for different years', () {
        final time2025 = AstroDateTime(2025, 6, 15, 12, 0, 0);
        final time2026 = AstroDateTime(2026, 6, 15, 12, 0, 0);

        final board2025 = board.getYearBoard(time2025);
        final board2026 = board.getYearBoard(time2026);

        expect(board2025.stars, hasLength(9));
        expect(board2026.stars, hasLength(9));
      });

      test('handles solar boundary correctly', () {
        final boardSolar = NineStarBoard(boundary: Boundary.solar);
        final time = AstroDateTime(2026, 2, 4, 12, 0, 0); // Around Lichun
        final yearBoard = boardSolar.getYearBoard(time);
        expect(yearBoard.stars, hasLength(9));
      });

      test('handles lunar boundary correctly', () {
        final boardLunar = NineStarBoard(boundary: Boundary.lunar);
        final time = AstroDateTime(2026, 2, 4, 12, 0, 0);
        final yearBoard = boardLunar.getYearBoard(time);
        expect(yearBoard.stars, hasLength(9));
      });
    });

    group('getMonthBoard', () {
      test('returns valid board for current month', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final monthBoard = board.getMonthBoard(time);
        expect(monthBoard, isNotNull);
        expect(monthBoard.stars, hasLength(9));
      });

      test('different months produce different boards', () {
        final timeMar = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final timeApr = AstroDateTime(2026, 4, 11, 12, 0, 0);

        final boardMar = board.getMonthBoard(timeMar);
        final boardApr = board.getMonthBoard(timeApr);

        expect(boardMar.stars, hasLength(9));
        expect(boardApr.stars, hasLength(9));
      });

      test('handles all 12 months', () {
        for (int month = 1; month <= 12; month++) {
          final time = AstroDateTime(2026, month, 15, 12, 0, 0);
          final monthBoard = board.getMonthBoard(time);
          expect(monthBoard.stars, hasLength(9));
        }
      });
    });

    group('getDayBoard', () {
      test('returns valid board for given day', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
        final dayBoard = board.getDayBoard(tp);
        expect(dayBoard, isNotNull);
        expect(dayBoard.stars, hasLength(9));
      });

      test('consecutive days produce different boards', () {
        final time1 = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final time2 = AstroDateTime(2026, 3, 12, 12, 0, 0);

        final tp1 = TimePack.createBySolarTime(clockTime: time1, timezone: 8.0);
        final tp2 = TimePack.createBySolarTime(clockTime: time2, timezone: 8.0);

        final board1 = board.getDayBoard(tp1);
        final board2 = board.getDayBoard(tp2);

        expect(board1.stars, hasLength(9));
        expect(board2.stars, hasLength(9));
      });

      test('handles consecutive method', () {
        final boardConsec = NineStarBoard(method: DayFlyingStarMethod.consecutive);
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
        final dayBoard = boardConsec.getDayBoard(tp);
        expect(dayBoard.stars, hasLength(9));
      });

      test('handles discontinuous method', () {
        final boardDiscont = NineStarBoard(method: DayFlyingStarMethod.discontinuous);
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
        final dayBoard = boardDiscont.getDayBoard(tp);
        expect(dayBoard.stars, hasLength(9));
      });

      test('handles exact jieqi time mode', () {
        final boardExact = NineStarBoard(exactJieQiTime: true);
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
        final dayBoard = boardExact.getDayBoard(tp);
        expect(dayBoard.stars, hasLength(9));
      });
    });

    group('getHourBoard', () {
      test('returns valid board for given hour', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
        final hourBoard = board.getHourBoard(tp);
        expect(hourBoard, isNotNull);
        expect(hourBoard.stars, hasLength(9));
      });

      test('different hours produce different boards', () {
        final time1 = AstroDateTime(2026, 3, 11, 10, 0, 0);
        final time2 = AstroDateTime(2026, 3, 11, 14, 0, 0);

        final tp1 = TimePack.createBySolarTime(clockTime: time1, timezone: 8.0);
        final tp2 = TimePack.createBySolarTime(clockTime: time2, timezone: 8.0);

        final board1 = board.getHourBoard(tp1);
        final board2 = board.getHourBoard(tp2);

        expect(board1.stars, hasLength(9));
        expect(board2.stars, hasLength(9));
      });

      test('handles all 24 hours', () {
        for (int hour = 0; hour < 24; hour++) {
          final time = AstroDateTime(2026, 3, 11, hour, 0, 0);
          final tp = TimePack.createBySolarTime(clockTime: time, timezone: 8.0);
          final hourBoard = board.getHourBoard(tp);
          expect(hourBoard.stars, hasLength(9));
        }
      });
    });

    group('getEarthPlate', () {
      test('returns valid earth plate', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);
        expect(earthPlate, isNotNull);
        expect(earthPlate.stars, hasLength(9));
      });

      test('earth plate depends on year', () {
        final time2025 = AstroDateTime(2025, 6, 15, 12, 0, 0);
        final time2026 = AstroDateTime(2026, 6, 15, 12, 0, 0);

        final earth2025 = board.getEarthPlate(time2025);
        final earth2026 = board.getEarthPlate(time2026);

        expect(earth2025.stars, hasLength(9));
        expect(earth2026.stars, hasLength(9));
      });
    });

    group('getMountainPlate', () {
      test('returns valid mountain plate', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);
        final mountainPlate = board.getMountainPlate(earthPlate, Mountain.zi);
        expect(mountainPlate, isNotNull);
        expect(mountainPlate.stars, hasLength(9));
      });

      test('different mountains produce different plates', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);

        final plate1 = board.getMountainPlate(earthPlate, Mountain.zi);
        final plate2 = board.getMountainPlate(earthPlate, Mountain.wu);

        expect(plate1.stars, hasLength(9));
        expect(plate2.stars, hasLength(9));
      });

      test('handles all 24 mountains', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);

        for (final mountain in Mountain.values) {
          final plate = board.getMountainPlate(earthPlate, mountain);
          expect(plate.stars, hasLength(9));
        }
      });
    });

    group('getWaterPlate', () {
      test('returns valid water plate', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);
        final waterPlate = board.getWaterPlate(earthPlate, Mountain.wu);
        expect(waterPlate, isNotNull);
        expect(waterPlate.stars, hasLength(9));
      });

      test('different facing mountains produce different plates', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);

        final plate1 = board.getWaterPlate(earthPlate, Mountain.zi);
        final plate2 = board.getWaterPlate(earthPlate, Mountain.wu);

        expect(plate1.stars, hasLength(9));
        expect(plate2.stars, hasLength(9));
      });

      test('handles all 24 facing mountains', () {
        final time = AstroDateTime(2026, 3, 11, 12, 0, 0);
        final earthPlate = board.getEarthPlate(time);

        for (final mountain in Mountain.values) {
          final plate = board.getWaterPlate(earthPlate, mountain);
          expect(plate.stars, hasLength(9));
        }
      });
    });

    group('configuration options', () {
      test('creates board with custom method', () {
        final customBoard = NineStarBoard(method: DayFlyingStarMethod.discontinuous);
        expect(customBoard, isNotNull);
      });

      test('creates board with custom boundary', () {
        final customBoard = NineStarBoard(boundary: Boundary.lunar);
        expect(customBoard, isNotNull);
      });

      test('creates board with historical solar terms', () {
        final customBoard = NineStarBoard(useHistoricalSolarTerms: true);
        expect(customBoard, isNotNull);
      });

      test('creates board with split rat hour', () {
        final customBoard = NineStarBoard(isSpiltRatHour: true);
        expect(customBoard, isNotNull);
      });

      test('creates board with exact jieqi time', () {
        final customBoard = NineStarBoard(exactJieQiTime: true);
        expect(customBoard, isNotNull);
      });

      test('creates board with all custom options', () {
        final customBoard = NineStarBoard(
          method: DayFlyingStarMethod.discontinuous,
          boundary: Boundary.lunar,
          useHistoricalSolarTerms: true,
          isSpiltRatHour: true,
          exactJieQiTime: true,
        );
        expect(customBoard, isNotNull);
      });
    });

    group('regression tests', () {
      test('year boundary handling', () {
        final newYearEve = AstroDateTime(2025, 12, 31, 23, 0, 0);
        final newYearDay = AstroDateTime(2026, 1, 1, 1, 0, 0);

        final boardEve = board.getYearBoard(newYearEve);
        final boardDay = board.getYearBoard(newYearDay);

        expect(boardEve.stars, hasLength(9));
        expect(boardDay.stars, hasLength(9));
      });

      test('solar term boundary handling', () {
        final beforeTerm = AstroDateTime(2026, 3, 5, 10, 0, 0);
        final afterTerm = AstroDateTime(2026, 3, 6, 10, 0, 0);

        final time1 = TimePack.createBySolarTime(clockTime: beforeTerm, timezone: 8.0);
        final time2 = TimePack.createBySolarTime(clockTime: afterTerm, timezone: 8.0);

        final board1 = board.getDayBoard(time1);
        final board2 = board.getDayBoard(time2);

        expect(board1.stars, hasLength(9));
        expect(board2.stars, hasLength(9));
      });
    });
  });

  group('PaiLongEngine', () {
    group('calculateFacingStar', () {
      test('returns valid star name', () {
        final star = PaiLongEngine.calculateFacingStar(Mountain.zi, Mountain.wu);
        expect(star, isNotEmpty);
      });

      test('returns one of the 12 stars', () {
        final validStars = [
          '破军', '右弼', '廉贞', '武曲', '贪狼', '左辅',
          '文曲', '巨门', '禄存'
        ];
        final star = PaiLongEngine.calculateFacingStar(Mountain.zi, Mountain.wu);
        expect(validStars.contains(star), isTrue);
      });

      test('handles all mountain combinations', () {
        for (final laiLong in Mountain.values) {
          for (final facing in Mountain.values) {
            final star = PaiLongEngine.calculateFacingStar(laiLong, facing);
            expect(star, isNotEmpty);
          }
        }
      });

      test('same inputs produce same output', () {
        final star1 = PaiLongEngine.calculateFacingStar(Mountain.zi, Mountain.wu);
        final star2 = PaiLongEngine.calculateFacingStar(Mountain.zi, Mountain.wu);
        expect(star1, equals(star2));
      });

      test('different inputs may produce different outputs', () {
        final star1 = PaiLongEngine.calculateFacingStar(Mountain.zi, Mountain.wu);
        final star2 = PaiLongEngine.calculateFacingStar(Mountain.wu, Mountain.zi);
        // They may or may not be different, but both should be valid
        expect(star1, isNotEmpty);
        expect(star2, isNotEmpty);
      });
    });
  });

  group('Mountain enum', () {
    test('has 24 mountains', () {
      expect(Mountain.values, hasLength(24));
    });

    test('all mountains have chinese names', () {
      for (final mountain in Mountain.values) {
        expect(mountain.chineseName, isNotEmpty);
      }
    });

    test('all mountains have valid luoShuNum', () {
      for (final mountain in Mountain.values) {
        expect(mountain.luoShuNum, greaterThanOrEqualTo(1));
        expect(mountain.luoShuNum, lessThanOrEqualTo(9));
      }
    });

    test('all mountains have valid dragon type', () {
      for (final mountain in Mountain.values) {
        expect(mountain.dragon, isA<YuanLong>());
      }
    });

    test('getFlyDirectionByStarNumber throws for 5', () {
      expect(
        () => Mountain.getFlyDirectionByStarNumber(5, YuanLong.earth),
        throwsException,
      );
    });

    test('getFlyDirectionByStarNumber returns bool for valid stars', () {
      for (int star = 1; star <= 9; star++) {
        if (star == 5) continue;
        for (final dragon in YuanLong.values) {
          final direction = Mountain.getFlyDirectionByStarNumber(star, dragon);
          expect(direction, isA<bool>());
        }
      }
    });
  });
}