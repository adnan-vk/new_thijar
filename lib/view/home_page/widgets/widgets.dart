// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/invoice_model.dart';
import 'package:newthijar/view/home_page/home.dart';
import 'package:newthijar/view/home_page/widgets/thermal_print.dart';
import 'package:newthijar/view/pdf_page/pdf_screen.dart';
import 'package:newthijar/view/purchase/payment_out/payment_out.dart';
import 'package:newthijar/view/purchase/purchase_bill/purchase_bil.dart';
import 'package:newthijar/view/purchase/purchase_order/purchase_order.dart';
import 'package:newthijar/view/purchase/purchase_return/purchase_return.dart';
import 'package:newthijar/view/sale/estimate_quotaion/estimate_quotaion.dart';
import 'package:newthijar/view/sale/payment_in/payment_in.dart';
import 'package:newthijar/view/sale/sale_invoice/sale_invoice.dart';
import 'package:newthijar/view/sale/sale_order/sale_order.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  GestureTapCallback? onTap;

  ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70, // Adjust width to align with the provided image
        height: 90, // Adjust height to give the same feel
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: const Color.fromARGB(255, 6, 50, 115), width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 6, 50, 115),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 6, 50, 115),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Widget? popupWidget;
  final InvoiceModel? object;

  const TransactionCard({
    super.key,
    this.popupWidget,
    this.object,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                object!.partyName.toString(),
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  object!.invoiceNo.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  object!.invoiceDate.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          color: Colors.grey.shade100,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            object!.totalAmount.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey.shade400,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            object!.balanceAmount.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey.shade400,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showPrintDialog(context);
                            },
                            child: const Icon(EneftyIcons.printer_outline,
                                color: Colors.grey, size: 24),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(EneftyIcons.share_2_outline,
                                color: Colors.grey, size: 24),
                          ),
                          const SizedBox(width: 15),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              EneftyIcons.more_outline,
                              color: Colors.grey,
                              size: 24,
                            ),
                            onSelected: (value) async {
                              if (value == 'Edit') {
                                var controller = Get.put(
                                  TransactionDetailController(),
                                );
                                controller.youRedting.value = true;
                                controller.customerTxtCont.text ==
                                    object?.partyName;
                                controller.selectedIndex.value =
                                    object?.invoiceType == "Credit"
                                        ? false
                                        : true;
                                controller.currentRecivedAmountController.text =
                                    ((object?.totalAmount ?? 0) -
                                            (double.parse(object?.balanceAmount
                                                    ?.toString() ??
                                                '0')))
                                        .toString();
                                controller.getSaleDetailById(
                                    id: object!.id.toString());
                              } else if (value == 'Delete') {
                                showDeleteBottomSheet(object!);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showDeleteBottomSheet(InvoiceModel object) {
    Get.bottomSheet(Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
        height: 150.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                size: 35.sp,
                color: Colors.red,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        "Are you sure want to delete ${object.partyName.toString()}  ?",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color.fromARGB(255, 6, 50, 115)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        child: Text(
                          "Cancel",
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.sp),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return isLoading.value
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () {
                              var controller =
                                  Get.put(TransactionDetailController());

                              controller.deleteSaleById(
                                  id: object.id.toString());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: const Color.fromARGB(255, 6, 50, 115)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 12.h),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ),
                            ),
                          );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Print Type"),
          content: const Text("Please choose the print type for the invoice."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.to(() => PdfPreviewPage(
                      object: object,
                      id: object!.id,
                      type: "Sale",
                      page: "Sale",
                    ));
              },
              child: const Text("Normal Print"),
            ),
            TextButton(
              onPressed: () {
                Get.off(() => ThermalPrint(
                      id: object!.id,
                      object: object,
                      page: "Sale",
                      type: "Sale",
                    ));
              },
              child: const Text("Thermal Print"),
            ),
          ],
        );
      },
    );
  }
}

