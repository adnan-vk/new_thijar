import 'dart:convert';

class ItemModelOneObject {
  Discount? discount;
  Stock? stock;
  UnitConversion? unitConversion;
  String? id;
  String? type;
  String? itemName;
  String? itemHsn;
  List<dynamic>? category;
  String? itemCode;
  Unit? unit;
  int? mrp;
  int? salePrice;
  bool? salePriceIncludesTax;
  int? purchasePrice;
  bool? purchasePriceIncludesTax;
  TaxRate? taxRate;
  List<dynamic>? image;
  bool? isActive;
  String? createdBy;
  int? v;

  ItemModelOneObject({
    this.discount,
    this.stock,
    this.unitConversion,
    this.id,
    this.type,
    this.itemName,
    this.itemHsn,
    this.category,
    this.itemCode,
    this.unit,
    this.mrp,
    this.salePrice,
    this.salePriceIncludesTax,
    this.purchasePrice,
    this.purchasePriceIncludesTax,
    this.taxRate,
    this.image,
    this.isActive,
    this.createdBy,
    this.v,
  });

  ItemModelOneObject copyWith({
    Discount? discount,
    Stock? stock,
    String? id,
    String? type,
    String? itemName,
    String? itemHsn,
    List<dynamic>? category,
    String? itemCode,
    Unit? unit,
    int? mrp,
    int? salePrice,
    bool? salePriceIncludesTax,
    int? purchasePrice,
    bool? purchasePriceIncludesTax,
    TaxRate? taxRate,
    List<dynamic>? image,
    bool? isActive,
    String? createdBy,
    int? v,
  }) =>
      ItemModelOneObject(
        discount: discount ?? this.discount,
        stock: stock ?? this.stock,
        id: id ?? this.id,
        type: type ?? this.type,
        itemName: itemName ?? this.itemName,
        itemHsn: itemHsn ?? this.itemHsn,
        category: category ?? this.category,
        itemCode: itemCode ?? this.itemCode,
        unit: unit ?? this.unit,
        mrp: mrp ?? this.mrp,
        salePrice: salePrice ?? this.salePrice,
        salePriceIncludesTax: salePriceIncludesTax ?? this.salePriceIncludesTax,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        purchasePriceIncludesTax:
            purchasePriceIncludesTax ?? this.purchasePriceIncludesTax,
        taxRate: taxRate ?? this.taxRate,
        image: image ?? this.image,
        isActive: isActive ?? this.isActive,
        createdBy: createdBy ?? this.createdBy,
        v: v ?? this.v,
      );

  String toJson() => json.encode(toMap());

  factory ItemModelOneObject.fromJson(Map<String, dynamic> json) =>
      ItemModelOneObject(
        discount: json["discount"] == null
            ? null
            : Discount.fromMap(json["discount"]),
        stock: json["stock"] == null ? null : Stock.fromMap(json["stock"]),
        unitConversion: json["unitConversion"] == null
            ? null
            : UnitConversion.fromMap(json["unitConversion"]),
        id: json["_id"],
        type: json["type"],
        itemName: json["itemName"],
        itemHsn: json["itemHsn"],
        category: json["category"] == null
            ? []
            : List<dynamic>.from(json["category"]!.map((x) => x)),
        itemCode: json["itemCode"],
        unit: json["unit"] == null ? null : Unit.fromMap(json["unit"]),
        mrp: json["mrp"],
        salePrice: json["salePrice"],
        salePriceIncludesTax: json["salePriceIncludesTax"],
        purchasePrice: json["purchasePrice"],
        purchasePriceIncludesTax: json["purchasePriceIncludesTax"],
        taxRate:
            json["taxRate"] == null ? null : TaxRate.fromMap(json["taxRate"]),
        image: json["image"] == null
            ? []
            : List<dynamic>.from(json["image"]!.map((x) => x)),
        isActive: json["isActive"],
        createdBy: json["createdBy"],
        v: json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "discount": discount?.toMap(),
        "stock": stock?.toMap(),
        "_id": id,
        "type": type,
        "itemName": itemName,
        "itemHsn": itemHsn,
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "itemCode": itemCode,
        "unit": unit,
        "mrp": mrp,
        "salePrice": salePrice,
        "salePriceIncludesTax": salePriceIncludesTax,
        "purchasePrice": purchasePrice,
        "purchasePriceIncludesTax": purchasePriceIncludesTax,
        "taxRate": taxRate?.toMap(),
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "isActive": isActive,
        "createdBy": createdBy,
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

  Discount copyWith({
    int? value,
    String? type,
  }) =>
      Discount(
        value: value ?? this.value,
        type: type ?? this.type,
      );

  factory Discount.fromJson(String str) => Discount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Discount.fromMap(Map<String, dynamic> json) => Discount(
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "type": type,
      };
}

class Stock {
  dynamic openingQuantity;
  int? saleQuantity;
  int? totalQuantity;
  dynamic price;
  dynamic minStockToMaintain;
  String? location;
  int? purchaseQuantity;
  DateTime? lastUpdated;

