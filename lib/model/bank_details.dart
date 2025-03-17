class BankDetails {
  String id;
  String bankName;
  double openingBalance;
  DateTime asOfDate;
  bool printUPIQRCodeOnInvoice;
  bool printBankDetailsOnInvoice;
  String? accountNumber; // Nullable
  String? ifscCode; // Nullable
  String? upiIDForQRCode; // Nullable
  String? branchName; // Nullable
  String? accountHolderName; // Nullable
  String? createdBy; // Nullable
  int v;

  BankDetails({
    required this.id,
    required this.bankName,
    required this.openingBalance,
    required this.asOfDate,
    required this.printUPIQRCodeOnInvoice,
    required this.printBankDetailsOnInvoice,
    this.accountNumber,
    this.ifscCode,
    this.upiIDForQRCode,
    this.branchName,
    this.accountHolderName,
    this.createdBy,
    required this.v,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      id: json['_id'] ?? "",
      bankName: json['bankName'] ?? "",
      openingBalance: (json['openingBalance'] as num).toDouble(),
      asOfDate: DateTime.parse(json['asOfDate']),
      printUPIQRCodeOnInvoice: json['printUPIQRCodeOnInvoice'] ?? false,
      printBankDetailsOnInvoice: json['printBankDetailsOnInvoice'] ?? false,
      accountNumber: json['accountNumber'], // Nullable
      ifscCode: json['ifscCode'], // Nullable
      upiIDForQRCode: json['upiIDForQRCode'], // Nullable
      branchName: json['branchName'], // Nullable
      accountHolderName: json['accountHolderName'], // Nullable
      createdBy: json['createdBy'], // Nullable
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bankName': bankName,
      'openingBalance': openingBalance,
      'asOfDate': asOfDate.toIso8601String(),
      'printUPIQRCodeOnInvoice': printUPIQRCodeOnInvoice,
      'printBankDetailsOnInvoice': printBankDetailsOnInvoice,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiIDForQRCode': upiIDForQRCode,
      'branchName': branchName,
      'accountHolderName': accountHolderName,
      'createdBy': createdBy,
      '__v': v,
    };
  }
}
