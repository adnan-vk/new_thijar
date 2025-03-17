//     final businessProfileModel = businessProfileModelFromJson(jsonString);

import 'dart:convert';

BusinessProfileModel businessProfileModelFromJson(String str) =>
    BusinessProfileModel.fromJson(json.decode(str));

String businessProfileModelToJson(BusinessProfileModel data) =>
    json.encode(data.toJson());

class BusinessProfileModel {
  String? message;
  BusinessProfile? businessProfile;

  BusinessProfileModel({
    this.message,
    this.businessProfile,
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) =>
      BusinessProfileModel(
        message: json["message"],
        businessProfile: json["businessProfile"] == null
            ? null
            : BusinessProfile.fromJson(json["businessProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "businessProfile": businessProfile?.toJson(),
      };
}

class BusinessProfile {
  String? id;
  String? businessName;
  String? phoneNo;
  String? email;
  String? gstIn;
  String? logo;
  String? businessAddress;
  String? businessType;
  String? businessCategory;
  String? pincode;
  String? state;
  String? businessDescription;
  String? signature;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BusinessProfile({
    this.id,
    this.businessName,
    this.phoneNo,
    this.email,
    this.gstIn,
    this.logo,
    this.businessAddress,
    this.businessType,
    this.businessCategory,
    this.pincode,
    this.state,
    this.businessDescription,
    this.signature,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      BusinessProfile(
        id: json["_id"].toString(),
        businessName: json["businessName"].toString(),
        phoneNo: json["phoneNo"].toString(),
        email: json["email"].toString(),
        gstIn: json["gstIn"].toString(),
        logo: json["logo"].toString(),
        businessAddress: json["businessAddress"].toString(),
        businessType: json["businessType"].toString(),
        businessCategory: json["businessCategory"].toString(),
        pincode: json["pincode"] ?? "".toString(),
        state: json["state"].toString(),
        businessDescription: json["businessDescription"].toString(),
        signature: json["signature"].toString(),
        createdBy: json["createdBy"].toString(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "businessName": businessName,
        "phoneNo": phoneNo,
        "email": email,
        "gstIn": gstIn,
        "logo": logo,
        "businessAddress": businessAddress,
        "businessType": businessType,
        "businessCategory": businessCategory,
        "pincode": pincode,
        "state": state,
        "businessDescription": businessDescription,
        "signature": signature,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class State {
  String? id;
  String? name;

  State({
    this.id,
    this.name,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
