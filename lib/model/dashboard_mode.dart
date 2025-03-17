//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  String? status;
  Data? data;

  DashBoardModel({
    this.status,
    this.data,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? youllGet;
  String? saleBalanceDue;
  String? purchaseBalanceDue;
  String? youllPay;
  Inventory? inventory;
  OpenSaleTransactions? openSaleTransactions;
  num? totalExpenseAMount;
  num? netProfit;
  num? netLoss;
  num? totalCashInHand;
  Data({
    this.youllGet,
    this.youllPay,
    this.inventory,
    this.openSaleTransactions,
    this.purchaseBalanceDue,
    this.saleBalanceDue,
    this.totalExpenseAMount,
    this.netLoss,
    this.netProfit,
    this.totalCashInHand,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        saleBalanceDue: json["saleBalanceDue"],
        purchaseBalanceDue: json["purchaseBalanceDue"],
        youllGet: json["youllGet"],
        youllPay: json["youllPay"],
        totalCashInHand: json["totalCashInHand"],
        inventory: json["inventory"] == null
            ? null
            : Inventory.fromJson(json["inventory"]),
        openSaleTransactions: json["openSaleTransactions"] == null
            ? null
            : OpenSaleTransactions.fromJson(json["openSaleTransactions"]),
        totalExpenseAMount: json['totalExpenseAMount'],
        netLoss: json['netLoss'],
        netProfit: json['netProfit'],
      );

  Map<String, dynamic> toJson() => {
        "saleBalanceDue": saleBalanceDue,
        "purchaseBalanceDue": purchaseBalanceDue,
        "youllGet": youllGet,
        "youllPay": youllPay,
        "inventory": inventory?.toJson(),
        "openSaleTransactions": openSaleTransactions?.toJson(),
        "totalExpenseAMount": totalExpenseAMount,
        "netLoss": netLoss,
        "netProfit": netProfit,
        "totalCashInHand": totalCashInHand,
      };
}

class Inventory {
  int? stockValue;
  int? noOfItems;
  int? lowStockItems;

  Inventory({
    this.stockValue,
    this.noOfItems,
    this.lowStockItems,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        stockValue: json["stockValue"],
        noOfItems: json["noOfItems"],
        lowStockItems: json["lowStockItems"],
      );

  Map<String, dynamic> toJson() => {
        "stockValue": stockValue,
        "noOfItems": noOfItems,
        "lowStockItems": lowStockItems,
      };
}

class OpenSaleTransactions {
  OpenSaleTransactions();

  factory OpenSaleTransactions.fromJson(Map<String, dynamic> json) =>
      OpenSaleTransactions();

  Map<String, dynamic> toJson() => {};
}
