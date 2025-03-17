// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/view/report/sub_screens/cash_flow_report/cash_flow_report.dart';
import 'package:newthijar/view/report/sub_screens/party_statements/party_statement.dart';
import 'package:newthijar/view/report/sub_screens/purchase_report/purchase_report.dart';
import 'package:newthijar/view/report/sub_screens/sale_report/sale_report.dart';
import 'package:newthijar/view/report/sub_screens/stock_detail_report/stock_detail_report.dart';
import 'package:newthijar/view/report/sub_screens/trial_balance/trial_balance.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              page: "Report",
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
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportSectionHeading(title: "Transactions"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Sale Report",
                      onTap: () {
                        Get.to(
                          () => SaleReport(),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Purchase Report",
                      onTap: () {
                        Get.to(() => PurchaseReport());
                      },
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Trial Balance",
                      onTap: () {
                        Get.to(() => const TrialBalanceScreen());
                      },
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Profit & Loss",
                      onTap: () {
                        Get.to(() => CashFlowReport());
                      },
                    ),
                    const SizedBox(height: 10),
                    ReportSectionData(
                      item: "Cashflow",
                      onTap: () {
                        Get.to(() => CashFlowReport());
                      },
                    ),
                    const SizedBox(height: 10),
                    ReportSectionData(
                      item: "Balance Sheet",
                      onTap: () {
                        Get.to(() => CashFlowReport());
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const ReportSectionHeading(title: "Party Reports"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Party Statement",
                      onTap: () {
                        Get.to(() => const PartStatementScreen());
                      },
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "All Parties Reports",
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const ReportSectionHeading(title: "Tax Reports"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Sale Report With Tax",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Purchase Report With Tax",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Sale and Purchase Summary",
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const ReportSectionHeading(title: "Item/Stock Report"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Stock Summary Report",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Low Stock Summary Report",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Stock Detail Report",
                      onTap: () {
                        Get.to(() => const StockDetailReport());
                      },
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Stock Transfer Report",
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const ReportSectionHeading(title: "Business Status"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Bank Statement",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Discount Report",
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 10),
                    const ReportSectionHeading(title: "Expense Report"),
                    const SizedBox(height: 12),
                    ReportSectionData(
                      item: "Expense Cateory Report",
                    ),
                    const SizedBox(height: 8),
                    ReportSectionData(
                      item: "Expense Item Report",
                    ),
                    const SizedBox(height: 8),
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

class ReportSectionHeading extends StatelessWidget {
  final String title;

  const ReportSectionHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 6, 50, 115), // Dark blue color
      ),
    );
  }
}

class ReportSectionData extends StatelessWidget {
  final item;
  GestureTapCallback? onTap;
  ReportSectionData({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        item,
      ),
    );
  }
}
