// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/controller/tax_settings_controller/tax_settings_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class TaxesGstScreen extends StatelessWidget {
  TaxesGstScreen({super.key});
  var controller = Get.put(TaxSettingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   elevation: 0,
      //   title: Text(
      //     "Taxes & GST",
      //     textAlign: TextAlign.center,
      //     style: GoogleFonts.inter(
      //         color: Colors.white,
      //         fontSize: 16.sp,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
      //     onPressed: () => Get.back(),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.search, size: 22.sp, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Tax Settings",
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          children: _taxesWidgets(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _gstFilingBanner(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _taxesWidgets() {
    return [
      Obx(
        () =>
            _settingsRow("GST Tax", controller.gstTaxEnabled.value, onTap: () {
          controller.setTaxType(isGst: true, isWat: false);
        }),
      ),
      Obx(
        () =>
            _settingsRow("Vat Tax", controller.vatTaxEnabled.value, onTap: () {
          controller.setTaxType(isGst: false, isWat: true);
        }),
      ),
      _listTile("HSN/SAC Code", true),
      _listTile("Additional CESS", false),
      _listTile("Reverse Charge", false),
      _listTile("State of Supply", true),
      Obx(
        () => _settingsRow(
          "My Online Store",
          controller.enableMyOnlineStore.value,
          onTap: () {
            controller.enableMyOnlineStore.value =
                !controller.enableMyOnlineStore.value;
            controller.itemSettingsChange();
          },
        ),
      ),
      Obx(
        () => _settingsRow(
          "E-Invoice",
          controller.enableEInvoice.value,
          onTap: () {
            controller.enableEInvoice.value = !controller.enableEInvoice.value;
            controller.itemSettingsChange();
          },
        ),
      ),
      Obx(
        () => _settingsRow(
          "E-Way Bill No",
          controller.enableEWayBill.value,
          onTap: () {
            controller.enableEWayBill.value = !controller.enableEWayBill.value;
            controller.itemSettingsChange();
          },
        ),
      ),
      _listTile("Composite Scheme", false),
      _listTile("Enable TCS", false, FontAwesomeIcons.crown),
      _listTile("Enable TDS", false, FontAwesomeIcons.crown),
    ];
  }

  Widget _settingsRow(String title, bool isTurnedOn,
      {String? rightText,
      IconData? icon,
      Widget? leftIcon,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leftIcon ?? const SizedBox.shrink(),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 6, 50, 115),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (rightText != null)
                  Text(
                    rightText,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                  ),
                Icon(
                  icon ??
                      (isTurnedOn
                          ? Icons.toggle_on_outlined
                          : Icons.toggle_off_outlined),
                  size: 30.sp,
                  color: isTurnedOn
                      ? const Color.fromARGB(255, 6, 50, 115)
                      : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile(String title, bool isEnabled, [IconData? icon]) {
    return ListTile(
      leading:
          icon != null ? Icon(icon, color: Colors.blue, size: 18.sp) : null,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        isEnabled ? Icons.toggle_on : Icons.toggle_off,
        color: isEnabled ? Colors.blue : Colors.grey,
        size: 30.sp,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  Widget _gstFilingBanner() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "GST Filing starting at ₹2,999!",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Text(
                  "Explore now",
                  style: GoogleFonts.inter(
                    color: Colors.blue,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(Icons.arrow_forward, color: Colors.blue, size: 16.sp),
              ],
            ),
          )
        ],
      ),
    );
  }
}
