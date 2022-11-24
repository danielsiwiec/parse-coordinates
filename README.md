# parse-coordinates

A Dart package to parse Latitude/Longitude coordinates from a string. This is a port of the existing npm library (https://www.npmjs.com/package/parse-coords).

## Usage:

```dart
import 'package:parse_coordinates/parse_coordinates.dart';

void main() {
  var location = parseCoordinates('41.40338, 2.17403');
  print('lat: ${location?.latitude}, long: ${location?.longitude}');
}

```