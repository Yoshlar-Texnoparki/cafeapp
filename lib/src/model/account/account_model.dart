class AccountModel {
  String firstName;
  String lastName;
  String role;
  String company;
  int companyId;

  AccountModel({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.company,
    required this.companyId,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    role: json["role"]??"",
    company: json["company"]??'',
    companyId: json["company_id"]??0,
  );

}
