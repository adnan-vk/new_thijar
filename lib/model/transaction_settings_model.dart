// To parse this JSON data, do
//
//     final itemSettingModel = itemSettingModelFromJson(jsonString);

import 'dart:convert';

TransactionSettingModel itemSettingModelFromJson(String str) =>
    TransactionSettingModel.fromJson(json.decode(str));

// String itemSettingModelToJson(ItemSettingModel data) =>
//     json.encode(data.toJson());

class TransactionSettingModel {
  String? status;
  String? message;
  Data? data;

  TransactionSettingModel({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionSettingModel.fromJson(Map<String, dynamic> json) =>
      TransactionSettingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  bool? enableDeliveryChallan;
  bool? enableEstimate;
  bool? enableSalesOrder;
  bool? enableExportSales;
  bool? enablePurchaseOrder;
  bool? enableImportPurchase;
  bool? enableShippingAddress;
  bool? enablePartyEmail;

  Data({
    this.enableDeliveryChallan,
    this.enableEstimate,
    this.enableSalesOrder,
    this.enableExportSales,
    this.enablePurchaseOrder,
    this.enableImportPurchase,
    this.enableShippingAddress,
    this.enablePartyEmail,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        enableDeliveryChallan: json['enableDeliveryChallan'],
        enableEstimate: json['enableEstimate'],
        enableExportSales: json['enableExportSales'],
        enableImportPurchase: json['enableImportPurchase'],
        enablePartyEmail: json['enablePartyEmail'],
        enablePurchaseOrder: json['enablePurchaseOrder'],
        enableSalesOrder: json['enableSalesOrder'],
        enableShippingAddress: json['enableShippingAddress'],
      );
}
