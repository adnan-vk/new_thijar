import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Widget buildTransactionList({required bool isMoneyIn, required controller}) {
  return Column(
    children: [
      // Headers for the columns
      Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Txns Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Amount',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Balance',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),

      // Transaction List
      Expanded(
        child: Obx(
          () {
            var transactions = isMoneyIn
                ? controller.cashFlowReportList.value.moneyIn
                : controller.cashFlowReportList.value.moneyOut;

            if (transactions == null || transactions.isEmpty) {
              return const Center(
                child: Text(
                  "Empty list",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero, // Removes extra spacing
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];
                bool isLight = index.isEven;

                return Container(
                  color: isLight ? Colors.white : Colors.grey.shade100,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${item.partyName}\n${formatDate(item.transactionDate.toString())}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.type.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          isMoneyIn
                              ? '+ ₹ ${item.creditAmount}'
                              : '- ₹ ${item.debitAmount}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isMoneyIn ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}
