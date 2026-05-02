## 0.1.5

- Apply `dart format` across the package and remove an unnecessary
  import in `lib/src/models/huangli_year.dart` to clear the remaining
  static analysis warnings.
- Reorganize the `example/` directory: rename `example_demo.dart` to
  `chinese_lunar_almanac_example.dart` so the canonical example is
  discoverable, and remove the empty placeholder file.
- Rewrite the changelog in English to follow pub.dev conventions.

## 0.1.4

- Bump `sxwnl_spa_dart` dependency to `^0.18.4`.
- Pick up the underlying `LunarDate` fix that re-aligns lunar-year
  attribution for both pre-Common-Era ancient calendars and the
  historical calendar-reform window in the Common Era.

## 0.1.3

- Bump `sxwnl_spa_dart` dependency to `^0.18.3`.
- Pick up the BCE lunar-year fix in the underlying calendar so that
  pre-Common-Era almanac results stay consistent with the lunar engine.

## 0.1.2

- Bump `sxwnl_spa_dart` dependency to `0.18.1`.

## 0.1.1

- Add Mother's Day, Father's Day, Thanksgiving and other "Nth weekday
  of the month" festivals.
- Fix the dependency version in the README (`1.0.0` → `0.1.0`).
- Clean up all `dart analyze` lints (braces, HTML escaping in comments,
  redundant imports).
- Disable the `constant_identifier_names` lint to keep pinyin-based
  identifiers readable.
- Add a credits section to the README acknowledging cnlunar and the
  Shouxing perpetual calendar (寿星万年历) as data sources.

## 0.1.0

Initial preview release.

### Core features

- Solar / lunar date conversion.
- Year, month, day and hour pillars (GanZhi) with Nayin Five Elements.
- Twenty-four solar terms with precise instants and timezone awareness.
- The 28 lunar mansions.
- Twelve "JianChu" day officers and the twelve day gods (Yellow / Black
  Way).
- Hour pillars with Yellow / Black Way auspicious-or-not classification.
- Pengzu's Hundred Taboos and daily Chong-Sha clash information.
- Festival detection across solar, lunar and solar-term calendars.
- Moon phases (new / full).
- Shen-Sha enumeration and a Yi / Ji (suitable / taboo) inference engine.

### Nine Star Flying Palace boards

- Year, month, day and hour boards.
- Earth, Mountain and Facing layers.
- Both solar-term and lunar-month boundary modes.
- "Lian-Ru" and "Jie-Lu" arrangements for the day board.
- `FlyingStarBoard` accessors for each palace (direction getters,
  Luoshu lookup, direction map).

### Unified entry points

- `HuangliCalendar` aggregates timezone, early/late Zi-hour and
  precise solar-term configuration in one place.
- `HuangliMonth` produces an entire solar month of almanac days.
- `HuangliYear` produces an entire solar year.

### Bug fixes

- Fix the off-by-one anchor for the daily flying-star JiaZi base
  (J2000 day index `7` → `6`).
