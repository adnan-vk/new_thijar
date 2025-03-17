// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/transaction_controller/transaction_controller.dart';
import 'package:newthijar/model/invoice_model.dart';
import 'package:newthijar/view/home_page/sub_screen/stock_transfer/widgets/widget.dart'
    show TransactionCard;
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/db/db.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class StockTransfer extends StatelessWidget {
  final Repository repository = Repository();
  final businessController = Get.put(BusinessController());
  String? type;
  StockTransfer({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.put(HomeController(repository: repository));
    final homeController = Get.find<HomeController>();
    final Transactioncontroller transactionSettingsController =
        Transactioncontroller();
    transactionSettingsController.fetchSettingData();
    controller.getAllInvoice();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Transfer Stock",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
        backgroundColor:
            const Color.fromARGB(255, 6, 50, 115), // Dark blue color
        icon: const Icon(
          EneftyIcons.arrow_swap_horizontal_outline,
          color: Colors.white, // White icon color
          size: 28,
        ),
        shape: const StadiumBorder(), // Makes it fully rounded
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              page: "Strock Transfer",
            ),
          ),
          Positioned(
            top: 160,
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
              child: Column(
                children: [
                  // if (type == "Home")
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 10, right: 10, top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       ActionButton(
                  //         icon: EneftyIcons.shopping_bag_outline,
                  //         label: 'Purchase',
                  //         onTap: () {
                  //           showPurchasePopup(
                  //             context,
                  //             transactionSettingsController
                  //                 .enableImportPurchase,
                  //             transactionSettingsController
                  //                 .enablePurchaseOrder,
                  //           );
                  //         },
                  //       ),
                  //       ActionButton(
                  //         icon: EneftyIcons.receipt_2_2_outline,
                  //         label: 'Expense',
                  //         onTap: () {
                  //           Get.to(() => ExpenseTab());
                  //         },
                  //       ),
                  //       ActionButton(
                  //         icon: EneftyIcons.discount_shape_outline,
                  //         label: 'Sale',
                  //         onTap: () {
                  //           var c = Get.put(ItemScreenController());
                  //           c.onInit();
                  //           showSalePopup(
                  //             context,
                  //             transactionSettingsController
                  //                 .enableDeliveryChallan,
                  //             transactionSettingsController.enableEstimate,
                  //             transactionSettingsController.enableExportSales,
                  //             transactionSettingsController.enableSalesOrder,
                  //           );
                  //         },
                  //       ),
                  //       ActionButton(
                  //         icon: EneftyIcons.more_outline,
                  //         label: 'Transfer',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              homeController.searchSalesInvoice(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for a transaction',
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 202, 201, 201),
                              ),
                              suffixIcon: const Icon(
                                EneftyIcons.search_normal_2_outline,
                                color: Color.fromARGB(255, 6, 50, 115),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                    255,
                                    225,
                                    224,
                                    224,
                                  ),
                                ), // Border color when not focused
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 6, 50, 115),
                                  width: 2,
                                ), // Border color when focused
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () {
                                return isLoading.value == true
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : homeController.allInvoice.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Empty list",
                                              style: interFontBlack(context),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: homeController
                                                .allInvoice.length,
                                            itemBuilder: (context, index) {
                                              InvoiceModel ob = homeController
                                                  .allInvoice[index];
                                              return TransactionCard(
                                                object: ob,
                                              );
                                            },
                                          );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
