import 'dart:convert';

AddCompanyModel addCompanyModelFromJson(String str) =>
    AddCompanyModel.fromJson(json.decode(str));

String addCompanyModelToJson(AddCompanyModel data) =>
    json.encode(data.toJson());

class AddCompanyModel {
  String? companyName;
  String? phoneNo;
  String? email;

  AddCompanyModel({
    this.companyName,
    this.phoneNo,
    this.email,
  });

  factory AddCompanyModel.fromJson(Map<String, dynamic> json) =>
      AddCompanyModel(
        companyName: json["companyName"],
        phoneNo: json["phoneNo"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "phoneNo": phoneNo,
        "email": email,
      };
}
