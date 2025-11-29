import 'dart:convert';

List<HallCategoryModel> hallCategoryModelFromJson(String str) => List<HallCategoryModel>.from(json.decode(str).map((x) => HallCategoryModel.fromJson(x)));

class HallCategoryModel {
  int id;
  String name;
  int placesCount;

  HallCategoryModel({
    required this.id,
    required this.name,
    required this.placesCount,
  });

  factory HallCategoryModel.fromJson(Map<String, dynamic> json) =>
      HallCategoryModel(
        id: json["id"]??0,
        name: json["name"]??"",
        placesCount: json["places_count"]??0,
      );
}