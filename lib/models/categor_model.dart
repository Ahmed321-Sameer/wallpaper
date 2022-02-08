import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    this.id,
    this.description,
    this.name,
    this.imagename,
    this.timeStamp,
    this.v,
  });

  String? id;
  String? description;
  String? name;
  String? imagename;
  DateTime? timeStamp;
  int? v;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        description: json["description"],
        name: json["name"],
        imagename: json["imagename"],
        timeStamp: DateTime.parse(json["time_stamp"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
        "name": name,
        "imagename": imagename,
        "time_stamp": timeStamp!.toIso8601String(),
        "__v": v,
      };
}
