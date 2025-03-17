// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/view/purchase/payment_out/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';

class PaymentOut extends StatelessWidget {
  const PaymentOut({super.key});

  @override
  Widget build(BuildContext context) {
    DateController dateController = Get.put(DateController());

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            backgroundColor: const Color.fromARGB(255, 6, 50, 115),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                EneftyIcons.add_outline,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              const Text(
                "Add Purchase Return",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 185,
            child: TopBar(
              page: "Payment In",
            ),
          ),
          Positioned(
            top: 155,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  DateFilterWidget(
                    onCalendaerTap: () async {
                      DateFilterModel obj = await dateController
                          .selectDateRange(context, onSave: () {});
                    },
                  ),
                  Row(
                    children: [
                      buildSummaryCard(
                        "No of Txns",
                        "0.00",
                      ),
                      SizedBox(width: 8.w),
                      buildSummaryCard(
                        "Total Return",
                        "0.00",
                      ),
                      SizedBox(width: 8.w),
                      buildSummaryCard(
                        "Balance Due",
                        "0.00",
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const TransactionCard();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
