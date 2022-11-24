import 'parse_coordinates_parsers.dart';
import 'parse_coordinates_location.dart';

Location? parseCoordinates(string) {
  const parsers = [DecimalDegreesParser(), DecimalMinutesParser(), MinutesSecondsParser(), UtmParser()];
  return parsers.firstWhere((element) => element.canProcess(string), orElse: () => NoopParser()).parse(string);
}