class CashInHandModel {
  String? id;
  String? partyName;
  String? transactionDate;
  String? referenceNo;
  String? type;
  int? creditAmount;
  int? debitAmount;

  CashInHandModel({
    this.transactionDate,
    this.partyName,
    this.type,
    this.referenceNo,
    this.id,
    this.creditAmount,
    this.debitAmount,
  });

  factory CashInHandModel.fromJson(Map<String, dynamic> json) {
    return CashInHandModel(
        transactionDate: json['transactionDate'],
        partyName: json['partyName'],
        type: json['type'],
        referenceNo: json['referenceNo'],
        id: json['_id'],
        creditAmount: json['credit_Amount'],
        debitAmount: json['debit_Amount']);
  }
}
