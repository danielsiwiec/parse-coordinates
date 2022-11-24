class Location {
  double lat = 0;
  double long = 0;

  Location(this.lat, this.long);

  double get latitude => lat;
  double get longitude => long;

  @override
  bool operator ==(Object other) {
    return other is Location && other.lat == lat && other.long == long;
  }

  @override
  int get hashCode => lat.hashCode + long.hashCode;

  @override
  String toString() {
    return "lat: $lat, long: $long";
  }
}