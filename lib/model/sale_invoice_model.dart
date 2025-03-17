class SaleInvoiceModel {
  String? id;
  String? invoiceNo;
  String? invoiceDate;
  String? partyName;
  String? paymentMethod;
  String? bankName;
  num? totalAmount;
  num? balanceAmount;

  SaleInvoiceModel({
    this.id,
    this.invoiceNo,
    this.invoiceDate,
    this.partyName,
    this.paymentMethod,
    this.bankName,
    this.totalAmount,
    this.balanceAmount,
  });

  factory SaleInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceModel(
      id: json['_id'],
      invoiceNo: json['invoiceNo'],
      invoiceDate: json['invoiceDate'],
      partyName: json['partyName'],
      paymentMethod: json['paymentMethod'],
      bankName: json['bankName'] is String
          ? json['bankName']
          : (json['bankName'] is Map<String, dynamic>
              ? json['bankName']['bankName']
              : null),
      totalAmount: json['totalAmount'],
      balanceAmount: json['balanceAmount'],
    );
  }
}
