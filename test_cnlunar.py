import datetime
import sys
import os

# Add the cnlunar path to sys.path
sys.path.append(os.path.join(os.getcwd(), 'cnlunar_repo'))
import cnlunar

def test():
    # 2026-03-11 22:54:48
    dt = datetime.datetime(2026, 3, 11, 22, 54, 48)
    print(f"Testing for: {dt}")
    
    # Run with default '8char' mode (matching our Dart implementation's logic)
    a = cnlunar.Lunar(dt, godType='8char')
    
    print("-" * 30)
    print(f"Lunar: {a.lunarYearCn} {a.lunarMonthCn} {a.lunarDayCn}")
    print(f"Ganzhi: {a.year8Char} {a.month8Char} {a.day8Char} {a.twohour8Char}")
    print(f"12 Gods: {a.get_today12DayOfficer()}")
    print(f"Auspicious: {a.goodGodName}")
    print(f"Inauspicious: {a.badGodName}")
    print(f"Suitable: {a.goodThing}")
    print(f"Taboo: {a.badThing}")
    print("-" * 30)

if __name__ == "__main__":
    test()
