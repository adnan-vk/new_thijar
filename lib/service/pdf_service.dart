import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/urls/base_url.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  Future<pw.Widget> buildNetworkCircularAvatarWithDio(
      {required String imageUrl, required bool isForLogo}) async {
    setLoadingValue(true);
    log("This is image setup for pdf$imageUrl, isForLogo$isForLogo ");
    try {
      final response = await Dio().get<Uint8List>(
        ApiBaseUrl.fileBaseUrl + imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        setLoadingValue(false);
        return pw.Container(
          width: isForLogo ? 50 : 100,
          height: 50,
          decoration: pw.BoxDecoration(
            shape: isForLogo ? pw.BoxShape.circle : pw.BoxShape.rectangle,
            image: pw.DecorationImage(
              image: pw.MemoryImage(response.data!),
              fit: isForLogo ? pw.BoxFit.cover : pw.BoxFit.contain,
            ),
          ),
        );
      } else {
        setLoadingValue(false);
        return pw.SizedBox();
      }
    } catch (e) {
      setLoadingValue(false);

      return pw.SizedBox();
    }
  }

  Future<File> generatePdf({
    required String phone,
    required String email,
    required String invoiceNo,
    required String date,
    required String billTo,
    required String invoiceAmountInWords,
    required String totalAmount,
    required String receivedAmount,
    required String balanceAmount,
    required String bankName,
    required String accountNo,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    final pdf = pw.Document();

    // Load Google Font (Roboto in this example)
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    var controller = Get.put(BusinessController());
    log("this is Sale PDF");
    await controller.fetchUserProfile();

    var avatar = await buildNetworkCircularAvatarWithDio(
        imageUrl:
            controller.businessProfile.value.businessProfile!.logo.toString(),
        isForLogo: true);
    var signature = await buildNetworkCircularAvatarWithDio(
        imageUrl: controller.businessProfile.value.businessProfile!.signature
            .toString(),
        isForLogo: false);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Text(
                "Tax Invoice",
                style: pw.TextStyle(
                    font: ttf, fontSize: 22, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              controller.apiLogo.value != ""
                  ? pw.Align(alignment: pw.Alignment.topLeft, child: avatar)
                  : pw.SizedBox(),
              pw.SizedBox(height: 20),

              // Company Info and Invoice Details
              pw.Table(
                columnWidths: {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(2),
                },
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                controller.businessProfile.value
                                            .businessProfile !=
                                        null
                                    ? controller.businessProfile.value
                                        .businessProfile!.businessName
                                        .toString()
                                    : "",
                                style: pw.TextStyle(
                                    fontSize: 18,
                                    font: ttf,
                                    fontBold: pw.Font.timesBold(),
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text("Phone no: $phone",
                                style: pw.TextStyle(font: ttf)),
                            pw.Text(
                                "Email: ${controller.businessProfile.value.businessProfile != null ? controller.businessProfile.value.businessProfile!.email.toString() : ""}",
                                style: pw.TextStyle(font: ttf)),
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Invoice No.",
                                    style: pw.TextStyle(
                                        font: ttf,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(invoiceNo,
                                    style: pw.TextStyle(font: ttf)),
                              ],
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Date",
                                    style: pw.TextStyle(
                                        font: ttf,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Text(date, style: pw.TextStyle(font: ttf)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Bill To Section
              pw.Container(
                padding: pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Bill To", style: pw.TextStyle(font: ttf)),
                    pw.Text(billTo, style: pw.TextStyle(font: ttf)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Amount Details
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text("Invoice Amount in Words",
                            style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                            ContextProvider()
                                .amountToWords(invoiceAmountInWords),
                            style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text("Total", style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text("₹ $totalAmount",
                            style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child:
                            pw.Text("Received", style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text("₹ $receivedAmount",
                            style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child:
                            pw.Text("Balance", style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text("₹ $balanceAmount",
                            style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Bank Details, Terms, and Authorization
              pw.Table(
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(1),
                },
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Bank Details",
                                style: pw.TextStyle(
                                    font: ttf, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Name: $bankName",
                                style: pw.TextStyle(font: ttf)),
                            pw.Text("Account No: $accountNo",
                                style: pw.TextStyle(font: ttf)),
                            pw.Text("IFSC Code: $ifscCode",
                                style: pw.TextStyle(font: ttf)),
                            pw.Text("Account Holder's Name: $accountHolderName",
                                style: pw.TextStyle(font: ttf)),
                          ],
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Terms and Conditions\nThank you for doing business with us.",
                          style: pw.TextStyle(font: ttf),
                        ),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("For: XianInfoTech",
                                style: pw.TextStyle(
                                    font: ttf, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 40),
                            pw.Text("Authorized Signatory",
                                style: pw.TextStyle(font: ttf)),
                            pw.SizedBox(height: 10),
                            controller.apiSignature.value != ""
                                ? pw.Align(
                                    alignment: pw.Alignment.topRight,
                                    child: signature)
                                : pw.SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/TaxInvoice.pdf');
    await file.writeAsBytes(await pdf.save());
    log('PDF saved at ${file.path}');
    return file;
  }

  Future<File> generateSalesReportPDF(
      {required List<List<String>> saleDataList,
      required String totalSale}) async {
    // Load custom font
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    var controller = Get.put(BusinessController());
    controller.fetchUserProfile();
    final avatar = await buildNetworkCircularAvatarWithDio(
        imageUrl:
            controller.businessProfile.value.businessProfile!.logo.toString(),
        isForLogo: true);
    final signature = await buildNetworkCircularAvatarWithDio(
        imageUrl: controller.businessProfile.value.businessProfile!.signature
            .toString(),
        isForLogo: false);
    // Create the PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header Section
                pw.Text(
                  controller.businessProfile.value.businessProfile != null
                      ? controller
                          .businessProfile.value.businessProfile!.businessName
                          .toString()
                      : "XianInfoTech",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf, // Use custom font here
                  ),
                ),
                pw.SizedBox(height: 10),
                controller.apiLogo.value != ""
                    ? pw.Align(alignment: pw.Alignment.topLeft, child: avatar)
                    : pw.SizedBox(),
                pw.Text(
                  "Phone no.: 8129935578 Email:${controller.businessProfile.value.businessProfile != null ? controller.businessProfile.value.businessProfile!.email.toString() : ""} ",
                  style: pw.TextStyle(
                    font: ttf, // Use custom font here
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Sale Report",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf, // Use custom font here
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Username: All Users", style: pw.TextStyle(font: ttf)),
                pw.Text("Duration: From 01/11/2024 to 30/11/2024",
                    style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: 10),

                // Table Section
                pw.Text(
                  "Sale",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf, // Use custom font here
                  ),
                ),
                pw.SizedBox(height: 10),

                // Sale Table
                pw.Table.fromTextArray(
                  headers: [
                    'Date',
                    'Order No.',
                    'Ref No.',
                    'Party Name',
                    'Phone No',
                    'Party\'s GSTIN No.',
                    'Txn Type',
                    'Total Amount',
                    'Payment Type',
                    'Received/Paid Amount',
                    'Balance Amount',
                  ],
                  data: saleDataList,
                  //  [
                  //   [
                  //     '07/11/2024',
                  //     '2',
                  //     'rajath_test3',
                  //     '-',
                  //     '-',
                  //     'Credit Note',
                  //     '₹ 0.00',
                  //     'Cash',
                  //     '₹ 0.00',
                  //     '₹ 0.00'
                  //   ],
                  //   [
                  //     '07/11/2024',
                  //     '3',
                  //     'rajath_test4',
                  //     '-',
                  //     '-',
                  //     'Sale',
                  //     '₹ 0.00',
                  //     'Cash',
                  //     '₹ 0.00',
                  //     '₹ 0.00'
                  //   ],
                  //   [
                  //     '09/11/2024',
                  //     '3',
                  //     'Gokul',
                  //     '111',
                  //     '-',
                  //     'Credit Note',
                  //     '₹ 0.00',
                  //     'Cash',
                  //     '₹ 0.00',
                  //     '₹ 0.00'
                  //   ],
                  //   [
                  //     '09/11/2024',
                  //     '4',
                  //     'go',
                  //     '-',
                  //     '-',
                  //     'Sale',
                  //     '₹ 0.00',
                  //     'Cash',
                  //     '₹ 0.00',
                  //     '₹ 0.00'
                  //   ],
                  // ],
                  border: pw.TableBorder.all(),
                  cellStyle: pw.TextStyle(
                      fontSize: 7, font: ttf), // Use custom font here
                  headerStyle: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf, // Use custom font here
                  ),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  cellAlignment: pw.Alignment.centerLeft,
                ),

                // Footer Section
                pw.SizedBox(height: 10),
                pw.Text(
                  "Total Sale: ₹ $totalSale",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf, // Use custom font here
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          controller.apiSignature.value != ""
              ? pw.Align(alignment: pw.Alignment.topLeft, child: signature)
              : pw.SizedBox(),
        ],
      ),
    );

    // Save the PDF to a file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sale_report.pdf');
    await file.writeAsBytes(await pdf.save());
    print('PDF Saved: ${file.path}');

    return file;
  }

  Future<File> generateChallanPDF(
      {String? phoneNum,
      String? email,
      String? challanNum,
      String? date,
      String? challanPName}) async {
    final pdf = pw.Document();

    // Load custom font
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    var controller = Get.put(BusinessController());
    await controller.fetchUserProfile();
    final avatar = await buildNetworkCircularAvatarWithDio(
        imageUrl:
            controller.businessProfile.value.businessProfile!.logo.toString(),
        isForLogo: true);
    final signature = await buildNetworkCircularAvatarWithDio(
        imageUrl: controller.businessProfile.value.businessProfile!.signature
            .toString(),
        isForLogo: false);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        controller.businessProfile.value.businessProfile != null
                            ? controller.businessProfile.value.businessProfile!
                                .businessName
                                .toString()
                            : "",
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("Phone no.: $phoneNum",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text(
                        "Email: ${controller.businessProfile.value.businessProfile != null ? controller.businessProfile.value.businessProfile!.email.toString() : ""}",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.SizedBox(height: 10),
                    controller.apiLogo.value != ""
                        ? pw.Align(
                            alignment: pw.Alignment.topLeft, child: avatar)
                        : pw.SizedBox(),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Challan No.",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("$challanNum",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.SizedBox(height: 10),
                    pw.Text("Date",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("$date",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            // Delivery Details
            pw.Text(
              "Delivery Challan for",
              style: pw.TextStyle(
                  font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text("$challanPName",
                style: pw.TextStyle(font: ttf, fontSize: 12)),
            pw.Text("ddddd", style: pw.TextStyle(font: ttf, fontSize: 12)),
            pw.Text("Contact No.: $phoneNum",
                style: pw.TextStyle(font: ttf, fontSize: 12)),
            pw.SizedBox(height: 10),
            pw.Divider(),
            // Terms and Conditions
            pw.Text("Terms and conditions",
                style: pw.TextStyle(
                    font: ttf, fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text("Thank you for doing business with us.",
                style: pw.TextStyle(font: ttf, fontSize: 12)),
            pw.SizedBox(height: 10),
            pw.Divider(),
            // Footer Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Received By:",
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("Name:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Comment:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Date:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Signature:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Delivered By:",
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("Name:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Comment:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Date:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Signature:",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("For: XianInfoTech",
                        style: pw.TextStyle(font: ttf, fontSize: 12)),
                    pw.Text("Authorized Signatory",
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            controller.apiSignature.value != ""
                ? pw.Align(alignment: pw.Alignment.topLeft, child: signature)
                : pw.SizedBox(),
          ],
        ),
      ),
    );

    // Save PDF to file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/delivery_challan.pdf");
    await file.writeAsBytes(await pdf.save());
    print("PDF Saved: ${file.path}");

    return file;
  }
}