  Stock({
    this.openingQuantity,
    this.saleQuantity,
    this.totalQuantity,
    this.price,
    this.minStockToMaintain,
    this.location,
    this.purchaseQuantity,
    this.lastUpdated,
  });

  Stock copyWith({
    dynamic openingQuantity,
    int? saleQuantity,
    int? totalQuantity,
    dynamic price,
    dynamic minStockToMaintain,
    String? location,
    int? purchaseQuantity,
    DateTime? lastUpdated,
  }) =>
      Stock(
        openingQuantity: openingQuantity ?? this.openingQuantity,
        saleQuantity: saleQuantity ?? this.saleQuantity,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        price: price ?? this.price,
        minStockToMaintain: minStockToMaintain ?? this.minStockToMaintain,
        location: location ?? this.location,
        purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  factory Stock.fromJson(String str) => Stock.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Stock.fromMap(Map<String, dynamic> json) => Stock(
        openingQuantity: json["openingQuantity"],
        saleQuantity: json["saleQuantity"],
        totalQuantity: json["totalQuantity"],
        price: json["price"],
        minStockToMaintain: json["minStockToMaintain"],
        location: json["location"],
        purchaseQuantity: json["purchaseQuantity"],
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
      );

  Map<String, dynamic> toMap() => {
        "openingQuantity": openingQuantity,
        "saleQuantity": saleQuantity,
        "totalQuantity": totalQuantity,
        "price": price,
        "minStockToMaintain": minStockToMaintain,
        "location": location,
        "purchaseQuantity": purchaseQuantity,
        "lastUpdated": lastUpdated?.toIso8601String(),
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

  TaxRate copyWith({
    String? id,
    String? taxType,
    String? rate,
  }) =>
      TaxRate(
        id: id ?? this.id,
        taxType: taxType ?? this.taxType,
        rate: rate ?? this.rate,
      );

  factory TaxRate.fromJson(String str) => TaxRate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaxRate.fromMap(Map<String, dynamic> json) => TaxRate(
        id: json["_id"],
        taxType: json["taxType"],
        rate: json["rate"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "taxType": taxType,
        "rate": rate,
      };
}

class UnitConversion {
  BaseUnit? baseUnit;
  BaseUnit? secondaryUnit;
  int? conversionRate;

  UnitConversion({
    this.baseUnit,
    this.secondaryUnit,
    this.conversionRate,
  });

  factory UnitConversion.fromMap(Map<String, dynamic> json) => UnitConversion(
        baseUnit: json['baseUnit'] == null
            ? null
            : BaseUnit.fromMap(json['baseUnit']),
        secondaryUnit: json['secondaryUnit'] == null
            ? null
            : BaseUnit.fromMap(json['secondaryUnit']),
        conversionRate: json['conversionRate'],
      );
}

class BaseUnit {
  String? id;
  String? name;
  String? shortName;

  BaseUnit({
    this.id,
    this.name,
    this.shortName,
  });

  factory BaseUnit.fromMap(Map<String, dynamic> json) => BaseUnit(
        id: json['_id'],
        name: json['name'],
        shortName: json['shortName'],
      );
}

class Unit {
  String? id;
  String? name;
  String? shortName;

  Unit({this.id, this.name, this.shortName});

  factory Unit.fromMap(Map<String, dynamic> json) => Unit(
        id: json["_id"],
        name: json["name"],
        shortName: json["shortName"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "shortName": shortName,
      };
}
