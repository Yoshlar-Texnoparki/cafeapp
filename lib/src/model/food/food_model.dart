import 'dart:convert';

List<FoodsModel> foodsModelFromJson(String str) => List<FoodsModel>.from(json.decode(str).map((x) => FoodsModel.fromJson(x)));
class FoodsModel {
  String name;
  int price;
  int priceKg;
  dynamic image;
  int categoryId;
  String description;
  bool defaultFood;
  String status;
  int id;
  String weightType;

  FoodsModel({
    required this.name,
    required this.price,
    required this.priceKg,
    required this.image,
    required this.categoryId,
    required this.description,
    required this.defaultFood,
    required this.status,
    required this.id,
    required this.weightType,
  });

  factory FoodsModel.fromJson(Map<String, dynamic> json) => FoodsModel(
    name: json["name"]??"",
    price: json["price"]??0,
    priceKg: json["price_kg"]??0,
    image: json["image"]??'',
    categoryId: json["category_id"]??0,
    description: json["description"]??"",
    defaultFood: json["default_food"]??false,
    status: json["status"]??false,
    id: json["id"]??0,
    weightType: json["weight_type"]??"",
  );

}
