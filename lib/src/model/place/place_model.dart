import 'dart:convert';

List<PlaceModel> placeModelFromJson(String str) => List<PlaceModel>.from(json.decode(str).map((x) => PlaceModel.fromJson(x)));
class PlaceModel {
  String name;
  int qty;
  int id;
  int hallId;
  String hallName;
  LastOrder lastOrder;
  int placePrice;
  String placePriceType;

  PlaceModel({
    required this.name,
    required this.qty,
    required this.id,
    required this.hallId,
    required this.hallName,
    required this.lastOrder,
    required this.placePrice,
    required this.placePriceType,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    name: json["name"]??"",
    qty: json["qty"]??0,
    id: json["id"]??0,
    hallId: json["hall_id"]??0,
    hallName: json["hall_name"]??"",
    lastOrder: LastOrder.fromJson(json["last_order"]),
    placePrice: json["place_price"]??0,
    placePriceType: json["place_price_type"]??"",
  );
}

class LastOrder {
  int id;
  bool isActive;
  int adderId;
  String adderFirstName;
  String adderLastName;
  int waiterId;
  String waiterFirstName;
  String waiterLastName;
  int totalSumma;

  LastOrder({
    required this.id,
    required this.isActive,
    required this.adderId,
    required this.adderFirstName,
    required this.adderLastName,
    required this.waiterId,
    required this.waiterFirstName,
    required this.waiterLastName,
    required this.totalSumma,
  });

  factory LastOrder.fromJson(Map<String, dynamic> json) => LastOrder(
    id: json["id"]??0,
    isActive: json["is_active"]??false,
    adderId: json["adder_id"]??0,
    adderFirstName: json["adder_first_name"]??"",
    adderLastName: json["adder_last_name"]??"",
    waiterId: json["waiter_id"]??0,
    waiterFirstName: json["waiter_first_name"]??"",
    waiterLastName: json["waiter_last_name"]??"",
    totalSumma: json["total_summa"]??0,
  );

}
