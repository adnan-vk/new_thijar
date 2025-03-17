import 'package:newthijar/model/unit_model.dart';

class ConversionReferenceModel {
  String? id;
  UnitModel? baseUnit;
  UnitModel? secondaryUnit;
  double? conversionRate;

  ConversionReferenceModel({
    this.id,
    this.baseUnit,
    this.secondaryUnit,
    this.conversionRate,
  });

  factory ConversionReferenceModel.fromJson(Map<String, dynamic> json) {
    return ConversionReferenceModel(
      id: json['_id'],
      baseUnit: json['baseUnit'] != null
          ? UnitModel.fromJson(json['baseUnit'])
          : null,
      secondaryUnit: json['secondaryUnit'] != null
          ? UnitModel.fromJson(json['secondaryUnit'])
          : null,
      conversionRate: (json['conversionRate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'baseUnit': baseUnit?.toJson(), // Now this works
      'secondaryUnit': secondaryUnit?.toJson(), // Now this works
      'conversionRate': conversionRate,
    };
  }
}
