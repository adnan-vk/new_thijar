class AddBankModel {
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

  AddBankModel({
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

  Map<String, dynamic> toJson() {
    return {
      'accountDisplayName': accountDisplayName,
      'openingBalance': openingBalance,
      'asOfDate': "2024-10-22",
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
