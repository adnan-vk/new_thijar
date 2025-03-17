// ignore_for_file: must_be_immutable
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/controller/pdf-controller/pdf_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatefulWidget {
  final Object? object;
  String? id;
  String? type;
  String? page;

  PdfPreviewPage({super.key, this.object, this.id, this.type, this.page});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

final PdfController controller = Get.put(PdfController());

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
      await controller.getPdf(id: widget.id, type: widget.type);
      await controller.fetchBusinessLogo();
      await controller.fetchBusinessSignature();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice Preview"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PdfPreview(
              actionBarTheme: const PdfActionBarTheme(
                backgroundColor: Color.fromARGB(255, 3, 134, 240),
              ),
              build: (format) => _generatePdf(format),
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              pdfFileName: "Invoice_{widget.object?.invoiceNo}.pdf",
            ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            controller.allDetails.isNotEmpty
                                ? controller.allDetails[0].businessProfile
                                        ?.businessName ??
                                    'Business Name'
                                : 'Business Name',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            controller.allDetails.isNotEmpty
                                ? controller
                                        .allDetails[0].businessProfile?.email ??
                                    'Business Email'
                                : 'Business Email',
                            style: const pw.TextStyle(
                                color: PdfColors.white, fontSize: 14),
                          ),
                          pw.Text(
                            controller.allDetails.isNotEmpty
                                ? controller.allDetails[0].businessProfile
                                        ?.phoneNo ??
                                    'Business Phone'
                                : 'Business Phone',
                            style: const pw.TextStyle(
                                color: PdfColors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      height: 100,
                      width: 100,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        shape: pw.BoxShape.rectangle,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: controller.logoImageData != null
                          ? pw.Image(pw.MemoryImage(controller.logoImageData!))
                          : pw.Center(child: pw.Text("No Image")),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "TAX INVOICE",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey900,
                      ),
                    ),
                    pw.Text(
                      "VAT No: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].businessProfile?.gstIn ?? '' : ''}",
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Ensure that the party name is properly accessed from the controller
                      pw.Text(
                        widget.page == "Sale"
                            ? "Sold To: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].party?.name ?? '' : ''}"
                            : "Buy From : ${controller.allDetails.isNotEmpty ? controller.allDetails[0].party?.name ?? '' : ''}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        "Phone : ${controller.allDetails.isNotEmpty ? controller.allDetails[0].party?.contactDetails?.phone ?? '' : ''}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        widget.page == "Sale"
                            ? "Invoice No: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].invoiceNo ?? '' : ''}"
                            : "Bill No: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].billNo ?? '' : ''}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        widget.page == "Sale"
                            ? "Invoice Date: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].invoiceDate != null ? controller.allDetails[0].invoiceDate!.toLocal().toString().split(" ")[0] : '' : ''}"
                            : "Bill Date: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].billDate != null ? controller.allDetails[0].billDate!.toLocal().toString().split(" ")[0] : '' : ''}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        "Mode of Payment: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].paymentMethod?.first.method ?? '' : ''}",
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                _buildTableHeader(),
                pw.ListView.builder(
                  itemCount: controller.allDetails.isNotEmpty
                      ? controller.allDetails[0].items?.length ?? 0
                      : 0,
                  itemBuilder: (context, index) {
                    return _buildTableRow(index, isOdd: index % 2 != 0);
                  },
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                        "Total: ${controller.allDetails.isNotEmpty ? controller.allDetails[0].totalAmount ?? '' : ''}",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(
                      width: 202.w,
                      child: pw.Text(
                          "Issued From : ${controller.allDetails.isNotEmpty ? controller.allDetails[0].businessProfile?.businessAddress ?? 'Business Address' : 'Business Address'}",
                          style: const pw.TextStyle(fontSize: 14)),
                    ),
                    pw.Column(children: [
                      pw.Text("Receiver's Signature",
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Container(
                        height: 150,
                        width: 150,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.rectangle,
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: controller.signatureImageData != null
                            ? pw.Image(
                                pw.MemoryImage(controller.signatureImageData!),
                              )
                            : pw.Center(child: pw.Text("No Signature")),
                      ),
                    ])
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildTableHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _tableCell("Sl.No"),
          _tableCell("Description", flex: 3),
          _tableCell("Qty"),
          _tableCell("Disc."),
          _tableCell("Price"),
          _tableCell("Total"),
          _tableCell("VAT(%)"),
          _tableCell("VAT"),
          _tableCell("Amount"),
        ],
      ),
    );
  }

  _buildTableRow(int index, {required bool isOdd}) {
    final item = controller.allDetails[0].items![index];
    return pw.Container(
      color: isOdd ? PdfColors.grey200 : PdfColors.white,
      child: pw.Row(
        children: [
          _tableCell("${index + 1}"),
          _tableCell(
            item.itemId != null ? item.itemId!.itemName ?? "" : "",
            flex: 3,
          ),
          _tableCell(item.quantity?.toString() ?? ""),
          _tableCell(item.discountPercent?.toString() ?? "0.00"),
          _tableCell(item.price?.toString() ?? "0.00"),
          _tableCell(item.valueWithoutTax ?? "0.00"),
          _tableCell(item.taxPercent?.rate.toString() ?? "0.00"),
          _tableCell(item.taxAmount ?? "0.00"),
          _tableCell(item.finalAmount?.toString() ?? ""),
        ],
      ),
    );
  }

  pw.Widget _tableCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
