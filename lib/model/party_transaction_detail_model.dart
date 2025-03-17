//     final partyTransactionDetailModel = partyTransactionDetailModelFromJson(jsonString);

import 'dart:convert';

PartyTransactionDetailModel partyTransactionDetailModelFromJson(String str) =>
    PartyTransactionDetailModel.fromJson(json.decode(str));

String partyTransactionDetailModelToJson(PartyTransactionDetailModel data) =>
    json.encode(data.toJson());

class PartyTransactionDetailModel {
  String? status;
  String? message;
  List<Datum>? data;

  PartyTransactionDetailModel({
    this.status,
    this.message,
    this.data,
  });

  factory PartyTransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      PartyTransactionDetailModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Reference? reference;
  String? transactionType;
  double? totalAmount;
  String? balance;
  String? transactionDate;

  Datum({
    this.reference,
    this.transactionType,
    this.totalAmount,
    this.balance,
    this.transactionDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reference: json["reference"] == null
            ? null
            : Reference.fromJson(json["reference"]),
        transactionType: json["transactionType"],
        totalAmount: double.parse(
            json["totalAmount"] != null ? json["totalAmount"].toString() : "0"),
        balance: json["balance"].toString(),
        transactionDate: json["transactionDate"],
      );

  Map<String, dynamic> toJson() => {
        "reference": reference?.toJson(),
        "transactionType": transactionType,
        "totalAmount": totalAmount,
        "balance": balance,
        "transactionDate": transactionDate,
      };
}

class Reference {
  String? documentNumber;

  Reference({
    this.documentNumber,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        documentNumber: json["documentNumber"],
      );

  Map<String, dynamic> toJson() => {
        "documentNumber": documentNumber,
      };
}