void showPurchasePopup(
    BuildContext context, enableImportPurchase, enablePurchaseOrder) {
  showCustomPopup(context, [
    {
      'icon': EneftyIcons.shopping_cart_outline,
      'label': 'Purchase Bill',
      'onTap': () {
        Get.to(() => const PurchaseBill());
      }
    },
    if (enablePurchaseOrder.value == true)
      {
        'icon': EneftyIcons.money_change_outline,
        'label': 'Payment-Out',
        'onTap': () {
          Get.to(() => const PaymentOut());
        },
      },
    {
      'icon': EneftyIcons.back_square_outline,
      'label': 'Purchase Return',
      'onTap': () => Get.to(() => const PurchaseReturn()),
    },
    if (enablePurchaseOrder.value == true)
      {
        'icon': EneftyIcons.receipt_2_outline,
        'label': 'Purchase Order',
        'onTap': () {
          Get.to(() => const PurchaseOrdersPage());
        },
      },
    if (enableImportPurchase.value == true)
      {
        'icon': EneftyIcons.import_4_outline,
        'label': 'Import Purchase',
        'onTap': () {
          // var c = Get.put(AddSaleController());
          // c.onInit();
          // Get.to(() => const PurchaseListScreen());
        },
      },
  ]);
}

void showSalePopup(
  BuildContext context,
  enableDeliveryChallan,
  enableEstimate,
  enableExportSale,
  enableSaleOrder,
) {
  showCustomPopup(context, [
    {
      'icon': EneftyIcons.money_outline,
      'label': 'Payment-In',
      'onTap': () {
        Get.to(() => const PaymentIn());
      },
    },
    {
      'icon': EneftyIcons.back_square_outline,
      'label': 'Sale Return',
      'onTap': () {
        //  Get.to(() => SaleReturnScreen());
      },
    },
    if (enableDeliveryChallan.value == true)
      {
        'icon': EneftyIcons.ship_outline,
        'label': 'Delivery Challan',
        'onTap': () {
          //  Navigator.push(context,
          //   MaterialPageRoute(builder: (context) => DeliveryChallanScreen()));
        },
      },
    if (enableEstimate.value == true)
      {
        'icon': EneftyIcons.receipt_3_outline,
        'label': 'Estimate/Quotation',
        'onTap': () async {
          // var c = Get.put(AddEstimateController());
          // c.onInit();
          Get.to(() => const EstimateQuotaion());
        },
      },
    {
      'icon': EneftyIcons.receipt_outline,
      'label': 'Sale Invoice',
      'onTap': () async {
        // final controller = Get.put(SaleInvoiceOrReportController());
        // await controller.getSalesInvoice();
        Get.to(() => SaleInvoice());
      },
    },
    if (enableSaleOrder.value == true)
      {
        'icon': EneftyIcons.shopping_cart_outline,
        'label': 'Sale Order',
        'onTap': () {
          // var c = Get.put(AddSaleController());
          // c.onInit();
          Get.to(() => const SaleOrder());
        },
      },
    if (enableExportSale.value == true)
      {
        'icon': EneftyIcons.export_4_outline,
        'label': 'Export Sale',
        'onTap': () {
          // var c = Get.put(AddSaleController());
          // c.onInit();
          // Get.off(() => SaleListScreen(isSwitch: false));
        },
      },
  ]);
}

void showCustomPopup(BuildContext context, List<Map<String, dynamic>> items) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              children: items.map((item) {
                return GestureDetector(
                  onTap: item['onTap'] as VoidCallback,
                  child: Column(
                    children: [
                      Icon(item['icon'],
                          size: 30,
                          color: const Color.fromARGB(255, 6, 50, 115)),
                      const SizedBox(height: 8),
                      Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 6, 50, 115),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      var curve = Curves.easeInOut;
      var scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: anim1,
        curve: curve,
      ));
      var opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: anim1,
        curve: curve,
      ));
      return ScaleTransition(
        scale: scale,
        child: FadeTransition(
          opacity: opacity,
          child: child,
        ),
      );
    },
  );
}
