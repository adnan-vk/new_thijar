class ItemModel {
  String? itemName;
  String? itemNum;
  String? price;
  String? quantity;
  String? total;
  String? taxAmt;
  String? discount;
  String? subtotalP;
  String? discountP;
  String? unit;
  String? taxPercent;
  String? taxRate;
  String? totalAmount;
  num? mrp;

  ItemModel({
    this.taxPercent,
    this.unit,
    this.mrp,
    this.subtotalP,
    this.discountP,
    this.itemName,
    this.itemNum,
    this.price,
    this.quantity,
    this.total,
    this.taxAmt,
    this.discount,
    this.totalAmount,
    this.taxRate,
  });
}
