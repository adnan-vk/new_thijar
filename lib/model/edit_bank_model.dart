class EditBankModel {
  String? accountDisplayName;
  int? openingBalance;
  DateTime? asOfDate;
  bool? printUpiqrCodeOnInvoice;
  bool? printBankDetailsOnInvoice;
  String? accountNumber;
  String? ifscCode;
  String? upiIdForQrCode;
  String? branchName;
  String? accountHolderName;

  EditBankModel({
    this.accountDisplayName,
    this.openingBalance,
    this.asOfDate,
    this.printUpiqrCodeOnInvoice,
    this.printBankDetailsOnInvoice,
    this.accountNumber,
    this.ifscCode,
    this.upiIdForQrCode,
    this.branchName,
    this.accountHolderName,
  });

  factory EditBankModel.fromJson(Map<String, dynamic> json) {
    return EditBankModel(
      accountDisplayName: json['accountDisplayName'],
      openingBalance: json['openingBalance'],
      asOfDate:
          json['asOfDate'] != null ? DateTime.parse(json['asOfDate']) : null,
      printUpiqrCodeOnInvoice: json['printUpiqrCodeOnInvoice'],
      printBankDetailsOnInvoice: json['printBankDetailsOnInvoice'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      upiIdForQrCode: json['upiIdForQrCode'],
      branchName: json['branchName'],
      accountHolderName: json['accountHolderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountDisplayName': accountDisplayName,
      'openingBalance': openingBalance,
      'asOfDate': asOfDate?.toIso8601String(),
      'printUpiqrCodeOnInvoice': printUpiqrCodeOnInvoice,
      'printBankDetailsOnInvoice': printBankDetailsOnInvoice,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiIdForQrCode': upiIdForQrCode,
      'branchName': branchName,
      'accountHolderName': accountHolderName,
    };
  }
}
