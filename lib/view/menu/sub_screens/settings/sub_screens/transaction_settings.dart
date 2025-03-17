import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/controller/transaction_controller/transaction_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class TransactionSettingScreen extends StatelessWidget {
  TransactionSettingScreen({super.key});
  final transactionController = Get.put(Transactioncontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Transaction Settings",
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => _settingTile(
                          title: "Deivery Challan",
                          isActive:
                              transactionController.enableDeliveryChallan.value,
                          onTap: (value) {
                            transactionController.enableDeliveryChallan.value =
                                !transactionController
                                    .enableDeliveryChallan.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Estimate / Quotation",
                          isActive: transactionController.enableEstimate.value,
                          onTap: (value) {
                            transactionController.enableEstimate.value =
                                !transactionController.enableEstimate.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Export Sale",
                          isActive:
                              transactionController.enableExportSales.value,
                          onTap: (value) {
                            transactionController.enableExportSales.value =
                                !transactionController.enableExportSales.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Import Purchase",
                          isActive:
                              transactionController.enableImportPurchase.value,
                          onTap: (value) {
                            transactionController.enableImportPurchase.value =
                                !transactionController
                                    .enableImportPurchase.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Email Address of parties",
                          isActive:
                              transactionController.enablePartyEmail.value,
                          onTap: (value) {
                            transactionController.enablePartyEmail.value =
                                !transactionController.enablePartyEmail.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Purchase Order",
                          isActive:
                              transactionController.enablePurchaseOrder.value,
                          onTap: (value) {
                            transactionController.enablePurchaseOrder.value =
                                !transactionController
                                    .enablePurchaseOrder.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Sale Order",
                          isActive:
                              transactionController.enableSalesOrder.value,
                          onTap: (value) {
                            transactionController.enableSalesOrder.value =
                                !transactionController.enableSalesOrder.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      Obx(
                        () => _settingTile(
                          title: "Shipping Address of parties",
                          isActive:
                              transactionController.enableShippingAddress.value,
                          onTap: (value) {
                            transactionController.enableShippingAddress.value =
                                !transactionController
                                    .enableShippingAddress.value;
                            transactionController.itemSettingsChange();
                          },
                        ),
                      ),
                      _settingTile(
                          title: "Cash Sale by default", isActive: true),
                      _settingTile(
                          title: "Add Time On Transaction", isActive: false),
                      _header("Items Table"),
                      _settingTile(
                          title: "Allow Inclusive/Exclusive Tax on Price",
                          isActive: true),
                      _settingTile(
                          title: "Display Purchase Price", isActive: true),
                      _settingTile(
                          title: "Free Item Quantity", isActive: false),
                      _settingTile(
                          title: "Barcode Scanning for Items", isActive: false),
                      _header("Taxes, Discount & Total"),
                      _settingTile(
                          title: "Transaction wise Tax", isActive: false),
                      _settingTile(
                          title: "Transaction wise Discount", isActive: false),
                      _settingTile(
                          title: "Round Off Transaction Amount",
                          isActive: false),
                      _header("More Transaction Features"),
                      _settingTile(
                          title: "Enable Invoice Preview", isActive: true),
                      _settingTile(
                          title: "Passcode for Edit/Delete", isActive: false),
                      _settingTile(
                          title: "Link Payment to Invoices", isActive: false),
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

  Widget _header(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
            color: const Color.fromARGB(255, 6, 50, 115),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _settingTile(
      {String? title, bool? isActive, ValueChanged<bool>? onTap}) {
    return GestureDetector(
      // onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toString(),
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500),
          ),
          Switch(
            value: isActive!,
            onChanged: onTap,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.white,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.white),
            activeTrackColor: const Color.fromARGB(255, 6, 50, 115),
          ),
        ],
      ),
    );
  }
}
