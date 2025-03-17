// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

List<InvoiceModel> invoiceModelFromJson(String str) => List<InvoiceModel>.from(
    json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String invoiceModelToJson(List<InvoiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceModel {
  String? id;
  String? invoiceNo;
  String? invoiceType;
  String? invoiceDate;
  String? partyName;
  String? paymentMethod;
  dynamic bankName;
  double? totalAmount;
  double? balanceAmount;

  InvoiceModel({
    this.id,
    this.invoiceNo,
    this.invoiceType,
    this.invoiceDate,
    this.partyName,
    this.paymentMethod,
    this.bankName,
    this.totalAmount,
    this.balanceAmount,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["_id"],
        invoiceNo: json["invoiceNo"],
        invoiceType: json["invoiceType"],
        invoiceDate: json["invoiceDate"],
        partyName: json["partyName"],
        paymentMethod: json["paymentMethod"],
        bankName: json["bankName"],
        totalAmount: json["totalAmount"]?.toDouble(),
        balanceAmount: json["balanceAmount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "invoiceNo": invoiceNo,
        "invoiceType": invoiceType,
        "invoiceDate": invoiceDate,
        "partyName": partyName,
        "paymentMethod": paymentMethod,
        "bankName": bankName,
        "totalAmount": totalAmount,
        "balanceAmount": balanceAmount,
      };
}
