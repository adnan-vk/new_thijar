// To parse this JSON data, do
//
//     final itemSettingModel = itemSettingModelFromJson(jsonString);

import 'dart:convert';

ItemSettingModel itemSettingModelFromJson(String str) =>
    ItemSettingModel.fromJson(json.decode(str));

// String itemSettingModelToJson(ItemSettingModel data) =>
//     json.encode(data.toJson());

class ItemSettingModel {
  String? status;
  String? message;
  Data? data;

  ItemSettingModel({
    this.status,
    this.message,
    this.data,
  });

  factory ItemSettingModel.fromJson(Map<String, dynamic> json) =>
      ItemSettingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  String? id;
  bool? enableItem;
  String? whatDoYouSell;
  bool? enableItemCode;
  bool? stockMaintainance;
  bool? showLowStockDialog;
  bool? enableItemsUnit;
  bool? enableDefaultUnit;
  dynamic defaultUnit;
  bool? enableItemCategory;
  bool? enableItemwiseTax;
  bool? enableItemwiseDiscount;
  bool? enableWholeSalePrice;
  bool? enableGstPercent;
  bool? enableVatPercent;
  bool? enableItemDiscount;
  bool? enableItemHsn;
  bool? enableItemMrp;
  bool? enableItemScanner;
  String? createdBy;
  num? commonDecimalPlaces;
  num? quantityDecimalPlaces;
  int? v;

  Data({
    this.id,
    this.enableItem,
    this.whatDoYouSell,
    this.enableItemCode,
    this.stockMaintainance,
    this.showLowStockDialog,
    this.enableItemsUnit,
    this.enableDefaultUnit,
    this.defaultUnit,
    this.enableItemCategory,
    this.enableItemScanner,
    this.enableItemwiseTax,
    this.enableItemwiseDiscount,
    this.enableWholeSalePrice,
    this.enableGstPercent,
    this.enableVatPercent,
    this.enableItemDiscount,
    this.enableItemHsn,
    this.createdBy,
    this.enableItemMrp,
    this.commonDecimalPlaces,
    this.quantityDecimalPlaces,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        enableItem: json["enableItem"],
        whatDoYouSell: json["whatDoYouSell"],
        enableItemCode: json["enableItemCode"],
        stockMaintainance: json["stockMaintainance"],
        showLowStockDialog: json["showLowStockDialog"],
        enableItemsUnit: json["enableItemsUnit"],
        enableDefaultUnit: json["enableDefaultUnit"],
        defaultUnit: json["defaultUnit"],
        enableItemCategory: json["enableItemCategory"],
        enableItemwiseTax: json["enableItemwiseTax"],
        enableItemwiseDiscount: json["enableItemwiseDiscount"],
        enableWholeSalePrice: json["enableWholeSalePrice"],
        enableGstPercent: json["enableGstPercent"],
        enableVatPercent: json["enableVatPercent"],
        enableItemDiscount: json["enableItemDiscount"],
        enableItemHsn: json["enableItemHsn"],
        enableItemMrp: json["enableItemMrp"],
        createdBy: json["createdBy"],
        commonDecimalPlaces: json["commonDecimalPlaces"],
        quantityDecimalPlaces: json["quantityDecimalPlaces"],
        enableItemScanner: json['enableItemScanner'],
        v: json["__v"],
      );
}
