// To parse this JSON data, do
//
//     final salesReportModel = salesReportModelFromJson(jsonString);

import 'dart:convert';

List<SalesReportModel> salesReportModelFromJson(String str) =>
    List<SalesReportModel>.from(
        json.decode(str).map((x) => SalesReportModel.fromJson(x)));

String salesReportModelToJson(List<SalesReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesReportModel {
  Reference? reference;
  String? id;
  String? transactionType;
  Party? party;
  String? totalAmount;
  String? creditAmount;
  String? debitAmount;
  String? balance;
  String? transactionDate;

  SalesReportModel({
    this.reference,
    this.id,
    this.transactionType,
    this.party,
    this.totalAmount,
    this.creditAmount,
    this.debitAmount,
    this.balance,
    this.transactionDate,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) =>
      SalesReportModel(
        reference: json["reference"] == null
            ? null
            : Reference.fromJson(json["reference"]),
        id: json["_id"].toString(),
        transactionType: json["transactionType"].toString(),
        party: json["party"] == null ? null : Party.fromJson(json["party"]),
        totalAmount: json["totalAmount"].toString(),
        creditAmount: json["credit_amount"].toString(),
        debitAmount: json["debit_amount"].toString(),
        balance: json["balance"].toString(),
        transactionDate: json["transactionDate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "reference": reference?.toJson(),
        "_id": id,
        "transactionType": transactionType,
        "party": party?.toJson(),
        "totalAmount": totalAmount,
        "credit_amount": creditAmount,
        "debit_amount": debitAmount,
        "balance": balance,
        "transactionDate": transactionDate,
      };
}

class Party {
  String? id;
  String? name;

  Party({
    this.id,
    this.name,
  });

  factory Party.fromJson(Map<String, dynamic> json) => Party(
        id: json["_id"].toString(),
        name: json["name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Reference {
  String? documentNumber;

  Reference({
    this.documentNumber,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        documentNumber: json["documentNumber"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "documentNumber": documentNumber,
      };
}
