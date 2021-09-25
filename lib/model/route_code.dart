 // RouteCode



class RouteCode {
  RouteCode({
    required this.id,
    required this.name,
    required this.updated,
  });

  final int id;
  final String name;
  final String updated;

  factory RouteCode.fromJson(Map<String, dynamic> json) => RouteCode(
    id: json["id"],
    name: json["name"],
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "updated": updated,
  };


  @override
  String toString() {
    return '[RouteCode] id: $id, name: $name, updated: $updated';
  }

} // class RouteCode

