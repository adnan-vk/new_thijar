// To parse this JSON data, do
//
//     final itemBarList = itemBarListFromJson(jsonString);

import 'dart:convert';

List<ItemBarList> itemBarListFromJson(String str) => List<ItemBarList>.from(
    json.decode(str).map((x) => ItemBarList.fromJson(x)));

String itemBarListToJson(List<ItemBarList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemBarList {
  Discount? discount;
  Stock? stock;
  UnitConversion? unitConversion;
  num? mrp;
  String? id;
  String? itemName;
  List<Category>? category;
  Unit? unit;
  num? salePrice;
  bool? salePriceIncludesTax;
  num? purchasePrice;
  bool? purchasePriceIncludesTax;
  TaxRate? taxRate;
  List<dynamic>? image;
  bool? isActive;
  String? createdBy;
  String? v;
  String? itemCode;
  String? itemHsn;

  ItemBarList({
    this.discount,
    this.stock,
    this.unitConversion,
    this.id,
    this.mrp,
    this.itemName,
    this.category,
    this.unit,
    this.salePrice,
    this.salePriceIncludesTax,
    this.purchasePrice,
    this.purchasePriceIncludesTax,
    this.taxRate,
    this.image,
    this.isActive,
    this.createdBy,
    this.v,
    this.itemCode,
    this.itemHsn,
  });

  factory ItemBarList.fromJson(Map<String, dynamic> json) => ItemBarList(
        discount: json["discount"] == null
            ? null
            : Discount.fromJson(json["discount"]),
        stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
        unitConversion: json["unitConversion"] == null
            ? null
            : UnitConversion.fromJson(json["unitConversion"]),
        id: json["_id"].toString(),
        itemName: json["itemName"].toString(),
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"]!.map((x) => Category.fromJson(x))),
        unit: json["unit"] == null
            ? null
            : json["unit"] is String
                ? Unit(id: json["unit"])
                : Unit.fromJson(json["unit"]),
        salePrice: json["salePrice"],
        salePriceIncludesTax: json["salePriceIncludesTax"],
        mrp: json["mrp"],
        purchasePrice: json["purchasePrice"],
        purchasePriceIncludesTax: json["purchasePriceIncludesTax"],
        taxRate:
            json["taxRate"] == null ? null : TaxRate.fromJson(json["taxRate"]),
        image: json["image"] == null
            ? []
            : List<dynamic>.from(json["image"]!.map((x) => x)),
        isActive: json["isActive"],
        createdBy: json["createdBy"],
        v: json["__v"].toString(),
        itemCode: json["itemCode"].toString(),
        itemHsn: json["itemHsn"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "discount": discount?.toJson(),
        "stock": stock?.toJson(),
        "unitConversion": unitConversion?.toJson(),
        "_id": id,
        "mrp": mrp,
        "itemName": itemName,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
        "unit": unit,
        "salePrice": salePrice,
        "salePriceIncludesTax": salePriceIncludesTax,
        "purchasePrice": purchasePrice,
        "purchasePriceIncludesTax": purchasePriceIncludesTax,
        "taxRate": taxRate?.toJson(),
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "isActive": isActive,
        "createdBy": createdBy,
        "__v": v,
        "itemCode": itemCode,
        "itemHsn": itemHsn,
      };
}

class TaxRate {
  String? id;
  String? taxType;
  String? rate;

  TaxRate({
    this.id,
    this.taxType,
    this.rate,
  });

  factory TaxRate.fromJson(Map<String, dynamic> json) => TaxRate(
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

class Category {
  String? id;
  String? name;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Category({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        createdBy: json["createdBy"],
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
        "name": name,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Discount {
  int? value;
  String? type;

  Discount({
    this.value,
    this.type,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
      };
}

class Unit {
  String? id;
  String? name;
  String? shortName;

  Unit({
    this.id,
    this.name,
    this.shortName,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["_id"].toString(),
        name: json["name"].toString(),
        shortName: json["shortName"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "shortName": shortName,
      };
}

class Stock {
  int? price;
  int? openingQuantity;
  int? saleQuantity;
  int? purchaseQuantity;
  int? totalQuantity;
  int? minStockToMaintain;
  String? location;
  DateTime? lastUpdated;

  Stock({
    this.price,
    this.openingQuantity,
    this.saleQuantity,
    this.purchaseQuantity,
    this.totalQuantity,
    this.minStockToMaintain,
    this.location,
    this.lastUpdated,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        price: json["price"],
        openingQuantity: json["openingQuantity"],
        saleQuantity: json["saleQuantity"],
        purchaseQuantity: json["purchaseQuantity"],
        totalQuantity: json["totalQuantity"],
        minStockToMaintain: json["minStockToMaintain"],
        location: json["location"],
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "openingQuantity": openingQuantity,
        "saleQuantity": saleQuantity,
        "purchaseQuantity": purchaseQuantity,
        "totalQuantity": totalQuantity,
        "minStockToMaintain": minStockToMaintain,
        "location": location,
        "lastUpdated": lastUpdated?.toIso8601String(),
      };
}

class UnitConversion {
  String? id;
  Unit? baseUnit;
  Unit? secondaryUnit;
  num? conversionRate;

  UnitConversion(
      {this.id, this.baseUnit, this.secondaryUnit, this.conversionRate});

  factory UnitConversion.fromJson(Map<String, dynamic> json) => UnitConversion(
        id: json["_id"],
        baseUnit: Unit.fromJson(json["baseUnit"]),
        secondaryUnit: Unit.fromJson(json["secondaryUnit"]),
        conversionRate: json["conversionRate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "baseUnit": baseUnit?.toJson(),
        "secondaryUnit": secondaryUnit?.toJson(),
        "conversionRate": conversionRate,
      };
}
