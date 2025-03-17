// import 'dart:convert';

// class CashFlowReportModel {
//   List<Money>? moneyIn;
//   List<Money>? moneyOut;
//   num? runningCashInHand;

//   CashFlowReportModel({
//     this.moneyIn,
//     this.moneyOut,
//     this.runningCashInHand,
//   });

//   CashFlowReportModel copyWith({
//     List<Money>? moneyIn,
//     List<Money>? moneyOut,
//     num? runningCashInHand,
//   }) =>
//       CashFlowReportModel(
//         moneyIn: moneyIn ?? this.moneyIn,
//         moneyOut: moneyOut ?? this.moneyOut,
//         runningCashInHand: runningCashInHand ?? this.runningCashInHand,
//       );

//   factory CashFlowReportModel.fromJson(String str) => CashFlowReportModel.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory CashFlowReportModel.fromMap(Map<String, dynamic> json) => CashFlowReportModel(
//     moneyIn: json["moneyIn"] == null ? [] : List<Money>.from(json["moneyIn"]!.map((x) => Money.fromMap(x))),
//     moneyOut: json["moneyOut"] == null ? [] : List<Money>.from(json["moneyOut"]!.map((x) => Money.fromMap(x))),
//     runningCashInHand: json["runningCashInHand"],
//   );

//   Map<String, dynamic> toMap() => {
//     "moneyIn": moneyIn == null ? [] : List<dynamic>.from(moneyIn!.map((x) => x.toMap())),
//     "moneyOut": moneyOut == null ? [] : List<dynamic>.from(moneyOut!.map((x) => x.toMap())),
//     "runningCashInHand": runningCashInHand,
//   };
// }

// class Money {
//   String? id;
//   DateTime? transactionDate;
//   String? partyName;
//   String? referenceNo;
//   String? type;
//   num? creditAmount;
//   num? debitAmount;

//   Money({
//     this.id,
//     this.transactionDate,
//     this.partyName,
//     this.referenceNo,
//     this.type,
//     this.creditAmount,
//     this.debitAmount,
//   });

//   Money copyWith({
//     String? id,
//     DateTime? transactionDate,
//     String? partyName,
//     String? referenceNo,
//     String? type,
//     num? creditAmount,
//     num? debitAmount,
//   }) =>
//       Money(
//         id: id ?? this.id,
//         transactionDate: transactionDate ?? this.transactionDate,
//         partyName: partyName ?? this.partyName,
//         referenceNo: referenceNo ?? this.referenceNo,
//         type: type ?? this.type,
//         creditAmount: creditAmount ?? this.creditAmount,
//         debitAmount: debitAmount ?? this.debitAmount,
//       );

//   factory Money.fromJson(String str) => Money.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Money.fromMap(Map<String, dynamic> json) => Money(
//     id: json["_id"],
//     transactionDate: json["transactionDate"] == null ? null : DateTime.parse(json["transactionDate"]),
//     partyName: json["partyName"],
//     referenceNo: json["referenceNo"],
//     type: json["type"],
//     creditAmount: json["credit_Amount"],
//     debitAmount: json["debit_Amount"],
//   );

//   Map<String, dynamic> toMap() => {
//     "_id": id,
//     "transactionDate": transactionDate?.toIso8601String(),
//     "partyName": partyName,
//     "referenceNo": referenceNo,
//     "type": type,
//     "credit_Amount": creditAmount,
//     "debit_Amount": debitAmount,
//   };
// }

import 'dart:convert';

class CashFlowReportModel {
  List<Money>? moneyIn;
  List<Money>? moneyOut;
  num? runningCashInHand;
  HeaderData? headerdata;

  CashFlowReportModel({
    this.moneyIn,
    this.moneyOut,
    this.runningCashInHand,
    this.headerdata,
  });

  CashFlowReportModel copyWith({
    List<Money>? moneyIn,
    List<Money>? moneyOut,
    num? runningCashInHand,
    HeaderData? headerdata,
  }) =>
      CashFlowReportModel(
        moneyIn: moneyIn ?? this.moneyIn,
        moneyOut: moneyOut ?? this.moneyOut,
        runningCashInHand: runningCashInHand ?? this.runningCashInHand,
        headerdata: headerdata ?? this.headerdata,
      );

  factory CashFlowReportModel.fromJson(String str) =>
      CashFlowReportModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CashFlowReportModel.fromMap(Map<String, dynamic> json) =>
      CashFlowReportModel(
        moneyIn: json["moneyIn"] == null
            ? []
            : List<Money>.from(json["moneyIn"]!.map((x) => Money.fromMap(x))),
        moneyOut: json["moneyOut"] == null
            ? []
            : List<Money>.from(json["moneyOut"]!.map((x) => Money.fromMap(x))),
        runningCashInHand: json["runningCashInHand"],
        headerdata: json['headerData'] != null
            ? HeaderData.fromJson(json['headerData'])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "moneyIn": moneyIn == null
            ? []
            : List<dynamic>.from(moneyIn!.map((x) => x.toMap())),
        "moneyOut": moneyOut == null
            ? []
            : List<dynamic>.from(moneyOut!.map((x) => x.toMap())),
        "runningCashInHand": runningCashInHand,
      };
}

class Money {
  String? id;
  DateTime? transactionDate;
  String? partyName;
  String? referenceNo;
  String? type;
  num? creditAmount;
  num? debitAmount;

  Money({
    this.id,
    this.transactionDate,
    this.partyName,
    this.referenceNo,
    this.type,
    this.creditAmount,
    this.debitAmount,
  });

  Money copyWith({
    String? id,
    DateTime? transactionDate,
    String? partyName,
    String? referenceNo,
    String? type,
    num? creditAmount,
    num? debitAmount,
  }) =>
      Money(
        id: id ?? this.id,
        transactionDate: transactionDate ?? this.transactionDate,
        partyName: partyName ?? this.partyName,
        referenceNo: referenceNo ?? this.referenceNo,
        type: type ?? this.type,
        creditAmount: creditAmount ?? this.creditAmount,
        debitAmount: debitAmount ?? this.debitAmount,
      );

  factory Money.fromJson(String str) => Money.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Money.fromMap(Map<String, dynamic> json) => Money(
        id: json["_id"],
        transactionDate: json["transactionDate"] == null
            ? null
            : DateTime.parse(json["transactionDate"]),
        partyName: json["partyName"],
        referenceNo: json["referenceNo"],
        type: json["type"],
        creditAmount: json["credit_Amount"],
        debitAmount: json["debit_Amount"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "transactionDate": transactionDate?.toIso8601String(),
        "partyName": partyName,
        "referenceNo": referenceNo,
        "type": type,
        "credit_Amount": creditAmount,
        "debit_Amount": debitAmount,
      };
}

class HeaderData {
  num? closingCash;
  num? openingCash;
  num? totalMoneyIn;
  num? totalMoneyOut;

  HeaderData(
      {this.closingCash,
      this.openingCash,
      this.totalMoneyIn,
      this.totalMoneyOut});

  factory HeaderData.fromJson(Map<String, dynamic> json) {
    return HeaderData(
      closingCash: json['closingCash'],
      openingCash: json['openingCash'],
      totalMoneyIn: json['totalMoneyIn'],
      totalMoneyOut: json['totalMoneyOut'],
    );
  }
}
