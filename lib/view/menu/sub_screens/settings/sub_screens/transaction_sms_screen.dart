import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionSmsScreen extends StatelessWidget {
  const TransactionSmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Transaction SMS",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 22.sp, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _switchTile("Send to party", true),
                  _switchTile("Send SMS Copy to Self", false),
                  _switchTileWithIcons(
                      "Send Transaction Update SMS", false, Icons.error),
                  _switchTile("Show Party's Current Balance", false),
                  _switchTile("Show web invoice link", true),
                  Divider(color: Colors.blue.shade700),
                  _header("Select transactions for automatic messaging"),
                  _switchTile("Sale", true),
                  _switchTile("Sale Return", true),
                  _switchTile("Purchase Return", true),
                  _switchTile("Estimate", false),
                  _switchTile("Payment-In", true),
                  _switchTile("Payment-Out", true),
                  _switchTile("Sale Order", true),
                  _switchTile("Purchase Order", false),
                  _switchTile("Delivery Challan", false),
                ],
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _switchTile(String title, bool isOn) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
      value: isOn,
      onChanged: (value) {},
      activeColor: Colors.blue,
      inactiveTrackColor: Colors.grey.shade800,
    );
  }

  Widget _switchTileWithIcons(String title, bool isOn, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 16.sp),
          SizedBox(width: 10.w),
          Switch(
            value: isOn,
            onChanged: (value) {},
            activeColor: Colors.blue,
            inactiveTrackColor: Colors.grey.shade800,
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Customize & Preview Message",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.black),
        ],
      ),
    );
  }
}
