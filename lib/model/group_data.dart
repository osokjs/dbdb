// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

GroupData groupFromJson(String str) => GroupData.fromJson(json.decode(str));

String groupToJson(GroupData data) => json.encode(data.toJson());

class GroupData {
  GroupData({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
