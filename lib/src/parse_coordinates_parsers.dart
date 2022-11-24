import 'parse_coordinates_location.dart';
import 'package:utm/utm.dart';

abstract class Parser {
  const Parser();

  canProcess(string);

  parse(string);
}

class DecimalDegreesParser extends Parser {
  const DecimalDegreesParser();

  @override
  canProcess(string) => RegexBuilder().plusMinus().decimalNumber().comma().plusMinus().decimalNumber().build().hasMatch(string);

  @override
  parse(string) {
    var coordinates = string.replaceAll(',', ' ').replaceAll(RegExp(r"\s+"), ' ').split(' ');
    return Location(double.parse(coordinates[0]), double.parse(coordinates[1]));
  }
}

class DecimalMinutesParser extends Parser {
  const DecimalMinutesParser();

  @override
  canProcess(string) =>
      RegexBuilder()
          .plusMinus()
          .integer()
          .degreeOption()
          .decimalNumber()
          .minuteOption()
          .comma()
          .plusMinus()
          .integer()
          .degreeOption()
          .decimalNumber()
          .minuteOption()
          .build()
          .hasMatch(string);

  @override
  parse(string) {
    var coordinates = string.replaceAll(',', ' ').replaceAll(RegExp('°'), ' ').replaceAll(RegExp(r"\s+"), ' ').replaceAll("'", '').split(' ');
    var lat = [coordinates[0], coordinates[1]];
    var lng = [coordinates[2], coordinates[3]];

    getSign(input) {
      return double.parse(input) > 0 ? 1 : -1;
    }

    return Location(
        double.parse(lat[0]) + getSign(lat[0]) * double.parse(lat[1]) / 60,
        double.parse(lng[0]) + getSign(lng[0]) * double.parse(lng[1]) / 60
    );
  }
}

class MinutesSecondsParser extends Parser {
  const MinutesSecondsParser();

  @override
  canProcess(string) =>
      RegexBuilder()
          .integer()
          .degreeOption()
          .integer()
          .minuteOption()
          .decimalNumber()
          .secondOption()
          .whiteSpace()
          .and('[NS]')
          .whiteSpace()
          .integer()
          .degreeOption()
          .integer()
          .minuteOption()
          .decimalNumber()
          .secondOption()
          .whiteSpace()
          .and('[EW]')
          .build()
          .hasMatch(string);

  @override
  parse(string) {
    var coordinates = string.replaceAllMapped(RegExp(r"\s(\D)"), (Match m) => m.group(1)!).split(' ');
    var lat = RegExp("^(\\d+)°(\\d+)'(\\d+(\\.\\d+))?\"([NS])").firstMatch(coordinates[0].trim())!;
    var lng = RegExp("^(\\d+)°(\\d+)'(\\d+(\\.\\d+))?\"([EW])").firstMatch(coordinates[1].trim())!;

    toDecimal(minutes, seconds) {
      var number = (double.parse(minutes) * 60 + double.parse(seconds)) / 3600;
      return number.roundTo(5);
    }

    getSign(direction) {
      return direction == 'N' || direction == 'E' ? 1 : -1;
    }

    return Location(
      getSign(lat.group(5)) * (double.parse(lat.group(1).toString()) + toDecimal(lat.group(2), lat.group(3))),
      getSign(lng.group(5)) * (double.parse(lng.group(1).toString()) + toDecimal(lng.group(2), lng.group(3)))
    );
  }
}

class UtmParser extends Parser {
  const UtmParser();

  @override
  canProcess(string) =>
      // '31T 430959.5858286716 4583866.770942634'
      RegexBuilder()
          .integer(2)
          .and('[C-X]')
          .whiteSpace()
          .decimalNumber()
          .whiteSpace()
          .decimalNumber()
          .build()
          .hasMatch(string);

  @override
  parse(string) {
    var match = RegExp("^(\\d{2})([C-X]) (\\d+(\\.\\d+)?) (\\d+(\\.\\d+)?)\$").firstMatch(string)!;
    var easting = double.parse(match.group(3)!);
    var northing = double.parse(match.group(5)!);
    var zoneNumber = int.parse(match.group(1)!);
    var zoneLetter = match.group(2)!;
    var coordinates = UTM.fromUtm(easting: easting, northing: northing, zoneNumber: zoneNumber, zoneLetter: zoneLetter);
    return Location(coordinates.lat.roundTo(5), coordinates.lon.roundTo(5));
  }
}

class NoopParser extends Parser {
  @override
  canProcess(string) => true;

  @override
  parse(string) => null;

}

class RegexBuilder {
  String str = "^";

  RegexBuilder plusMinus() {
    str += '[-+]?';
    return this;
  }

  RegexBuilder decimalNumber() {
    str += r'\d+(\.\d+)?';
    return this;
  }

  RegexBuilder integer([num? digits]) {
    str += '\\d${digits != null ? '{$digits}' : "+"}';
    return this;
  }

  RegexBuilder comma() {
    str += r',?\s*';
    return this;
  }

  RegexBuilder degreeOption() {
    str += '(°|° | )';
    return this;
  }

  RegexBuilder minuteOption() {
    str += "'?";
    return this;
  }

  RegexBuilder secondOption() {
    str += '"?';
    return this;
  }

  RegexBuilder whiteSpace() {
    str += r'\s*';
    return this;
  }

  RegexBuilder and(string) {
    str += string;
    return this;
  }

  // regex: /^\d+°\d+'\d+(\.\d+)?"\s*[NS]\s*\d+°\d+'\d+(\.\d+)?"\s*[EW]$/,
  // regex: /^\d{2}[C-X] \d+(\.\d+)? \d+(\.\d+)?$/,

  RegExp build() {
    str += r'$';
    return RegExp(str);
  }
}

extension DoubleRounding on double {
  double roundTo(int places) {
    return double.parse(toStringAsFixed(places));
  }
}