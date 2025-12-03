class OrderDetailModel {
  int id;
  Adder adder;
  dynamic waiter;
  Place place;
  List<Item> items;
  num totalPrice;
  String orderType;
  bool isActive;
  DateTime regDate;
  dynamic status;
  num totalAmount;
  num waiterFee;

  OrderDetailModel({
    required this.id,
    required this.adder,
    required this.waiter,
    required this.place,
    required this.items,
    required this.totalPrice,
    required this.orderType,
    required this.isActive,
    required this.regDate,
    required this.status,
    required this.totalAmount,
    required this.waiterFee,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    id: json["id"]??0,
    adder: json["adder"] ==null?Adder.fromJson({}):Adder.fromJson(json["adder"]),
    waiter: json["waiter"]??'',
    place: json["place"] ==null?Place.fromJson({}):Place.fromJson(json["place"]),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    totalPrice: json["total_price"]??0,
    orderType: json["order_type"]??"",
    isActive: json["is_active"]??false,
    regDate: json["reg_date"] ==null?DateTime.now():DateTime.parse(json["reg_date"]),
    status: json["status"],
    totalAmount: json["total_amount"]??0,
    waiterFee: json["waiter_fee"]??0,
  );
}

class Adder {
  int id;
  String firstName;
  String lastName;
  dynamic role;
  dynamic waiterSumma;
  dynamic waiterSummaType;

  Adder({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.waiterSumma,
    required this.waiterSummaType,
  });

  factory Adder.fromJson(Map<String, dynamic> json) => Adder(
    id: json["id"]??0,
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    role: json["role"]??"",
    waiterSumma: json["waiter_summa"]??0,
    waiterSummaType: json["waiter_summa_type"]??0,
  );

}


class Item {
  int foodId;
  String weightType;
  num quantity;
  num price;
  Food food;

  Item({
    required this.foodId,
    required this.weightType,
    required this.quantity,
    required this.price,
    required this.food,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    foodId: json["food_id"]??0,
    weightType: json["weight_type"]??"",
    quantity: json["quantity"]??0,
    price: json["price"]??0,
    food: json["food"] == null?Food.fromJson({}):Food.fromJson(json["food"]),
  );

}

class Food {
  String name;
  int price;
  dynamic categoryId;
  String description;
  bool defaultFood;
  int priceKg;
  dynamic image;

  Food({
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.defaultFood,
    required this.priceKg,
    required this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    name: json["name"]??"",
    price: json["price"]??0,
    categoryId: json["category_id"]??0,
    description: json["description"]??"",
    defaultFood: json["default_food"]??false,
    priceKg: json["price_kg"]??0,
    image: json["image"]??"",
  );
}

class Place {
  String name;
  int qty;
  int id;
  int hallId;
  String hallName;
  dynamic lastOrder;
  num placePrice;
  String placePriceType;

  Place({
    required this.name,
    required this.qty,
    required this.id,
    required this.hallId,
    required this.hallName,
    required this.lastOrder,
    required this.placePrice,
    required this.placePriceType,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    name: json["name"]??"",
    qty: json["qty"]??0,
    id: json["id"]??0,
    hallId: json["hall_id"]??0,
    hallName: json["hall_name"]??"",
    lastOrder: json["last_order"],
    placePrice: json["place_price"]??0,
    placePriceType: json["place_price_type"]??"",
  );

}
class Role {
  String name;

  Role({
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    name: json["name"]??"",
  );
}

