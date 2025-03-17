import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/controller/item_settings_controller/item_settings_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class ItemSettingScreen extends StatelessWidget {
  final ItemSettingController controller = Get.put(ItemSettingController());

  ItemSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchSettingData();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Item Settings",
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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildToggleRow(
                        "Item Type",
                        true,
                      ),
                      _buildToggleRow(
                        "Barcode Scanning for item",
                        true,
                      ),
                      Obx(
                        () => _buildToggleRow(
                          "Item Code/Bar Code",
                          true,
                          controller: controller.enableItemCode.value,
                          onTap: () {
                            controller.enableItemCode.value =
                                !controller.enableItemCode.value;
                            controller.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _buildToggleRow(
                          "Item Category",
                          true,
                          controller: controller.enableItemCategory.value,
                          onTap: () {
                            controller.enableItemCategory.value =
                                !controller.enableItemCategory.value;
                            controller.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _buildToggleRow(
                          "HSN/SAC Code",
                          true,
                          controller: controller.enableItemHsn.value,
                          onTap: () {
                            controller.enableItemHsn.value =
                                !controller.enableItemHsn.value;
                            controller.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _buildToggleRow(
                          "Item Wise Discount",
                          true,
                          controller: controller.enableItemDiscount.value,
                          onTap: () {
                            controller.enableItemDiscount.value =
                                !controller.enableItemDiscount.value;
                            controller.itemSettingsChange();
                          },
                        ),
                      ),
                      _buildToggleRow(
                        "Manufacturing",
                        false,
                      ),
                      Obx(
                        () => _buildToggleRow(
                          "MRP",
                          true,
                          controller: controller.enableItemMrp.value,
                          onTap: () {
                            controller.enableItemMrp.value =
                                !controller.enableItemMrp.value;
                            controller.itemSettingsChange();
                          },
                        ),
                      ),
                      _buildToggleRow(
                        "Default Unit",
                        false,
                      ),
                      _buildToggleRow("Party Wise Item Rate", false,
                          icon: EneftyIcons.crown_2_bold),
                      _buildToggleRow("Wholesale Price", false,
                          icon: EneftyIcons.crown_2_bold),
                      plusMinusRow(
                        "Quantity (Upto Decimal places)",
                        controller.quantityNotifier,
                        onAddTap: () async {
                          await controller.itemSettingsChange();
                        },
                        onLessTap: () async {
                          await controller.itemSettingsChange();
                        },
                      ),
                      plusMinusRow(
                        "Price (Upto Decimal places)",
                        controller.priceNotifier,
                        onAddTap: () async {
                          await controller.itemSettingsChange();
                        },
                        onLessTap: () async {
                          await controller.itemSettingsChange();
                        },
                      ),
                      _buildToggleRow("Item Wise Tax", true),
                      _buildToggleRow("Update Sale Price from TXN", true),
                      _buildToggleRow("Additional CESS", true),
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

  Widget _buildToggleRow(String label, bool enabled,
      {bool? controller, IconData? icon, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, color: const Color.fromARGB(255, 6, 50, 115)),
              SizedBox(width: icon != null ? 8 : 0),
              Text(label,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 6, 50, 115),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Icon(
                controller ?? false
                    ? Icons.toggle_on_outlined
                    : Icons.toggle_off_outlined,
                size: 30,
                color: controller ?? false
                    ? const Color.fromARGB(255, 6, 50, 115)
                    : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget plusMinusRow(String title, ValueNotifier<num> valueNotifier,
      {Function()? onAddTap, Function()? onLessTap}) {
    return ValueListenableBuilder<num>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 50, 115),
                Color.fromARGB(255, 30, 111, 191)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    GoogleFonts.poppins(fontSize: 12.sp, color: Colors.white),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 50, 115),
                  borderRadius: BorderRadius.circular(20), // Rounded box
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6), // White shadow
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (value > 1) {
                          valueNotifier.value =
                              valueNotifier.value - 1; // Fix decrement
                          onLessTap?.call(); // Call function correctly
                        }
                      },
                      child: Icon(Icons.remove_circle,
                          size: 20.sp, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      value.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        if (value < 3) {
                          valueNotifier.value =
                              valueNotifier.value + 1; // Fix increment
                          onAddTap?.call(); // Call function correctly
                        }
                      },
                      child: Icon(Icons.add_circle,
                          size: 20.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
