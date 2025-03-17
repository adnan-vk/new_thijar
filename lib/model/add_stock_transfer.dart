import 'dart:convert';

class AddStockTransfer {
  DateTime? transferDate;
  String? fromGodown;
  String? toGodown;
  List<AddStockItem>? items;

  AddStockTransfer({
    this.transferDate,
    this.fromGodown,
    this.toGodown,
    this.items,
  });

  AddStockTransfer copyWith({
    DateTime? transferDate,
    String? fromGodown,
    String? toGodown,
    List<AddStockItem>? items,
  }) =>
      AddStockTransfer(
        transferDate: transferDate ?? this.transferDate,
        fromGodown: fromGodown ?? this.fromGodown,
        toGodown: toGodown ?? this.toGodown,
        items: items ?? this.items,
      );

  factory AddStockTransfer.fromJson(String str) =>
      AddStockTransfer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddStockTransfer.fromMap(Map<String, dynamic> json) =>
      AddStockTransfer(
        transferDate: json["transferDate"] == null
            ? null
            : DateTime.parse(json["transferDate"]),
        fromGodown: json["fromGodown"],
        toGodown: json["toGodown"],
        items: json["items"] == null
            ? []
            : List<AddStockItem>.from(
                json["items"]!.map((x) => AddStockItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "transferDate":
            "${transferDate!.year.toString().padLeft(4, '0')}-${transferDate!.month.toString().padLeft(2, '0')}-${transferDate!.day.toString().padLeft(2, '0')}",
        "fromGodown": fromGodown,
        "toGodown": toGodown,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class AddStockItem {
  String? productId;
  String? name;
  int? quantity;

  AddStockItem({
    this.name,
    this.productId,
    this.quantity,
  });

  AddStockItem copyWith({
    String? productId,
    String? name,
    int? quantity,
  }) =>
      AddStockItem(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );

  factory AddStockItem.fromJson(String str) =>
      AddStockItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddStockItem.fromMap(Map<String, dynamic> json) => AddStockItem(
        productId: json["productId"],
        quantity: json["quantity"],
        name: "",
      );

  Map<String, dynamic> toMap() => {
        "productId": productId,
        "quantity": quantity,
      };
}
