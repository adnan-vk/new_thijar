class BankListModel {
  String? id;
  String? bankName;
  num? openingBalance;
  String? accountNumber;
  String? accountHolderName;

  BankListModel({
    this.id,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.openingBalance,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      id: json['_id'],
      bankName: json['bankName'],
      accountHolderName: json['accountHolderName'],
      accountNumber: json['accountNumber'],
      openingBalance: json['openingBalance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'openingBalance': openingBalance,
    };
  }
}
