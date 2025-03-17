class SyncAndShareModel {
  String? phoneNo;
  String? userName;
  String? userRole;
  String? prefix;

  SyncAndShareModel({
    this.phoneNo,
    this.userName,
    this.userRole,
    this.prefix,
  });

  factory SyncAndShareModel.fromJson(Map<String, dynamic> json) {
    return SyncAndShareModel(
      phoneNo: json['phoneNo'],
      userName: json['userName'],
      userRole: json['userRole'],
      prefix: json['prefix'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userRole': userRole,
        'userName': userName,
        'phoneNo': phoneNo,
        'prefix': prefix,
      };
}
