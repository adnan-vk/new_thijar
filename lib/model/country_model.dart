import 'dart:convert';

List<CountryModel> CountryModelFromJson(String str) => List<CountryModel>.from(
    json.decode(str).map((x) => CountryModel.fromJson(x)));

String CountryModelToJson(List<CountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  String? id;
  String? code;
  String? name;

  CountryModel({
    this.id,
    this.code,
    this.name,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["_id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "name": name,
      };
}
