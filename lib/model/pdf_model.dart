// models/sale_model.dart
class PdfModel {
  String? id;
  String? invoiceNo;
  String? invoiceType;
  DateTime? invoiceDate;
  String? billNo;
  DateTime? billDate;
  Party? party;
  List<PaymentMethod>? paymentMethod;
  List<Item>? items;
  double? totalAmount;
  double? receivedAmount;
  double? balanceAmount;
  String? source;
  BusinessProfile? businessProfile;

  PdfModel({
    this.id,
    this.invoiceNo,
    this.invoiceType,
    this.invoiceDate,
    this.billNo,
    this.billDate,
    this.party,
    this.paymentMethod,
    this.items,
    this.totalAmount,
    this.receivedAmount,
    this.balanceAmount,
    this.source,
    this.businessProfile,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
        id: json['_id'],
        invoiceNo: json['invoiceNo'],
        invoiceType: json['invoiceType'],
        invoiceDate: json['invoiceDate'] != null
            ? DateTime.parse(json['invoiceDate'])
            : null,
        billNo: json['billNo'],
        billDate:
            json['billDate'] != null ? DateTime.parse(json['billDate']) : null,
        party: json['party'] != null ? Party.fromJson(json['party']) : null,
        paymentMethod: json['paymentMethod'] != null
            ? (json['paymentMethod'] as List)
                .map((e) => PaymentMethod.fromJson(e))
                .toList()
            : [],
        items: json['items'] != null
            ? (json['items'] as List).map((e) => Item.fromJson(e)).toList()
            : [],
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        receivedAmount: (json['receivedAmount'] ?? 0).toDouble(),
        balanceAmount: (json['balanceAmount'] ?? 0).toDouble(),
        source: json['source'] ?? '', // Default empty string for null values
        businessProfile: json['businessProfile'] != null
            ? BusinessProfile.fromJson(json['businessProfile'])
            : null,
      );
}

class Party {
  String? id;
  String? name;
  String? gstIn;
  ContactDetails? contactDetails;

  Party({this.id, this.name, this.gstIn, this.contactDetails});

  factory Party.fromJson(Map<String, dynamic> json) => Party(
        id: json['_id'],
        name: json['name'],
        gstIn: json['gstIn'],
        contactDetails: json['contactDetails'] != null
            ? ContactDetails.fromJson(json['contactDetails'])
            : null,
      );
}

class ContactDetails {
  String? email;
  String? phone;

  ContactDetails({this.email, this.phone});

  factory ContactDetails.fromJson(Map<String, dynamic> json) => ContactDetails(
        email: json['email'],
        phone: json['phone'],
      );
}

class PaymentMethod {
  String? method;
  double? amount;

  PaymentMethod({this.method, this.amount});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        method: json['method'],
        amount: (json['amount'] ?? 0).toDouble(),
      );
}

class Item {
  ItemId? itemId;
  double? quantity;
  double? price;
  double? finalAmount;
  double? discountPercent;
  String? valueWithoutTax;
  String? taxAmount;
  TaxPercent? taxPercent;

  Item({
    this.itemId,
    this.quantity,
    this.price,
    this.finalAmount,
    this.discountPercent,
    this.taxPercent,
    this.valueWithoutTax,
    this.taxAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json['itemId'] != null ? ItemId.fromJson(json['itemId']) : null,
        quantity: (json['quantity'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        finalAmount: (json['finalAmount'] ?? 0).toDouble(),
        discountPercent: (json['discountPercent'] ?? 0).toDouble(),
        taxPercent: json['taxPercent'] != null
            ? TaxPercent.fromJson(json['taxPercent'])
            : null,
        valueWithoutTax: json['valueWithoutTax'],
        taxAmount: json['taxAmount'],
      );
}

class ItemId {
  String? id;
  String? itemName;

  ItemId({this.id, this.itemName});

  factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        id: json['_id'],
        itemName: json['itemName'],
      );
}

class TaxPercent {
  String? id;
  String? taxType;
  String? rate;

  TaxPercent({this.id, this.rate, this.taxType});

  factory TaxPercent.fromJson(Map<String, dynamic> json) {
    return TaxPercent(
      id: json['_id'],
      rate: json['rate'],
      taxType: json['taxType'],
    );
  }
}

class BusinessProfile {
  String? id;
  String? businessName;
  String? email;
  String? gstIn;
  String? logo;
  String? phoneNo;
  String? signature;
  String? businessAddress;

  BusinessProfile({
    this.businessName,
    this.email,
    this.gstIn,
    this.id,
    this.logo,
    this.phoneNo,
    this.signature,
    this.businessAddress,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      businessName: json['businessName'],
      email: json['email'],
      gstIn: json['gstIn'],
      id: json['_id'],
      logo: json['logo'],
      phoneNo: json['phoneNo'],
      signature: json['signature'],
      businessAddress: json['businessAddress'],
    );
  }
}
