import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/model/sale_report_model.dart';

Widget buildGradientButton({VoidCallback? onTap}) {
  return GestureDetector(
    child: Container(
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
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.filter_list, color: Colors.white),
        label: const Text("Filter", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          shadowColor: Colors.transparent, // Remove button shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    ),
  );
}

/// **Widget for Summary Cards**
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
  // final String title;
  // final String total;
  // final String balance;
  final SalesReportModel? item;

  const TransactionCard({
    super.key,
    // required this.title,
    // required this.total,
    // required this.balance,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              item?.party?.name ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
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
                            'Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item?.totalAmount ?? "",
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
                            item?.balance ?? "",
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
                          Text(
                            '${item?.transactionType} ${item?.reference != null ? item?.reference!.documentNumber : ""}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item?.transactionDate ?? "",
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

  // void showPrintDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Select Print Type"),
  //         content: const Text("Please choose the print type for the invoice."),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               // Get.to(() => PdfPreviewPage(
  //               //       object: object,
  //               //       id: object!.id,
  //               //       type: "Sale",
  //               //       page: "Sale",
  //               //     ));
  //             },
  //             child: const Text("Normal Print"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Get.off(() => ThermalPrint(
  //                     id: object!.id,
  //                     object: object,
  //                     page: "Sale",
  //                     type: "Sale",
  //                   ));
  //             },
  //             child: const Text("Thermal Print"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
