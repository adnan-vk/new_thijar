import 'dart:convert';

SaleDetailModelEdit saleDetailModelEditFromJson(String str) =>
    SaleDetailModelEdit.fromJson(json.decode(str));

String saleDetailModelEditToJson(SaleDetailModelEdit data) =>
    json.encode(data.toJson());

class SaleDetailModelEdit {
  String? invoiceNo;
  Godown? godown; // Updated from String? to Godown?
  String? phoneNo;
  String? invoiceType;
  DateTime? invoiceDate;
  String? party;
  String? partyName;
  String? billingName;
  dynamic stateOfSupply;
  String? billingAddress;
  String? description;
  String? document;
  String? image;
  List<PaymentMethod>? paymentMethod;
  List<Item>? items;
  int? roundOff;
  double? totalAmount;
  double? receivedAmount;
  double? balanceAmount;
  String? createdBy;
  String? source;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  SaleDetailModelEdit({
    this.invoiceNo,
    this.godown,
    this.phoneNo,
    this.invoiceType,
    this.invoiceDate,
    this.party,
    this.partyName,
    this.billingName,
    this.stateOfSupply,
    this.billingAddress,
    this.description,
    this.document,
    this.image,
    this.paymentMethod,
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

  factory SaleDetailModelEdit.fromJson(Map<String, dynamic> json) =>
      SaleDetailModelEdit(
        invoiceNo: json["invoiceNo"],
        godown: json["godown"] == null ? null : Godown.fromJson(json["godown"]),
        phoneNo: json["phoneNo"],
        invoiceType: json["invoiceType"],
        invoiceDate: json["invoiceDate"] == null
            ? null
            : DateTime.parse(json["invoiceDate"]),
        party: json["party"],
        partyName: json["partyName"],
        billingName: json["billingName"],
        stateOfSupply: json["stateOfSupply"],
        billingAddress: json["billingAddress"],
        description: json["description"],
        document: json["document"],
        image: json["image"],
        paymentMethod: json["paymentMethod"] == null
            ? []
            : List<PaymentMethod>.from(
                json["paymentMethod"]!.map((x) => PaymentMethod.fromJson(x))),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        roundOff: json["roundOff"],
        totalAmount: json["totalAmount"]?.toDouble(),
        receivedAmount: json["receivedAmount"]?.toDouble(),
        balanceAmount: json["balanceAmount"]?.toDouble(),
        createdBy: json["createdBy"],
        source: json["source"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "godown": godown?.toJson(),
        "phoneNo": phoneNo,
        "invoiceType": invoiceType,
        "invoiceDate": invoiceDate?.toIso8601String(),
        "party": party,
        "partyName": partyName,
        "billingName": billingName,
        "stateOfSupply": stateOfSupply,
        "billingAddress": billingAddress,
        "description": description,
        "document": document,
        "image": image,
        "paymentMethod": paymentMethod == null
            ? []
            : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "roundOff": roundOff,
        "totalAmount": totalAmount,
        "receivedAmount": receivedAmount,
        "balanceAmount": balanceAmount,
        "createdBy": createdBy,
        "source": source,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Godown {
  String? id;
  String? name;

  Godown({
    this.id,
    this.name,
  });

  factory Godown.fromJson(Map<String, dynamic> json) => Godown(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Item {
  ItemId? itemId;
  int? quantity;
  Unit? unit;
  int? price;
  int? discountPercent;
  num? taxAmount;
  TaxPercent? taxPercent;
  double? finalAmount;
  String? id;
  int? mrp; // Added since it's present in the API response

  Item({
    this.itemId,
    this.quantity,
    this.unit,
    this.price,
    this.discountPercent,
    this.taxAmount,
    this.taxPercent,
    this.finalAmount,
    this.id,
    this.mrp,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["itemId"] == null ? null : ItemId.fromJson(json["itemId"]),
        quantity: json["quantity"],
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
        price: json["price"],
        mrp: json["mrp"],
        discountPercent: json["discountPercent"],
        taxAmount: json["taxAmount"],
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
        "mrp": mrp,
        "discountPercent": discountPercent,
        "taxAmount": taxAmount,
        "taxPercent": taxPercent?.toJson(),
        "finalAmount": finalAmount,
        "_id": id,
      };
}

class ItemId {
  String? itemName;
  String? itemHsn; // Added since it's present in the API response

  ItemId({
    this.itemName,
    this.itemHsn,
  });

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        itemName: json["itemName"],
        itemHsn: json["itemHsn"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemHsn": itemHsn,
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

class PaymentMethod {
  dynamic chequeId;
  String? method;
  double? amount;
  dynamic bankName;
  String? referenceNo;
  String? id;

  PaymentMethod({
    this.chequeId,
    this.method,
    this.amount,
    this.bankName,
    this.referenceNo,
    this.id,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        chequeId: json["chequeId"],
        method: json["method"],
        amount: json["amount"]?.toDouble(),
        bankName: json["bankName"],
        referenceNo: json["referenceNo"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "chequeId": chequeId,
        "method": method,
        "amount": amount,
        "bankName": bankName,
        "referenceNo": referenceNo,
        "_id": id,
      };
}
