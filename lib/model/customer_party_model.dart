import 'dart:convert';

List<CustomerPartyModelList> customerPartyModelListFromJson(String str) =>
    List<CustomerPartyModelList>.from(
        json.decode(str).map((x) => CustomerPartyModelList.fromJson(x)));

String customerPartyModelListToJson(List<CustomerPartyModelList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerPartyModelList {
  String? id;
  String? name;
  String? value;
  String? label;
  String? phoneNo;
  double? balance;
  bool? isReceivable;
  String? address;

  CustomerPartyModelList({
    this.id,
    this.name,
    this.phoneNo,
    this.value,
    this.label,
    this.balance,
    this.isReceivable,
    this.address,
  });

  factory CustomerPartyModelList.fromJson(Map<String, dynamic> json) =>
      CustomerPartyModelList(
        id: json["_id"],
        name: json["name"],
        phoneNo: json["phoneNo"],
        value: json["value"],
        label: json["label"],
        balance: json["balance"]?.toDouble(),
        isReceivable: json["isReceivable"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phoneNo": phoneNo,
        "value": value,
        "label": label,
        "balance": balance,
        "isReceivable": isReceivable,
        "address": address,
      };
}
