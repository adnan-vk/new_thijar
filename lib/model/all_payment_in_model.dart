class AllPaymentInModel {
  String? id;
  String? receiptNo;
  String? date;
  String? partyName;
  String? phoneNo;
  int? receivedAmount;

  AllPaymentInModel(
      {this.date,
      this.id,
      this.partyName,
      this.phoneNo,
      this.receiptNo,
      this.receivedAmount});

  factory AllPaymentInModel.fromJson(Map<String, dynamic> json) {
    return AllPaymentInModel(
      date: json['date'],
      id: json['_id'],
      partyName: json['partyName'],
      phoneNo: json['phoneNo'],
      receiptNo: json['receiptNo'],
      receivedAmount: json['receivedAmount'],
    );
  }
}
