import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoicePrintScreen extends StatelessWidget {
  const InvoicePrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Invoice Print",
          style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Icon(Icons.store_outlined, size: 22.sp, color: Colors.white),
          SizedBox(width: 13.w),
          Icon(Icons.search, size: 22.sp, color: Colors.white),
          SizedBox(width: 13.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Themes"),
            _listTile("Change Theme and Colors", Icons.palette),
            _listTile("Print text size", Icons.text_fields, subtitle: "Medium"),
            _listTile("Page size", Icons.picture_as_pdf,
                subtitle: "A4 (210x297mm)"),
            _listTile("Orientation", Icons.screen_rotation,
                subtitle: "Portrait"),
            SizedBox(height: 20.h),
            _sectionHeader("Company Info/Header"),
            _listTile("Print repeat header on all pages", Icons.repeat),
            _listTile("Company logo", Icons.image),
            _listTile("Address", Icons.location_on),
            _listTile("Email", Icons.email),
            _listTile("Phone number", Icons.phone),
            SizedBox(height: 20.h),
            _sectionHeader("Totals & Taxes"),
            _listTile("Total Item Quantity", Icons.calculate),
            _listTile("Received amount", Icons.money),
            _listTile("Balance amount", Icons.account_balance_wallet),
            _listTile("Print Current Balance of Party", Icons.account_balance),
            _listTile("Amount in words format", Icons.format_quote,
                subtitle: "Indian (Eg. 1,00,00,000)"),
            _listTile("You Saved", Icons.savings),
            SizedBox(height: 20.h),
            _sectionHeader("Footer"),
            _listTile("Print description", Icons.description),
            _listTile("Print Signature Text", Icons.edit),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
            fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _listTile(String title, IconData icon, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: GoogleFonts.inter(color: Colors.black, fontSize: 12.sp),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: GoogleFonts.inter(color: Colors.grey))
          : null,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }
}
