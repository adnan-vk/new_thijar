import 'dart:convert';

List<CashAdjustMentListModel> cashAdjustMentListModelFromJson(String str) =>
    List<CashAdjustMentListModel>.from(
        json.decode(str).map((x) => CashAdjustMentListModel.fromJson(x)));

String cashAdjustMentListModelToJson(List<CashAdjustMentListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CashAdjustMentListModel {
  String? id;
  String? adjustmentType;
  int? amount;
  DateTime? adjustmentDate;
  String? description;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CashAdjustMentListModel({
    this.id,
    this.adjustmentType,
    this.amount,
    this.adjustmentDate,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CashAdjustMentListModel.fromJson(Map<String, dynamic> json) =>
      CashAdjustMentListModel(
        id: json["_id"],
        adjustmentType: json["adjustmentType"],
        amount: json["amount"],
        adjustmentDate: json["adjustmentDate"] == null
            ? null
            : DateTime.parse(json["adjustmentDate"]),
        description: json["description"],
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
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
        "adjustmentType": adjustmentType,
        "amount": amount,
        "adjustmentDate": adjustmentDate?.toIso8601String(),
        "description": description,
        "createdBy": createdBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class CreatedBy {
  String? id;
  String? businessName;
  String? email;

  CreatedBy({
    this.id,
    this.businessName,
    this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        businessName: json["businessName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "businessName": businessName,
        "email": email,
      };
}
