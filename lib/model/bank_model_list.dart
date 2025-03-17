//     final bankModelList = bankModelListFromJson(jsonString);

import 'dart:convert';

List<BankModelList> bankModelListFromJson(String str) =>
    List<BankModelList>.from(
        json.decode(str).map((x) => BankModelList.fromJson(x)));

String bankModelListToJson(List<BankModelList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankModelList {
  String? id;
  int? openingBalance;
  String? accountNumber;
  String? accountHolderName;

  BankModelList({
    this.id,
    this.openingBalance,
    this.accountNumber,
    this.accountHolderName,
  });

  factory BankModelList.fromJson(Map<String, dynamic> json) => BankModelList(
        id: json["_id"],
        openingBalance: json["openingBalance"],
        accountNumber: json["accountNumber"],
        accountHolderName: json["accountHolderName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "openingBalance": openingBalance,
        "accountNumber": accountNumber,
        "accountHolderName": accountHolderName,
      };
}
