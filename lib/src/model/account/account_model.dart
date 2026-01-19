class AccountModel {
  int id;
  String firstName;
  String lastName;
  String role;
  int roleId;
  String phone;
  String username;
  String company;
  bool isActive;
  num waiterSumma;
  String waiterSummaType;

  AccountModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.roleId,
    required this.phone,
    required this.username,
    required this.company,
    required this.isActive,
    required this.waiterSumma,
    required this.waiterSummaType,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["id"] ?? 0,
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    role: json["role"] ?? "",
    roleId: json["role_id"] ?? 0,
    phone: json["phone"] ?? "",
    username: json["username"] ?? "",
    company: json["company"] ?? '',
    isActive: json["is_active"] ?? false,
    waiterSumma: json["waiter_summa"] ?? 0,
    waiterSummaType: json["waiter_summa_type"] ?? "",
  );
}
