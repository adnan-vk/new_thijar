import 'package:newthijar/model/conversion_reference_model.dart';

class UnitModel {
  String? id;
  String? name;
  String? shortName;
  List<ConversionReferenceModel>? conversionReferences; // Add this

  UnitModel({this.id, this.name, this.shortName, this.conversionReferences});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['_id'],
      name: json['name'],
      shortName: json['shortName'],
      conversionReferences: json['conversionReferences'] != null
          ? List<ConversionReferenceModel>.from(json['conversionReferences']
              .map((x) => ConversionReferenceModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'shortName': shortName,
      'conversionReferences':
          conversionReferences?.map((e) => e.toJson()).toList(),
    };
  }
}
