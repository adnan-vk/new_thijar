import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/invoice_model.dart';
import 'package:newthijar/view/home_page/widgets/thermal_print.dart';
import 'package:newthijar/view/pdf_page/pdf_screen.dart';
import 'package:newthijar/widgets/loading/loading.dart';

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
                  color: Color.fromARGB(255, 6, 50, 115),
                ),
              ),
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
                            'Items',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 50, 115),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 50, 115),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 50, 115),
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
