import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/cash_flow_controller/cash_flow_report.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/view/report/sub_screens/cash_flow_report/widgets/widgets.dart';
import 'package:newthijar/view/report/sub_screens/sale_report/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';

class CashFlowReport extends StatelessWidget {
  CashFlowReport({super.key});
  final controller = Get.put(CashFlowReportController());
  final dateController = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    // Use Obx to rebuild whenever date changes
    return Obx(() {
      // Fetch data whenever the date changes
      controller.fetchCashFlowReportList(
        date: DateFilterModel(
          startDate: dateController.startDateIs.value,
          endDate: dateController.endDateIs.value,
        ),
      );

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 175,
                child: TopBar(
                  page: "Cashflow Report",
                ),
              ),
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double tabWidth = (constraints.maxWidth / 2) -
                                10; // Dynamic tab width

                            return TabBar(
                              dividerHeight: 0,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.blue.shade900,
                              indicator: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Colors.transparent,
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.normal),
                              tabs: [
                                Container(
                                  width: tabWidth,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blue.shade900),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('Money In'),
                                ),
                                Container(
                                  width: tabWidth,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blue.shade900),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('Money Out'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      /// **Modularized Date Filter Widget**
                      DateFilterWidget(
                        onCalendaerTap: () async {
                          DateFilterModel obj = await dateController
                              .selectDateRange(context, onSave: () {});
                          controller.fetchCashFlowReportList(
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
                          Text("Filters Applied:",
                              style: TextStyle(fontSize: 14.sp)),
                          const Spacer(),
                          buildGradientButton(),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      /// **Summary Cards**
                      Obx(
                        () {
                          final data =
                              controller.cashFlowReportList.value.headerdata;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  buildSummaryCard(
                                    "Closing Cash",
                                    '${data?.closingCash?.toStringAsFixed(2) ?? 0.0}',
                                  ),
                                  SizedBox(width: 8.w),
                                  buildSummaryCard("Opening Cash",
                                      '${data?.openingCash?.toStringAsFixed(2) ?? 0.0}'),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  buildSummaryCard("Money In",
                                      '${data?.totalMoneyIn?.toStringAsFixed(2) ?? 0.0}'),
                                  SizedBox(width: 8.w),
                                  buildSummaryCard("Money Out",
                                      '${data?.totalMoneyOut?.toStringAsFixed(2) ?? 0.0}'),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 12.h),
                      Expanded(
                        child: TabBarView(
                          children: [
                            buildTransactionList(
                              isMoneyIn: true,
                              controller: controller,
                            ),
                            buildTransactionList(
                              isMoneyIn: false,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
