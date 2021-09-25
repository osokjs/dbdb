// RouteData

class RouteData {
  RouteData({
    required this.routeId,
    required this.idx,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final int routeId; // route code
  final int idx;
  final String name;
  final double latitude;
  final double longitude;
  final double accuracy;

  factory RouteData.fromJson(Map<String, dynamic> json) => RouteData(
    routeId: json["routeId"],
    idx: json["idx"],
    name: json["name"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    accuracy: json["accuracy"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "routeId": routeId,
    "idx": idx,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "accuracy": accuracy,
  };

  @override
  String toString() {
    return '[RouteData] routeId: $routeId, idx: $idx, name: $name, latitude: $latitude, longitude: $longitude, accuracy: $accuracy';
  }

} // class RouteData

