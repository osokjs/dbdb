// GroupCode



class GroupCode {
  GroupCode({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GroupCode.fromJson(Map<String, dynamic> json) => GroupCode(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  String toString() {
    return '[GroupCode] id: $id, name: $name';
  }


} // class GroupCode


