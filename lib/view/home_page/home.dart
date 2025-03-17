// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/controller/transaction_controller/transaction_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/invoice_model.dart';
import 'package:newthijar/view/expense/expense_tab.dart';
import 'package:newthijar/view/home_page/sub_screen/add_sale_scree.dart/add_sale.dart';
import 'package:newthijar/view/home_page/sub_screen/stock_transfer/stock_transfer.dart';
import 'package:newthijar/view/home_page/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/db/db.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class HomePage extends StatelessWidget {
  bool isSwitch;
  final Repository repository = Repository();
  final businessController = Get.put(BusinessController());
  String? type;
  HomePage({super.key, required this.isSwitch, this.type});

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
          "Add New Sale",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          var controller = Get.put(
            TransactionDetailController(),
          );
          controller.youRedting.value = false;
          controller.isChecked.value = false;
          controller.clearController();
          controller.clearItemController();
          controller.calculateTotalAmount();
          controller.fetchInvoicNo();
          Get.to(() => AddSalePage());
        },
        backgroundColor:
            const Color.fromARGB(255, 6, 50, 115), // Dark blue color
        icon: const Icon(
          EneftyIcons.add_outline,
          color: Colors.white, // White icon color
          size: 28,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              balance: "989.55",
              page: "Home",
            ),
          ),
          Positioned(
            top: 200,
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
                  if (type == "Home")
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton(
                            icon: EneftyIcons.shopping_bag_outline,
                            label: 'Purchase',
                            onTap: () {
                              showPurchasePopup(
                                context,
                                transactionSettingsController
                                    .enableImportPurchase,
                                transactionSettingsController
                                    .enablePurchaseOrder,
                              );
                            },
                          ),
                          ActionButton(
                            icon: EneftyIcons.receipt_2_2_outline,
                            label: 'Expense',
                            onTap: () {
                              Get.to(() => ExpenseTab());
                            },
                          ),
                          ActionButton(
                            icon: EneftyIcons.discount_shape_outline,
                            label: 'Sale',
                            onTap: () {
                              var c = Get.put(ItemScreenController());
                              c.onInit();
                              showSalePopup(
                                context,
                                transactionSettingsController
                                    .enableDeliveryChallan,
                                transactionSettingsController.enableEstimate,
                                transactionSettingsController.enableExportSales,
                                transactionSettingsController.enableSalesOrder,
                              );
                            },
                          ),
                          ActionButton(
                            icon: EneftyIcons.arrow_swap_horizontal_outline,
                            label: 'Transfer',
                            onTap: () {
                              Get.to(() => StockTransfer());
                            },
                          ),
                        ],
                      ),
                    ),
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
