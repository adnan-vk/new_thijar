import 'dart:convert';

List<BusinessTypeModel> BusinessTypeModelFromJson(String str) =>
    List<BusinessTypeModel>.from(
        json.decode(str).map((x) => BusinessTypeModel.fromJson(x)));

String BusinessTypeModelToJson(List<BusinessTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessTypeModel {
  String? id;
  String? value;
  String? name;

  BusinessTypeModel({
    this.id,
    this.value,
    this.name,
  });

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) =>
      BusinessTypeModel(
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
