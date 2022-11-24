import 'package:parse_coordinates/parse_coordinates.dart';

void main() {
  var location = parseCoordinates('41.40338, 2.17403');
  print('lat: ${location?.latitude}, long: ${location?.longitude}');
}
