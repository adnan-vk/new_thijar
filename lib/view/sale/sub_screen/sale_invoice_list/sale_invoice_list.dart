import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/sale_inv_report_controller/sale_inv_report_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/sale_invoice_model.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class SaleInvoistListScreen extends StatefulWidget {
  SaleInvoistListScreen({super.key});

  @override
  State<SaleInvoistListScreen> createState() => _SaleInvoistListScreenState();
}

class _SaleInvoistListScreenState extends State<SaleInvoistListScreen> {
  final controller = Get.put(SaleInvoiceOrReportController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSalesInvoice();
      TransactionDetailController().isEditingFromSalesInvoice.value = false;
    });
    super.initState();
  }

  // Initial load
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back()),
        title: InkWell(
          onTap: () async {
            await controller.getSalesInvoice();
          },
          child: const Text(
            'Sale List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp, color: Colorconst.cGrey),
            onPressed: () {
              // Search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colorconst.cRed),
            onPressed: () {
              // PDF action
            },
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search TextField
            Padding(
              padding: EdgeInsets.all(10.w),
              child: TextFormField(
                onChanged: (value) {
                  controller.searchSalesInvoice(value);
                },
                style: interFontBlack(context),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: Colorconst.cBlue,
                    size: 25.sp,
                  ),
                  hintText: "Search for a transaction",
                  hintStyle: interFontGrey(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Total Sale Info Container
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Sale",
                      style: TextStyle(
                        color: Colorconst.cGrey,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      "₹5000.00",
                      style: TextStyle(
                          color: Colorconst.cBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ),

            // Sales List
            Expanded(
              child: Obx(
                () {
                  return isLoading.value == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.allSales.isEmpty
                          ? Center(
                              child: Text(
                                "Empty list",
                                style: interFontBlack(context),
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.allSales
                                  .length, // Modify this for actual items
                              itemBuilder: (context, index) {
                                final item = controller.allSales[index];
                                return Card(
                                  color: Colorconst.cwhite,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.h, vertical: 10.w),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(14.0.w),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.partyName.toString(),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Container(
                                              height: 20.h,
                                              width: 40.w,
                                              decoration: const ShapeDecoration(
                                                shape: StadiumBorder(),
                                                color: Colorconst.cCream,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'PAID',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colorconst.cOrange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120.w,
                                            ),
                                            Column(
                                              // crossAxisAlignment:
                                              // CrossAxisAlignment.end,z
                                              children: [
                                                Text(
                                                  item.invoiceNo.toString(),
                                                  style: TextStyle(
                                                      color: Colorconst.cGrey,
                                                      fontSize: 12.sp),
                                                ),
                                                Text(
                                                  item.invoiceDate.toString(),
                                                  style: TextStyle(
                                                      color: Colorconst.cGrey,
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '₹ ${item.totalAmount}',
                                          style: TextStyle(
                                              color: Colorconst.cBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp),
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 6.w),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Balance: ₹ ${item.balanceAmount}",
                                                    style: TextStyle(
                                                        color: Colorconst.cGrey,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.print,
                                              color: Colors.grey,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            Icon(
                                              Icons.share_rounded,
                                              color: Colors.grey,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 23.sp,
                                                color: Colorconst.cGrey,
                                              ),
                                              onSelected: (value) async {
                                                if (value == 'Edit') {
                                                  var controller = Get.put(
                                                      TransactionDetailController());
                                                  controller
                                                      .isEditingFromSalesInvoice
                                                      .value = true;
                                                  controller
                                                      .currentRecivedAmountController
                                                      .text = ((item
                                                                  .totalAmount ??
                                                              0) -
                                                          (double.parse(item
                                                                  .balanceAmount
                                                                  ?.toString() ??
                                                              '0')))
                                                      .toString();
                                                  controller.youRedting.value =
                                                      true;
                                                  controller.getSaleDetailById(
                                                      id: item.id.toString());
                                                } else if (value == 'Delete') {
                                                  showDeleteBottomSheet(item);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                const PopupMenuItem(
                                                  value: 'Edit',
                                                  child: Text('Edit'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'Delete',
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteBottomSheet(SaleInvoiceModel object) {
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
                          color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 7.h),
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
                                  Get.put(SaleInvoiceOrReportController());

                              controller.deleteSaleById(
                                  id: object.id.toString());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.blue),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 7.h),
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
}
