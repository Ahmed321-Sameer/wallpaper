import 'dart:convert';

List<ImagesModel> imagesModelFromJson(String str) => List<ImagesModel>.from(
    json.decode(str).map((x) => ImagesModel.fromJson(x)));

String imagesModelToJson(List<ImagesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImagesModel {
  ImagesModel({
    this.id,
    this.category,
    this.title,
    this.description,
    this.image,
    this.v,
  });

  String? id;
  Category? category;
  String? title;
  String? description;
  String? image;
  int? v;

  factory ImagesModel.fromJson(Map<String, dynamic> json) => ImagesModel(
        id: json["_id"],
        category: Category.fromJson(json["category"]),
        title: json["title"],
        description: json["description"],
        image: json["image"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category!.toJson(),
        "title": title,
        "description": description,
        "image": image,
        "__v": v,
      };
}

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
