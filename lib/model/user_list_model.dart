class UserListModel {
  String? prefix;
  String? id;
  String? companyId;
  String? userId;
  String? phoneNo;
  String? userName;
  String? userRole;
  String? status;

  UserListModel({
    this.companyId,
    this.id,
    this.phoneNo,
    this.prefix,
    this.status,
    this.userId,
    this.userName,
    this.userRole,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      companyId: json['companyId'],
      id: json['_id'],
      phoneNo: json['phoneNo'],
      prefix: json['prefix'],
      status: json['status'],
      userId: json['userId'],
      userName: json['userName'],
      userRole: json['userRole'],
    );
  }
}
