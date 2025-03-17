class PartyStatementModel {
  String? transactionType;
  num? totalAmount;
  num? balance;
  String? transactionDate;
  String? documentNo;

  PartyStatementModel(
      {this.balance,
      this.documentNo,
      this.totalAmount,
      this.transactionDate,
      this.transactionType});

  factory PartyStatementModel.fromJson(Map<String, dynamic> json) {
    return PartyStatementModel(
      balance: json['balance'],
      documentNo: json['documentNo'],
      totalAmount: json['totalAmount'],
      transactionDate: json['transactionDate'],
      transactionType: json['transactionType'],
    );
  }
}
