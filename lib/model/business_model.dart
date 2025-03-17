class AddBusinesskModel {
  String? businessName;
  String? gstIn;
  String? email;
  String? businessAddress;
  String? pincode;
  String? businessDescription;
  String? state;
  String? businessType;
  String? businessCategory;

  AddBusinesskModel({
    this.businessName,
    this.gstIn,
    this.email,
    this.businessAddress,
    this.pincode,
    this.businessDescription,
    this.state,
    this.businessType,
    this.businessCategory,
  });

  factory AddBusinesskModel.fromJson(Map<String, dynamic> json) {
    return AddBusinesskModel(
      businessName: json['business_name'],
      gstIn: json['gst_in'],
      email: json['email'],
      businessAddress: json['business_address'],
      pincode: json['pincode'],
      businessDescription: json['business_description'],
      state: json['state'],
      businessType: json['business_type'],
      businessCategory: json['business_category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'gst_in': gstIn,
      'email': email,
      'business_address': businessAddress,
      'pincode': pincode,
      'business_description': businessDescription,
      'state': state,
      'business_type': businessType,
      'business_category': businessCategory,
    };
  }
}
