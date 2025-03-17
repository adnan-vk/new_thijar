class PrefixModel {
  String? prefix;

  PrefixModel({this.prefix});

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
    };
  }
}
