import 'dart:convert';

class StockTransferDetails {
  String? message;
  StockDetails? data;

  StockTransferDetails({
    this.message,
    this.data,
  });

  StockTransferDetails copyWith({
    String? message,
    StockDetails? data,
  }) =>
      StockTransferDetails(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StockTransferDetails.fromJson(String str) =>
      StockTransferDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StockTransferDetails.fromMap(Map<String, dynamic> json) =>
      StockTransferDetails(
        message: json["message"],
        data: json["data"] == null ? null : StockDetails.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
      };
}

class StockDetails {
  String? id;
  DateTime? transferDate;
  Godown? fromGodown;
  Godown? toGodown;
  List<Item>? items;
  int? totalQuantity;
  DateTime? createdAt;

  StockDetails({
    this.id,
    this.transferDate,
    this.fromGodown,
    this.toGodown,
    this.items,
    this.totalQuantity,
    this.createdAt,
  });

  StockDetails copyWith({
    String? id,
    DateTime? transferDate,
    Godown? fromGodown,
    Godown? toGodown,
    List<Item>? items,
    int? totalQuantity,
    DateTime? createdAt,
  }) =>
      StockDetails(
        id: id ?? this.id,
        transferDate: transferDate ?? this.transferDate,
        fromGodown: fromGodown ?? this.fromGodown,
        toGodown: toGodown ?? this.toGodown,
        items: items ?? this.items,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        createdAt: createdAt ?? this.createdAt,
      );

  factory StockDetails.fromJson(String str) =>
      StockDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StockDetails.fromMap(Map<String, dynamic> json) => StockDetails(
        id: json["_id"],
        transferDate: json["transferDate"] == null
            ? null
            : DateTime.parse(json["transferDate"]),
        fromGodown: json["fromGodown"] == null
            ? null
            : Godown.fromMap(json["fromGodown"]),
        toGodown:
            json["toGodown"] == null ? null : Godown.fromMap(json["toGodown"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromMap(x))),
        totalQuantity: json["totalQuantity"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "transferDate": transferDate?.toIso8601String(),
        "fromGodown": fromGodown?.toMap(),
        "toGodown": toGodown?.toMap(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
        "totalQuantity": totalQuantity,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Godown {
  String? id;
  String? name;

  Godown({
    this.id,
    this.name,
  });

  Godown copyWith({
    String? id,
    String? name,
  }) =>
      Godown(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Godown.fromJson(String str) => Godown.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Godown.fromMap(Map<String, dynamic> json) => Godown(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
      };
}

class Item {
  ProductId? productId;
  int? quantity;
  String? id;

  Item({
    this.productId,
    this.quantity,
    this.id,
  });

  Item copyWith({
    ProductId? productId,
    int? quantity,
    String? id,
  }) =>
      Item(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        id: id ?? this.id,
      );

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        productId: json["productId"] == null
            ? null
            : ProductId.fromMap(json["productId"]),
        quantity: json["quantity"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "productId": productId?.toMap(),
        "quantity": quantity,
        "_id": id,
      };
}

class ProductId {
  String? id;
  String? itemName;
  String? itemCode;

  ProductId({
    this.id,
    this.itemName,
    this.itemCode,
  });

  ProductId copyWith({
    String? id,
    String? itemName,
    String? itemCode,
  }) =>
      ProductId(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        itemCode: itemCode ?? this.itemCode,
      );

  factory ProductId.fromJson(String str) => ProductId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductId.fromMap(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        itemName: json["itemName"],
        itemCode: json["itemCode"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "itemName": itemName,
        "itemCode": itemCode,
      };
}
