// To parse this JSON data, do
//
//     final manageGodownModel = manageGodownModelFromJson(jsonString);

import 'dart:convert';

ManageGodownModel manageGodownModelFromJson(String str) =>
    ManageGodownModel.fromJson(json.decode(str));

String manageGodownModelToJson(ManageGodownModel data) =>
    json.encode(data.toJson());

class ManageGodownModel {
  String? message;
  Datas? data;

  ManageGodownModel({
    this.message,
    this.data,
  });

  factory ManageGodownModel.fromJson(Map<String, dynamic> json) =>
      ManageGodownModel(
        message: json["message"],
        data: json["data"] == null ? null : Datas.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Datas {
  bool? isMain;
  String? type;
  String? name;
  String? phoneNo;
  String? email;
  String? location;
  String? gstIn;
  String? pinCode;
  String? address;
  String? companyId;
  String? createdBy;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datas({
    this.isMain,
    this.type,
    this.name,
    this.phoneNo,
    this.email,
    this.location,
    this.gstIn,
    this.pinCode,
    this.address,
    this.companyId,
    this.createdBy,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
        isMain: json["isMain"],
        type: json["type"],
        name: json["name"],
        phoneNo: json["phoneNo"],
        email: json["email"],
        location: json["location"],
        gstIn: json["gstIn"],
        pinCode: json["pinCode"],
        address: json["address"],
        companyId: json["companyId"],
        createdBy: json["createdBy"],
        id: json["_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "isMain": isMain,
        "type": type,
        "name": name,
        "phoneNo": phoneNo,
        "email": email,
        "location": location,
        "gstIn": gstIn,
        "pinCode": pinCode,
        "address": address,
        "companyId": companyId,
        "createdBy": createdBy,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
