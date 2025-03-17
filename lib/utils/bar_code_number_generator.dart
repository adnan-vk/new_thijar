import 'dart:math';

String barcodeNumberGenerator({int length = 11}) {
  String barcodeNumber = '';
  final random = Random();
  for (int i = 0; i < length; i++) {
    barcodeNumber += random.nextInt(10).toString();
  }

  return barcodeNumber;
}
