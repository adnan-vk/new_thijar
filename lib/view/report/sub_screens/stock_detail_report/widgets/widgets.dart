import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **Gradient Button Widget**
Widget buildGradientButton() {
  return Container(
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
      onPressed: () {},
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
  );
}

/// **Widget for Summary Cards**
// Widget buildSummaryCard(String title, String amount) {
//   return Expanded(
//     child: Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [
//             Color.fromARGB(255, 6, 50, 115),
//             Color.fromARGB(255, 30, 111, 191)
//           ],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
//           SizedBox(height: 8.h),
//           Text(amount,
//               style: TextStyle(
//                   fontSize: 15.sp,
//                   // fontWeight: FontWeight.bold,
//                   color: Colors.white)),
//         ],
//       ),
//     ),
//   );
// }

Widget buildSummaryRow() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSummaryItem("Closing Qty", "10.0"),
        const Text("=", style: TextStyle(color: Colors.white, fontSize: 16)),
        buildSummaryItem("Bgng Qty", "65.0"),
        const Text("+", style: TextStyle(color: Colors.white, fontSize: 16)),
        buildSummaryItem("In Qty", "115.0"),
        const Text("-", style: TextStyle(color: Colors.white, fontSize: 16)),
        buildSummaryItem("Qty Out", "115.0"),
      ],
    ),
  );
}

Widget buildSummaryItem(String title, String amount) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 14.sp, color: Colors.white),
      ),
      SizedBox(height: 4.h),
      Text(
        amount,
        style: TextStyle(fontSize: 15.sp, color: Colors.white),
      ),
    ],
  );
}

class TransactionCard extends StatelessWidget {
  // final String title;
  // final String total;
  // final String balance;
  // final InvoiceModel? object;

  const TransactionCard({
    super.key,
    // required this.title,
    // required this.total,
    // required this.balance,
    // this.object,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Name",
              textAlign: TextAlign.center,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            Row(
              children: [
                const Text(
                  "Closing Quantity: ",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "0.0",
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
                            'Begning Qty',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "0.0",
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
                            'Quantity In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "0.0",
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
                            'Quantity Out',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "0.0",
                            style: TextStyle(
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
}
