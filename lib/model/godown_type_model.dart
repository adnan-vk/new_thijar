class GodownTypeModel {
  String? value;

  GodownTypeModel({this.value});

  factory GodownTypeModel.fromJson(Map<String, dynamic> json) {
    return GodownTypeModel(
      value: json['value'],
    );
  }
}
