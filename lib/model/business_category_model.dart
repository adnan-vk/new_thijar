import 'dart:convert';

List<BusinessCategoryModel> BusinessCategoryModelFromJson(String str) =>
    List<BusinessCategoryModel>.from(
        json.decode(str).map((x) => BusinessCategoryModel.fromJson(x)));

String BusinessCategoryModelToJson(List<BusinessCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessCategoryModel {
  String? id;
  String? value;
  String? name;

  BusinessCategoryModel({
    this.id,
    this.value,
    this.name,
  });

  factory BusinessCategoryModel.fromJson(Map<String, dynamic> json) =>
      BusinessCategoryModel(
        id: json["_id"],
        value: json["value"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
        "name": name,
      };
}
