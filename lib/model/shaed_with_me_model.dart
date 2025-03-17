class SharedWithMeModel {
  String? id;
  CompanyId? companyId;
  String? userId;
  String? phoneNo;
  String? userName;
  String? userRole;
  String? status;

  SharedWithMeModel({
    this.companyId,
    this.id,
    this.phoneNo,
    this.status,
    this.userId,
    this.userName,
    this.userRole,
  });

  factory SharedWithMeModel.fromJson(Map<String, dynamic> json) {
    return SharedWithMeModel(
      companyId: json['companyId'] != null
          ? CompanyId.fromJson(json['companyId'])
          : null,
      id: json['_id'],
      phoneNo: json['phoneNo'],
      status: json['status'],
      userId: json['userId'],
      userName: json['userName'],
      userRole: json['userRole'],
    );
  }
}

class CompanyId {
  String? id;
  String? companyName;
  String? phoneNo;

  CompanyId({this.companyName, this.id, this.phoneNo});

  factory CompanyId.fromJson(Map<String, dynamic> json) {
    return CompanyId(
      companyName: json['companyName'],
      id: json['_id'],
      phoneNo: json['phoneNo'],
    );
  }
}
