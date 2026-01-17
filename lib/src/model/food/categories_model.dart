// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) =>
    List<CategoriesModel>.from(
      json.decode(str).map((x) => CategoriesModel.fromJson(x)),
    );

String categoriesModelToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  final int id;
  final String name;
  final dynamic description;
  final int companyId;
  final List<Food> foods;

  CategoriesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.companyId,
    required this.foods,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        companyId: json["company_id"] ?? 0,
        foods: json["foods"] == null
            ? []
            : List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "company_id": companyId,
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
  };
}

class Food {
  final int id;
  final String name;
  final int price;
  final int categoryId;
  final String description;
  final bool defaultFood;
  final int priceKg;
  final dynamic image;
  final String status;
  final String weightType;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.defaultFood,
    required this.priceKg,
    required this.image,
    required this.status,
    required this.weightType,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    price: json["price"] ?? 0,
    categoryId: json["category_id"] ?? 0,
    description: json["description"] ?? "",
    defaultFood: json["default_food"] ?? false,
    priceKg: json["price_kg"] ?? 0,
    image: json["image"] ?? "",
    status: json["status"] ?? "",
    weightType: json["weight_type"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "category_id": categoryId,
    "description": description,
    "default_food": defaultFood,
    "price_kg": priceKg,
    "image": image,
    "status": status,
    "weight_type": weightType,
  };
}
