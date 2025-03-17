import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/widgets/loading/loading.dart';

Widget buildSummaryCard(String title, amount) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 6, 50, 115),
            Color.fromARGB(255, 30, 111, 191)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(amount,
              style: TextStyle(
                  fontSize: 15.sp,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    ),
  );
}

class TransactionCard extends StatelessWidget {
  final Widget? popupWidget;
  // final InvoiceModel? object;

  const TransactionCard({
    super.key,
    this.popupWidget,
    // this.object,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 120,
              child: Text(
                "partyName",
                style: TextStyle(
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
                  "invoiceNo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "invoiceDate",
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "total",
                            style: TextStyle(
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "balance",
                            style: TextStyle(
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
                              // if (value == 'Edit') {
                              //   var controller = Get.put(
                              //     TransactionDetailController(),
                              //   );
                              //   controller.youRedting.value = true;
                              //   controller.customerTxtCont.text ==
                              //       object?.partyName;
                              //   controller.selectedIndex.value =
                              //       object?.invoiceType == "Credit" ? 0 : 1;
                              //   controller.currentRecivedAmountController.text =
                              //       ((object?.totalAmount ?? 0) -
                              //               (double.parse(object?.balanceAmount
                              //                       ?.toString() ??
                              //                   '0')))
                              //           .toString();
                              //   controller.getSaleDetailById(
                              //       id: object!.id.toString());
                              // } else if (value == 'Delete') {
                              //   showDeleteBottomSheet(object!);
                              // }
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

  void showDeleteBottomSheet() {
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
                        "Are you sure want to delete   ?",
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
                              // var controller =
                              //     Get.put(TransactionDetailController());

                              // controller.deleteSaleById(
                              //     id: object.id.toString());
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
                // Get.to(() => PdfPreviewPage(
                //       object: object,
                //       id: object!.id,
                //       type: "Sale",
                //       page: "Sale",
                //     ));
              },
              child: const Text("Normal Print"),
            ),
            TextButton(
              onPressed: () {
                // Get.off(() => ThermalPrint(
                //       id: object!.id,
                //       object: object,
                //       page: "Sale",
                //       type: "Sale",
                //     ));
              },
              child: const Text("Thermal Print"),
            ),
          ],
        );
      },
    );
  }
}
