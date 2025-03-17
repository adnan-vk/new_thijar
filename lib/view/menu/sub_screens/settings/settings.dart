import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/view/menu/sub_screens/add_user/add_user_screen.dart';
import 'package:newthijar/view/invoice_print_screen/invoice_print_screen.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/general_settings.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/item_settings_screen.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/transaction_settings.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/transaction_sms_screen.dart';
import 'package:newthijar/view/tax_and_gst/tax_and_gst_screen.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Settings",
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: ListView(
                children: [
                  _settingTile(
                    icon: Icons.settings,
                    title: "General",
                    onTap: () => Get.to(() => GeneralSettingScreen()),
                  ),
                  _settingTile(
                    icon: Icons.swap_horiz,
                    title: "Transaction",
                    onTap: () => Get.to(() => TransactionSettingScreen()),
                  ),
                  _settingTile(
                    icon: Icons.print,
                    title: "Invoice Print",
                    onTap: () => Get.to(() => const InvoicePrintScreen()),
                  ),
                  _settingTile(
                    icon: FontAwesomeIcons.fileInvoiceDollar,
                    title: "Taxes & GST",
                    onTap: () => Get.to(() => TaxesGstScreen()),
                  ),
                  _settingTile(
                    icon: Icons.person_add,
                    title: "Add User",
                    onTap: () => Get.to(() => AddUserScreen()),
                  ),
                  _settingTile(
                    icon: Icons.sms,
                    title: "Transaction SMS",
                    onTap: () => Get.to(() => const TransactionSmsScreen()),
                  ),
                  _settingTile(
                    icon: Icons.inventory,
                    title: "Inventory Management",
                    onTap: () => Get.to(() => ItemSettingScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _settingTile(
  //     {required IconData icon,
  //     required String title,
  //     required Function() onTap}) {
  //   return Card(
  //     color: const Color.fromARGB(255, 6, 50, 115),
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
  //     child: ListTile(
  //       leading: Icon(icon, color: Colors.white, size: 28.sp),
  //       title: Text(
  //         title,
  //         style: GoogleFonts.inter(
  //           color: Colors.white,
  //           fontSize: 18.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       trailing:
  //           Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20.sp),
  //       onTap: onTap,
  //     ),
  //   );
  // }
  Widget _settingTile({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 6, 50, 115),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white70, size: 20.sp),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
