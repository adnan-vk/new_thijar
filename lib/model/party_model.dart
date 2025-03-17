import 'dart:convert';

List<PartyModel> partyModelFromJson(String str) =>
    List<PartyModel>.from(json.decode(str).map((x) => PartyModel.fromJson(x)));

String partyModelToJson(List<PartyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PartyModel {
  ContactDetails? contactDetails;
  OpeningBalanceDetails? openingBalanceDetails;
  BalanceDetails? balanceDetails;
  String? id;
  String? name;
  String? gstIn;
  String? gstType;
  dynamic state;
  String? billingAddress;
  String? shippingAddress;
  String? creditLimit;
  String? receivedAmount;
  String? paidAmount;
  String? additionalField1;
  String? additionalField2;
  String? additionalField3;
  String? createdBy;
  DateTime? updatedAt;
  String? v;

  PartyModel({
    this.contactDetails,
    this.openingBalanceDetails,
    this.balanceDetails,
    this.id,
    this.name,
    this.gstIn,
    this.gstType,
    this.state,
    this.billingAddress,
    this.shippingAddress,
    this.creditLimit,
    this.receivedAmount,
    this.paidAmount,
    this.additionalField1,
    this.additionalField2,
    this.additionalField3,
    this.createdBy,
    this.updatedAt,
    this.v,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) => PartyModel(
        contactDetails: json["contactDetails"] == null
            ? null
            : ContactDetails.fromJson(json["contactDetails"]),
        openingBalanceDetails: json["openingBalanceDetails"] == null
            ? null
            : OpeningBalanceDetails.fromJson(json["openingBalanceDetails"]),
        balanceDetails: json["balanceDetails"] == null
            ? null
            : BalanceDetails.fromJson(json["balanceDetails"]),
        id: json["_id"].toString(),
        name: json["name"].toString(),
        gstIn: json["gstIn"].toString(),
        gstType: json["gstType"].toString(),
        state: json["state"],
        billingAddress: json["billingAddress"].toString(),
        shippingAddress: json["shippingAddress"].toString(),
        creditLimit: json["creditLimit"].toString(),
        receivedAmount: json["receivedAmount"].toString(),
        paidAmount: json["paidAmount"].toString(),
        additionalField1: json["additionalField1"].toString(),
        additionalField2: json["additionalField2"].toString(),
        additionalField3: json["additionalField3"].toString(),
        createdBy: json["createdBy"].toString(),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "contactDetails": contactDetails?.toJson(),
        "openingBalanceDetails": openingBalanceDetails?.toJson(),
        "balanceDetails": balanceDetails?.toJson(),
        "_id": id,
        "name": name,
        "gstIn": gstIn,
        "gstType": gstType,
        "state": state,
        "billingAddress": billingAddress,
        "shippingAddress": shippingAddress,
        "creditLimit": creditLimit,
        "receivedAmount": receivedAmount,
        "paidAmount": paidAmount,
        "additionalField1": additionalField1,
        "additionalField2": additionalField2,
        "additionalField3": additionalField3,
        "createdBy": createdBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class BalanceDetails {
  String? receivableBalance;
  String? payableBalance;

  BalanceDetails({
    this.receivableBalance,
    this.payableBalance,
  });

  factory BalanceDetails.fromJson(Map<String, dynamic> json) => BalanceDetails(
        receivableBalance: json["receivableBalance"].toString(),
        payableBalance: json["payableBalance"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "receivableBalance": receivableBalance,
        "payableBalance": payableBalance,
      };
}

class ContactDetails {
  String? email;
  String? phone;

  ContactDetails({
    this.email,
    this.phone,
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) => ContactDetails(
        email: json["email"].toString(),
        phone: json["phone"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
      };
}

class OpeningBalanceDetails {
  String? openingBalance;
  DateTime? date;
  String? balanceType;

  OpeningBalanceDetails({
    this.openingBalance,
    this.date,
    this.balanceType,
  });

  factory OpeningBalanceDetails.fromJson(Map<String, dynamic> json) =>
      OpeningBalanceDetails(
        openingBalance: json["openingBalance"].toString(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        balanceType: json["balanceType"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "openingBalance": openingBalance,
        "date": date?.toIso8601String(),
        "balanceType": balanceType,
      };
}
