// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/model/item_bar_list_model.dart';
import 'package:newthijar/view/master_tab/items_screen/sub_screen/add_new_item.dart';
import 'package:newthijar/view/master_tab/items_screen/widgets/widgets.dart';
import 'package:newthijar/view/report/sub_screens/cash_flow_report/widgets/widgets.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class ItemScreen extends StatelessWidget {
  ItemScreen({super.key});
  final HomeController homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  final controller = Get.put(ItemScreenController());

  var controllerB = Get.put(BusinessController());

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!controller.isFetchingMore.value &&
            controller.itemList.isNotEmpty) {
          controller.fetchItemList(isLoadMore: true);
        }
      }
    });
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add New Item",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          controller.youUpdating.value = false;
          controller.itemNameController.text = '';
          controller.itemCodeController.text = '';
          controller.cateController.text = '';
          controller.itemHsnCodeController.text = '';
          controller.clearControllers();
          controller.clearUnitValues();
          Get.to(() => const AddNewItem());
        },
        backgroundColor:
            const Color.fromARGB(255, 6, 50, 115), // Dark blue color
        icon: const Icon(
          EneftyIcons.add_outline,
          color: Colors.white, // White icon color
          size: 28,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller.searchController,
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
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                      icon: EneftyIcons.shopping_bag_outline,
                      label: 'Online Store',
                      isSelected: true),
                  ActionButton(
                      icon: EneftyIcons.box_3_outline, label: 'Stock Summary'),
                  ActionButton(
                      icon: EneftyIcons.setting_2_outline,
                      label: 'Item Settings'),
                  ActionButton(
                      icon: EneftyIcons.more_outline, label: 'Show More'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Color.fromARGB(255, 224, 223, 223),
          ),
          Obx(
            () {
              return isLoading.value == true
                  ? const Center(child: CircularProgressIndicator())
                  : controller.itemList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 80.h),
                          child: Text(
                            "No data",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: controller.itemList.length +
                                  (controller.isFetchingMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                ItemBarList obj = controller.itemList[index];
                                return TransactionCard(
                                  title: obj.itemName.toString(),
                                  salePrice: obj.salePrice.toString(),
                                  purchasePrice: obj.purchasePrice.toString(),
                                  date: formatDate(
                                    obj.stock!.lastUpdated.toString(),
                                  ),
                                  opStock: obj.stock?.totalQuantity.toString(),
                                );
                              },
                            ),
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
