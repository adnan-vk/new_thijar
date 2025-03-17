class CompanyModel {
  String? id;
  String? companyName;
  String? phoneNo;
  bool? isSelected;
  String? email;
  String? businessProfileId;

  CompanyModel({
    this.businessProfileId,
    this.companyName,
    this.email,
    this.id,
    this.phoneNo,
    this.isSelected,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      businessProfileId: json['businessProfileId'],
      companyName: json['companyName'],
      email: json['email'],
      id: json['_id'],
      phoneNo: json['phoneNo'],
      isSelected: json['IsSelected'],
    );
  }
}
