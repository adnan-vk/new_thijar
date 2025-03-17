import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/invoive_no_model.dart';
import 'package:newthijar/view/home_page/sub_screen/add_sale_scree.dart/widgets/invno_date_widget.dart';
import 'package:newthijar/view/home_page/sub_screen/add_sale_scree.dart/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';

class AddSalePage extends StatelessWidget {
  AddSalePage({super.key});
  final _controller = Get.put(TransactionDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: TopBar(
              page: "Sale",
            ),
          ),
          Positioned(
            top: 165,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () {
                          return InvoiceHeaderWidget(
                            invoiceNumber:
                                _controller.invoiceNo.value.invoiceNo == null
                                    ? "1"
                                    : _controller.invoiceNo.value.invoiceNo
                                        .toString(),
                            date: _controller.selectedSaleDate.value.isEmpty
                                ? _controller.defaultDate
                                : _controller.selectedSaleDate.value,
                            onTapDate: () async {
                              String? date =
                                  await ContextProvider().selectDate(context);
                              log("date++++++ ==$date");
                              if (date == null) {
                              } else {
                                _controller.selectedSaleDate.value = date;
                              }
                            },
                            ontapInvoice: () {
                              showInvoiceInputTypeDialog(
                                onSelectItem: (p0) {
                                  log("p0==$p0");
                                  if (p0 == 'Fetch') {
                                    _controller.fetchInvoicNo();
                                    Get.back();
                                  } else if (p0 == '' || p0.isEmpty) {
                                    _controller.fetchInvoicNo();
                                    Get.back();
                                  } else {
                                    InvoiceNoModel model = InvoiceNoModel(
                                      invoiceNo: p0,
                                    );
                                    _controller.invoiceNo.value = model;
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      const Divider(),
                      const Text(
                        "Attachment",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(),
                      buildFormContainer(context, controller: _controller),
                      const SizedBox(height: 20),
                      buildAmountSection(controller: _controller),
                      const SizedBox(height: 20),
                      const Text(
                        "Payment Type",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      buildDropdown(["Cash", "Credit Card", "UPI"], "Cash"),
                      const SizedBox(height: 10),
                      // buildTextField("Add Payment Type", Icons.add),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(context),
    );
  }

  Widget buildBottomButtons(BuildContext context) {
    final _controller = Get.put(TransactionDetailController());
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191)
                ], // Gradient blue
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: TextButton(
              onPressed: () async {
                _controller.saleValidator() == "ok"
                    ? _controller.youRedting.value
                        ? await _controller.updateSale()
                        : await _controller.addSale()
                    : null;
                await _controller.clearController();
                log("balance amount : ${_controller.balanceDue}");
                // await Get.to(() => PdfPreviewPage(
                //       type: "Sale",
                //       id: widget.object!.id,
                //       page: "Sale",
                //     ));
                _controller.selectedSaleDate.value =
                    ContextProvider().getCurrentDate();
              },
              child: const Text(
                "Save",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
