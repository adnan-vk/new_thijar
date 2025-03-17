import 'dart:convert';

SaleDetailModel saleDetailModelFromJson(String str) =>
    SaleDetailModel.fromJson(json.decode(str));

String saleDetailModelToJson(SaleDetailModel data) =>
    json.encode(data.toJson());

class SaleDetailModel {
  String? id;
  String? invoiceNo;
  String? invoiceType;
  String? description;
  String? invoiceDate;
  String? billNo;
  String? phoneNo;
  String? party;
  String? partyName;
  String? document;
  String? image;
  List<PaymentMethod>? paymentMethod;
  dynamic bankName;
  List<Item>? items;
  num? roundOff;
  num? totalAmount;
  num? receivedAmount;
  num? balanceAmount;
  String? createdBy;
  String? source;
  String? createdAt;
  String? updatedAt;
  int? v;

  SaleDetailModel({
    this.id,
    this.invoiceNo,
    this.invoiceType,
    this.invoiceDate,
    this.party,
    this.partyName,
    this.document,
    this.image,
    this.paymentMethod,
    this.description,
    this.billNo,
    this.phoneNo,
    this.bankName,
    this.items,
    this.roundOff,
    this.totalAmount,
    this.receivedAmount,
    this.balanceAmount,
    this.createdBy,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) =>
      SaleDetailModel(
        invoiceNo: json["invoiceNo"] ?? "",
        invoiceType: json["invoiceType"] ?? "",
        invoiceDate: json["invoiceDate"],
        billNo: json["billNo"],
        phoneNo: json["phoneNo"],
        description: json["description"],
        party: json["party"],
        partyName: json["partyName"],
        document: json["document"],
        image: json["image"],
        paymentMethod: json["paymentMethod"] == null
            ? []
            : List<PaymentMethod>.from(
                json["paymentMethod"]!.map((x) => PaymentMethod.fromMap(x))),
        bankName: json["bankName"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        roundOff: json["roundOff"],
        totalAmount: json["totalAmount"]?.toDouble(),
        receivedAmount: json["receivedAmount"]?.toDouble(),
        balanceAmount: json["balanceAmount"],
        createdBy: json["createdBy"],
        source: json["source"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "invoiceType": invoiceType,
        "invoiceDate": invoiceDate,
        "billNo": billNo,
        "party": party,
        "partyName": partyName,
        "document": document,
        "image": image,
        "paymentMethod": paymentMethod == null
            ? []
            : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
        "bankName": bankName,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "roundOff": roundOff,
        "totalAmount": totalAmount,
        "receivedAmount": receivedAmount,
        "balanceAmount": balanceAmount,
        "createdBy": createdBy,
        "source": source,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class PaymentMethod {
  String? method;
  num? amount;
  String? referenceNo;
  dynamic chequeId;
  String? id;

  PaymentMethod({
    this.method,
    this.amount,
    this.referenceNo,
    this.chequeId,
    this.id,
  });

  PaymentMethod copyWith({
    String? method,
    double? amount,
    String? referenceNo,
    dynamic chequeId,
    String? id,
  }) =>
      PaymentMethod(
        method: method ?? this.method,
        amount: amount ?? this.amount,
        referenceNo: referenceNo ?? this.referenceNo,
        chequeId: chequeId ?? this.chequeId,
        id: id ?? this.id,
      );

  factory PaymentMethod.fromJson(String str) =>
      PaymentMethod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
        method: json["method"],
        amount: json["amount"]?.toDouble(),
        referenceNo: json["referenceNo"],
        chequeId: json["chequeId"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "method": method,
        "amount": amount,
        "referenceNo": referenceNo,
        "chequeId": chequeId,
        "_id": id,
      };
}

class Item {
  ItemId? itemId;
  num? quantity;
  Unit? unit;
  num? price;
  num? discountPercent;
  TaxPercent? taxPercent;
  num? finalAmount;
  String? id;

  Item({
    this.itemId,
    this.quantity,
    this.unit,
    this.price,
    this.discountPercent,
    this.taxPercent,
    this.finalAmount,
    this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["itemId"] == null ? null : ItemId.fromJson(json["itemId"]),
        quantity: json["quantity"],
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
        price: json["price"],
        discountPercent: json["discountPercent"],
        taxPercent: json["taxPercent"] == null
            ? null
            : TaxPercent.fromJson(json["taxPercent"]),
        finalAmount: json["finalAmount"]?.toDouble(),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId?.toJson(),
        "quantity": quantity,
        "unit": unit?.toJson(),
        "price": price,
        "discountPercent": discountPercent,
        "taxPercent": taxPercent?.toJson(),
        "finalAmount": finalAmount,
        "_id": id,
      };
}

class ItemId {
  String? itemName;

  ItemId({
    this.itemName,
  });

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        itemName: json["itemName"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
      };
}

class TaxPercent {
  String? id;
  String? taxType;
  String? rate;

  TaxPercent({
    this.id,
    this.taxType,
    this.rate,
  });

  factory TaxPercent.fromJson(Map<String, dynamic> json) => TaxPercent(
        id: json["_id"],
        taxType: json["taxType"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "taxType": taxType,
        "rate": rate,
      };
}

class Unit {
  String? name;

  Unit({
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
