// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/controller/sale_report_controller/sale_report_controller.dart';
import 'package:newthijar/view/report/sub_screens/sale_report/widgets/filter_widget.dart';
import 'package:newthijar/view/report/sub_screens/sale_report/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class SaleReport extends StatelessWidget {
  SaleReport({super.key});
  DateController dateController = Get.put(DateController());
  final controller = Get.put(SaleReportController());

  @override
  Widget build(BuildContext context) {
    controller.getSalesReport(
        date: DateFilterModel(
            startDate: dateController.startDateIs.value,
            endDate: dateController.endDateIs.value));
    String selectedUser = "All Users";
    String selectedTxnType = "Sales and Cr. Note";
    String selectedParty = "All Party";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 210,
            child: TopBar(
              page: "Sales Report",
            ),
          ),
          Positioned(
            top: 160, // Adjust this to position the curved container correctly
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// **Modularized Date Filter Widget**
                    DateFilterWidget(
                      onCalendaerTap: () async {
                        DateFilterModel obj = await dateController
                            .selectDateRange(context, onSave: () {});
                        controller.getSalesReport(
                            date: DateFilterModel(
                                startDate: dateController.startDateIs.value,
                                endDate: dateController.endDateIs.value));
                      },
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          "Filters Applied:",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        const Spacer(),
                        buildGradientButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => FilterDialogSales(
                                initialSelectedUser: selectedUser,
                                initialSelectedTxnType: selectedTxnType,
                                initialSelectedParty: selectedParty,
                              ),
                            ).then((selectedFilters) {
                              if (selectedFilters != null) {
                                log("Selected Filters: $selectedFilters");
                                selectedUser = selectedFilters['selectedUser'];
                                selectedTxnType =
                                    selectedFilters['selectedTxnType'];
                                selectedParty =
                                    selectedFilters['selectedParty'];

                                final txnType = selectedTxnType == 'All'
                                    ? ''
                                    : selectedTxnType;
                                final partyName = selectedParty == 'All Party'
                                    ? ''
                                    : selectedParty;

                                controller.getSalesReport(
                                    transactionType: txnType,
                                    partyName: partyName,
                                    date: DateFilterModel(
                                        startDate:
                                            dateController.startDateIs.value,
                                        endDate:
                                            dateController.endDateIs.value));
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    SizedBox(height: 12.h),

                    /// **Summary Cards**
                    Obx(
                      () => Row(
                        children: [
                          buildSummaryCard(
                            "No of Txns",
                            controller.totalTransactions.value.toString(),
                          ),
                          SizedBox(width: 8.w),
                          buildSummaryCard(
                            "Total Sale",
                            controller.totalSaleAmount.value,
                          ),
                          SizedBox(width: 8.w),
                          buildSummaryCard(
                            "Balance Due",
                            controller.balanceDue.value,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.allSales.isEmpty
                              ? Center(
                                  child: Text(
                                    "No Data Available",
                                    style: interFontBlack(context),
                                  ),
                                )
                              : Expanded(
                                  child: ListView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    children: [
                                      SizedBox(height: 12.h),
                                      ...controller.allSales.map((item) {
                                        return TransactionCard(
                                          item: item,
                                        );
                                      })
                                    ],
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
