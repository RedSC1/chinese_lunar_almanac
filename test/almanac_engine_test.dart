import 'package:chinese_lunar_almanac/chinese_lunar_almanac.dart';
import 'package:test/test.dart';

void main() {
  group('NineStarBoard with user provided cases', () {
    final time = AstroDateTime(2026, 3, 16, 10, 0, 0);
    final tp = TimePack.createBySolarTime(
      clockTime: time,
      timezone: 8.0,
      splitByRatHour: false,
    );

    test('matches year board for 2026-03-16 in default solar mode', () {
      final board = NineStarBoard(boundary: Boundary.solar).getYearBoard(time);

      expect(board.numbers, orderedEquals([9, 5, 7, 8, 1, 3, 4, 6, 2]));
    });

    test('matches lunar-boundary month board for 2026-03-16', () {
      final board = NineStarBoard(boundary: Boundary.lunar).getMonthBoard(time);

      expect(board.numbers, orderedEquals([7, 3, 5, 6, 8, 1, 2, 4, 9]));
    });

    test('matches day board for 2026-03-16 from validated software output', () {
      final board = NineStarBoard(boundary: Boundary.solar).getDayBoard(tp);

      expect(board.numbers, orderedEquals([4, 9, 2, 3, 5, 7, 8, 1, 6]));
    });

    test('matches hour board for 2026-03-16 10:00 from validated software output', () {
      final board = NineStarBoard(boundary: Boundary.solar).getHourBoard(tp);

      expect(board.numbers, orderedEquals([8, 4, 6, 7, 9, 2, 3, 5, 1]));
    });
  });

  group('FlyingStarBoard helpers', () {
    final board = FlyingStarBoard([
      FlyingStar.star9,
      FlyingStar.star5,
      FlyingStar.star7,
      FlyingStar.star8,
      FlyingStar.star1,
      FlyingStar.star3,
      FlyingStar.star4,
      FlyingStar.star6,
      FlyingStar.star2,
    ]);

    test('exposes palace order numbers directly', () {
      expect(board.numbers, orderedEquals([9, 5, 7, 8, 1, 3, 4, 6, 2]));
    });

    test('returns stars by direction getters', () {
      expect(board.southeastStar, FlyingStar.star9);
      expect(board.southStar, FlyingStar.star5);
      expect(board.southwestStar, FlyingStar.star7);
      expect(board.eastStar, FlyingStar.star8);
      expect(board.centerStar, FlyingStar.star1);
      expect(board.westStar, FlyingStar.star3);
      expect(board.northeastStar, FlyingStar.star4);
      expect(board.northStar, FlyingStar.star6);
      expect(board.northwestStar, FlyingStar.star2);
    });

    test('returns stars by compass direction and LuoShu number', () {
      expect(board.starAt(CompassDirection.center), FlyingStar.star1);
      expect(board.starAt(CompassDirection.north), FlyingStar.star6);
      expect(board.starByLuoShuNumber(1), FlyingStar.star6);
      expect(board.starByLuoShuNumber(5), FlyingStar.star1);
      expect(board.starByLuoShuNumber(9), FlyingStar.star5);
    });

    test('returns immutable direction map', () {
      final directionMap = board.toDirectionMap();

      expect(directionMap[CompassDirection.center], FlyingStar.star1);
      expect(directionMap[CompassDirection.west], FlyingStar.star3);
      expect(directionMap.keys, orderedEquals(FlyingStarBoard.palaceOrder));
    });
  });
}
