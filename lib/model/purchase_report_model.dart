class PurchaseReportModel {
  Reference? reference;
  String? id;
  String? transactionType;
  Party? party;
  num? totalAmount;
  num? creditAmount;
  num? debitAmount;
  num? balance;
  String? transactionDate;

  PurchaseReportModel(
      {this.balance,
      this.creditAmount,
      this.debitAmount,
      this.party,
      this.id,
      this.reference,
      this.totalAmount,
      this.transactionDate,
      this.transactionType});

  factory PurchaseReportModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReportModel(
      balance: json['balance'],
      creditAmount: json['credit_amount'],
      debitAmount: json['debit_amount'],
      id: json['_id'],
      party: json['party'] != null ? Party.fromJson(json['party']) : null,
      reference: json['reference'] != null
          ? Reference.fromJson(json['reference'])
          : null,
      totalAmount: json['totalAmount'],
      transactionDate: json['transactionDate'],
      transactionType: json['transactionType'],
    );
  }
}

class Reference {
  String? documentNumber;

  Reference({this.documentNumber});

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      documentNumber: json['documentNumber'],
    );
  }
}

class Party {
  String? id;
  String? name;

  Party({this.id, this.name});

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['_id'],
      name: json['name'],
    );
  }
}
