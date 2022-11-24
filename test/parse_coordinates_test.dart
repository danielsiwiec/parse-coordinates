import 'package:parse_coordinates/parse_coordinates.dart';
import 'package:test/test.dart';

void main() {
  group('Decimal Degrees', () {
    test('should recognize parseCoordinates', () {
      expect(parseCoordinates('41.40338, 2.17403'), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates without a comma', () {
      expect(parseCoordinates('41.40338 2.17403'), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates without a comma', () {
      expect(parseCoordinates('-41.40338, -2.17403'), equals(Location(-41.40338, -2.17403)));
    });
  });

  group('Decimal Minutes', () {
    test('should recognize parseCoordinates', () {
      expect(parseCoordinates('41 24.2028, 2 10.4418'), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates without a comma', () {
      expect(parseCoordinates('41 24.2028 2 10.4418'), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates with degree and minute symbol, without a comma', () {
      expect(parseCoordinates("41° 24.2028' 2° 10.4418'"), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates with degree and minute symbol, without a comma, without spaces', () {
      expect(parseCoordinates("41°24.2028' 2°10.4418'"), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates with degree and minute symbol, with a comma, without spaces', () {
      expect(parseCoordinates("41°24.2028', 2°10.4418'"), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize parseCoordinates with degree and minute symbol, with a comma', () {
      expect(parseCoordinates("41° 24.2028', 2° 10.4418'"), equals(Location(41.40338, 2.17403)));
    });

    test('should recognize negative parseCoordinates', () {
      expect(parseCoordinates('-41 24.2028, -2 10.4418'), equals(Location(-41.40338, -2.17403)));
    });
  });

  group('Degrees, minutes, seconds', () {
    test('should recognize parseCoordinates for NE', () {
      expect(parseCoordinates("41°24'12.2\"N 2°10'26.5\"E"), equals(Location(41.40339, 2.17403)));
    });

    test('should recognize parseCoordinates for SW', () {
      expect(parseCoordinates("41°24'12.2\"S 2°10'26.5\"W"), equals(Location(-41.40339, -2.17403)));
    });

    test('should recognize parseCoordinates for SW with a space before NSEW', () {
      expect(parseCoordinates("41°24'12.2\" S 2°10'26.5\" W"), equals(Location(-41.40339, -2.17403)));
    });
  });

  group('UTM', () {
    test('should recognize UTM format', () {
      expect(parseCoordinates('31T 430959.5858286716 4583866.770942634'), equals(Location(41.40338, 2.17403)));
    });
  });

  test('should return null for a search string input', () {
    expect(parseCoordinates('freddys sandwitches'), equals(null));
  });
}
