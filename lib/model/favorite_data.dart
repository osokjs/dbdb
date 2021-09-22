// FavoriteData

class FavoriteData {
  FavoriteData({
    required this.id,
    required this.groupId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.updated,
  });

  final int id;
  final int groupId; // group code
  final String name;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String updated;

  factory FavoriteData.fromJson(Map<String, dynamic> json) => FavoriteData(
    id: json["id"],
    groupId: json["groupId"],
    name: json["name"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    accuracy: json["accuracy"].toDouble(),
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    // "id": id, // autoincrement field
    "groupId": groupId,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "accuracy": accuracy,
    "updated": updated,
  };

  @override
  String toString() {
    return 'id: $id, groupId: $groupId, name: $name, latitude: $latitude, longitude: $longitude, accuracy: $accuracy, updated:$updated';
  }

} // class FavoriteData

