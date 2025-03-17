class SaleModel {
  int id;
  String? billName;
  String? billNum;
  String? billDate;
  SaleModel({required this.id, this.billName, this.billNum, this.billDate});
  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        id: json['id'],
        billName: json['billName'],
        billNum: json['billNum'],
        billDate: json['billDate'],
      );
  Map<String, dynamic> toJson() => _$SaleModelToJson(this);
  Map<String, dynamic> _$SaleModelToJson(SaleModel instance) =>
      <String, dynamic>{
        'id': instance.id,
        'billName': instance.billName,
        'billNum': instance.billNum,
        'billDate': instance.billDate,
      };
}
