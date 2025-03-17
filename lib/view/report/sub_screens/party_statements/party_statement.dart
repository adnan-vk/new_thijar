import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/view/report/sub_screens/party_statements/widgets/widget.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';

class PartStatementScreen extends StatelessWidget {
  const PartStatementScreen({super.key});

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
            height: 210,
            child: TopBar(
              page: "Party Statement",
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
                    DateFilterWidget(),
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
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        showPartySelection(context);
                      },
                      child: buildDropdown(),
                    ),

                    SizedBox(height: 12.h),

                    /// **Summary Cards**
                    Row(
                      children: [
                        buildSummaryCard("Total Amount", "₹ 54879.5"),
                        SizedBox(width: 8.w),
                        buildSummaryCard("Closing Balance", "₹ 45121.5"),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    /// **Transaction Table**
                    buildTransactionTable(),
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
