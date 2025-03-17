// To parse this JSON data, do
//
//     final itemSettingModel = itemSettingModelFromJson(jsonString);

import 'dart:convert';

TaxSettingModel itemSettingModelFromJson(String str) =>
    TaxSettingModel.fromJson(json.decode(str));

// String itemSettingModelToJson(ItemSettingModel data) =>
//     json.encode(data.toJson());

class TaxSettingModel {
  String? status;
  String? message;
  Data? data;

  TaxSettingModel({
    this.status,
    this.message,
    this.data,
  });

  factory TaxSettingModel.fromJson(Map<String, dynamic> json) =>
      TaxSettingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  String? id;
  bool? enableEInvoice;
  bool? enableEWayBill;
  bool? enableGstPercent;
  bool? enableMyOnlineStore;
  bool? enableVatPercent;

  Data({
    this.id,
    this.enableGstPercent,
    this.enableVatPercent,
    this.enableEInvoice,
    this.enableEWayBill,
    this.enableMyOnlineStore,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        enableGstPercent: json["enableGstPercent"],
        enableVatPercent: json["enableVatPercent"],
        enableEInvoice: json["enableEInvoice"],
        enableEWayBill: json["enableEWayBill"],
        enableMyOnlineStore: json["enableMyOnlineStore"],
      );
}
