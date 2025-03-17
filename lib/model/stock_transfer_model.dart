import 'dart:convert';

class StockTransferData {
  String? message;
  List<StockTransferModel>? data;

  StockTransferData({
    this.message,
    this.data,
  });

  StockTransferData copyWith({
    String? message,
    List<StockTransferModel>? data,
  }) =>
      StockTransferData(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StockTransferData.fromJson(String str) =>
      StockTransferData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StockTransferData.fromMap(Map<String, dynamic> json) =>
      StockTransferData(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StockTransferModel>.from(
                json["data"]!.map((x) => StockTransferModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class StockTransferModel {
  String? id;
  int? totalQuantity;
  String? transferDate;
  List<GodownDetail>? fromGodownDetails;
  List<GodownDetail>? toGodownDetails;
  int? totalItems;

  StockTransferModel({
    this.id,
    this.totalQuantity,
    this.transferDate,
    this.fromGodownDetails,
    this.toGodownDetails,
    this.totalItems,
  });

  StockTransferModel copyWith({
    String? id,
    int? totalQuantity,
    String? transferDate,
    List<GodownDetail>? fromGodownDetails,
    List<GodownDetail>? toGodownDetails,
    int? totalItems,
  }) =>
      StockTransferModel(
        id: id ?? this.id,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        transferDate: transferDate ?? this.transferDate,
        fromGodownDetails: fromGodownDetails ?? this.fromGodownDetails,
        toGodownDetails: toGodownDetails ?? this.toGodownDetails,
        totalItems: totalItems ?? this.totalItems,
      );

  factory StockTransferModel.fromJson(String str) =>
      StockTransferModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StockTransferModel.fromMap(Map<String, dynamic> json) =>
      StockTransferModel(
        id: json["_id"],
        totalQuantity: json["totalQuantity"],
        transferDate: json["transferDate"],
        fromGodownDetails: json["fromGodownDetails"] == null
            ? []
            : List<GodownDetail>.from(
                json["fromGodownDetails"]!.map((x) => GodownDetail.fromMap(x))),
        toGodownDetails: json["toGodownDetails"] == null
            ? []
            : List<GodownDetail>.from(
                json["toGodownDetails"]!.map((x) => GodownDetail.fromMap(x))),
        totalItems: json["totalItems"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "totalQuantity": totalQuantity,
        "transferDate": transferDate,
        "fromGodownDetails": fromGodownDetails == null
            ? []
            : List<dynamic>.from(fromGodownDetails!.map((x) => x.toMap())),
        "toGodownDetails": toGodownDetails == null
            ? []
            : List<dynamic>.from(toGodownDetails!.map((x) => x.toMap())),
        "totalItems": totalItems,
      };
}

class GodownDetail {
  String? id;
  String? name;

  GodownDetail({
    this.id,
    this.name,
  });

  GodownDetail copyWith({
    String? id,
    String? name,
  }) =>
      GodownDetail(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory GodownDetail.fromJson(String str) =>
      GodownDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GodownDetail.fromMap(Map<String, dynamic> json) => GodownDetail(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
      };
}
