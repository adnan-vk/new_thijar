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

/// **Custom Dropdown UI**
Widget buildDropdown() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Select Party",
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
        const Icon(Icons.arrow_drop_down, color: Colors.black54),
      ],
    ),
  );
}

void showPartySelection(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (context) {
      List<String> parties = ["Party 1", "Party 2", "Party 3"];
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: parties
              .map((party) => ListTile(
                    title: Text(party),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      );
    },
  );
}

/// **Widget for Summary Cards**
Widget buildSummaryCard(String title, String amount) {
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
          Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
          SizedBox(height: 4.h),
          Text(amount,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    ),
  );
}

/// **Updated Widget for Transaction Table**
Widget buildTransactionTable() {
  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          buildTableHeader(),
          buildTableRow("Payable Beginning\nN/A", "₹ 0.0", "-100", true),
          buildTableRow("Purchase\n24-01-25", "₹ 35355", "24242", false),
          buildTableRow("Payment-Out\n24-01-25", "₹ 10000", "0", true),
          buildTableRow("Sale\n24-01-25", "₹ 550", "0", false),
        ],
      ),
    ),
  );
}

/// **Table Header with Bold Styling**
TableRow buildTableHeader() {
  return TableRow(
    decoration: BoxDecoration(color: Colors.grey.shade200),
    children: [
      buildTableCell("Txns Type", bold: true, align: TextAlign.left),
      buildTableCell("Amount", bold: true, align: TextAlign.right),
      buildTableCell("Balance", bold: true, align: TextAlign.right),
    ],
  );
}

/// **Table Row with Alternating Colors**
TableRow buildTableRow(
    String type, String amount, String balance, bool isLight) {
  return TableRow(
    decoration:
        BoxDecoration(color: isLight ? Colors.white : Colors.grey.shade100),
    children: [
      buildTableCell(type, align: TextAlign.left),
      buildTableCell(amount, align: TextAlign.right),
      buildTableCell(balance, align: TextAlign.right),
    ],
  );
}

/// **Table Cell Styling**
Widget buildTableCell(String text,
    {bool bold = false, TextAlign align = TextAlign.center}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: Colors.black87,
      ),
    ),
  );
}
