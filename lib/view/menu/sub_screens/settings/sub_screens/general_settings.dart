// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/controller/general_settings_controller/general_settings_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class GeneralSettingScreen extends StatelessWidget {
  GeneralSettingScreen({super.key});
  final _controller = Get.put(GeneralSettingController());
  var controller = Get.put(TransactionDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   elevation: 2,
      //   title: Text(
      //     "General Settings",
      //     style: GoogleFonts.inter(
      //       color: Colors.white,
      //       fontSize: 20.sp,
      //       fontWeight: FontWeight.bold,
      //       letterSpacing: 1.2,
      //     ),
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Get.back(),
      //   ),
      //   actions: [
      //     Icon(Icons.search, size: 24.sp, color: Colors.white),
      //     SizedBox(width: 16.w),
      //   ],
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 183,
            child: TopBar(
              page: "General Settings",
            ),
          ),
          Positioned(
            top: 155,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSettingsTile("App Language", "English"),
                      _buildDivider(),
                      // _buildSettingsTile("Business Currency", "₹"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Business Currency",
                                style: _settingTxtStyle()),
                            Row(
                              children: [
                                // Text(value, style: _optionsTextStyle()),
                                // Icon(Icons.arrow_drop_down, color: Colors.blue),
                                GestureDetector(
                                  onTap: () {
                                    showCurrencyPicker(
                                      context: context,
                                      showFlag: true,
                                      showCurrencyName: true,
                                      showCurrencyCode: true,
                                      onSelect: (Currency currency) {
                                        controller.currency.value =
                                            "${currency.symbol} ${currency.name}";
                                        log("Selected currency in controller: $currency");
                                      },
                                    );
                                  },
                                  child: Obx(
                                    () => Text(
                                      controller.currency.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.sp,
                                        color: const Color(0xFF333333),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile("Date Format", "dd/MM/yyyy"),
                      _buildDivider(),
                      _buildToggleTile("Passcode/Fingerprint", 1),
                      _buildDivider(),
                      _buildNavigationTile("Multi-firm Settings"),
                      _buildDivider(),
                      _buildToggleTile("Stock Transfer", 2),
                      _buildDivider(),
                      _buildNavigationTile("Backup Settings"),
                      _buildDivider(),
                      _buildToggleTile(
                          "Enable Estimates (Proforma Invoice)", 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _settingTxtStyle()),
          Row(
            children: [
              Text(value, style: _optionsTextStyle()),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _settingTxtStyle()),
          Obx(
            () => Transform.scale(
              scale: 0.8, // Adjust size to match the image
              child: Switch.adaptive(
                activeColor: Colors.white,
                activeTrackColor: const Color.fromARGB(255, 6, 50, 115),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
                value: _controller.toggles[index],
                onChanged: (val) => _controller.toggleButton(index),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavigationTile(String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: _settingTxtStyle()),
            Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade700);
  }

  TextStyle _settingTxtStyle() {
    return GoogleFonts.inter(
      color: Colors.black,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _optionsTextStyle() {
    return GoogleFonts.inter(
      color: Colors.grey,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    );
  }
}
