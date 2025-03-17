import 'dart:developer';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/model/category_model.dart';
import 'package:newthijar/utils/bar_code_number_generator.dart';
import 'package:newthijar/view/home_page/widgets/item_card_widget.dart';
import 'package:newthijar/view/master_tab/items_screen/sub_screen/widgets/widget.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_item_unit.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddNewItem extends StatefulWidget {
  final int? itemIndex;
  const AddNewItem({super.key, this.itemIndex});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem>
    with SingleTickerProviderStateMixin {
  String? selectedUnit;
  bool showAdditionalFields = true; // Flag to control additional fields
  String? selectedValue;

  late TabController _tabController; // For controlling the tab switching

  final controller = Get.find<ItemScreenController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    itemSettingsController.fetchSettingData();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(context),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: TopBar(
              page: "Add / Edit Item",
            ),
          ),
          Positioned(
            top: 165,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle between Product and Services
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Toggle Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  // Product Option
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: controller.isProductSelected
                                          ? Colors.transparent
                                          : const Color.fromARGB(
                                              255, 6, 50, 115),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Product',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: controller.isProductSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),

                                  // Switch
                                  Switch(
                                    value: controller.isProductSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.isProductSelected = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor:
                                        const Color.fromARGB(255, 6, 50, 115),
                                  ),

                                  // Services Option
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: controller.isProductSelected
                                          ? const Color.fromARGB(
                                              255, 6, 50, 115)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Services',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: controller.isProductSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextFormField(
                          controller: controller.itemNameController,
                          decoration: InputDecoration(
                            labelText: 'Item Name *',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12), // Added padding
                            suffixIcon: controller.isProductSelected == false
                                ? _buildUnitButton()
                                : null,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && !showAdditionalFields) {
                              setState(() {
                                showAdditionalFields =
                                    true; // Show additional fields
                              });
                            }
                          },
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                      ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemCode ==
                          true)
                        buildCustomTextField(
                          context: context,
                          controller: controller.itemCodeController,
                          label: 'Item Code',
                          suffixIcon: EneftyIcons.scan_barcode_outline,
                          onIconPressed: () => _showAssignCodeDialog(context),
                        ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemCategory ==
                          true)
                        buildCustomTextField(
                          context: context,
                          isDatePicker: true,
                          onTap: () {
                            showCateGorySelectionBottomSheet(context);
                          },
                          label: 'Item Category',
                          controller: controller.cateController,
                        ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemHsn ==
                          true)
                        buildCustomTextField(
                          context: context,
                          label: 'HSN/SAV Code',
                          controller: controller.itemHsnCodeController,
                        ),
                      const SizedBox(height: 20),
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 6, 50, 115),
                        indicatorColor: const Color.fromARGB(255, 6, 50, 115),
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (value) {},
                        tabs: [
                          const Tab(text: 'Pricing'),
                          if (controller.isProductSelected == false)
                            const Tab(text: 'Stock'),
                        ],
                      ),
                      if (showAdditionalFields)
                        SizedBox(
                          height: 300.h, // Set a fixed height for TabBarView
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              buildPricingFields(
                                  controller: controller, context: context),
                              if (controller.isProductSelected == false)
                                buildStockFields(controller, context),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
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

  Widget _buildUnitButton() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 6, 50, 115),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: TextButton(
          onPressed: () {
            controller.resetAllFields();
            controller.unitList.clear();
            controller.primaryUnitList.clear();
            controller.allConversionReferences.clear();
            controller.fetchUnitList();
            controller.clearUnitValues();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemUnitPage()),
            );
            // showUnitsDialog(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return Text(
                  "${controller.selectedPrimaryUnit.value.id != null ? "1" : ""} ${controller.selectedPrimaryUnit.value.name} = ${controller.conversionRateValue.value.toString()} ${controller.selectedSecondaryUnit.value.name ?? ""}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                );
              }),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.qr_code_2, color: Colors.blue),
              SizedBox(width: 8),
              Text("Assign Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 50, 115),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Perform barcode scanning
                  await _scanBarcode(context);
                  Get.back(); // Close the dialog after scanning
                },
                icon: const Icon(
                  Icons.qr_code_scanner,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  "Scan Barcode",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 111, 191),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Generate a manual code
                  String barcodeNumber = barcodeNumberGenerator();
                  controller.itemCodeController.text = barcodeNumber;
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.edit,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  "Assign Code",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 6, 50, 115),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  _scanBarcode(BuildContext context) async {
    // Check camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        String? barcode = await SimpleBarcodeScanner.scanBarcode(
          context,
          barcodeAppBar: const BarcodeAppBar(
            appBarTitle: 'Test',
            centerTitle: false,
            enableBackButton: true,
            backButtonIcon: Icon(Icons.arrow_back_ios),
          ),
          isShowFlashIcon: true,
          delayMillis: 2000,
          cameraFace: CameraFace.back,
        );
        if (barcode != '-1') {
          // If a valid barcode is scanned, update the controller
          controller.itemCodeController.text = barcode.toString();
          log("Scanned barcode: $barcode");
        } else {
          log("Barcode scan canceled");
        }
      } catch (e) {
        log("Error scanning barcode: $e");
      }
    }
  }

  void showCateGorySelectionBottomSheet(context) {
    if (controller.categoryList.length.toInt() == 0) {
      controller.fetchCategories();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (_, controllers) {
            return Column(
              children: [
                // Header of Bottom Sheet
                ListTile(
                  title: const Text(
                    "Select Category",
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 50, 115),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 6, 50, 115),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 14.w),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        controller.categoryTextController.clear();
                        Get.dialog(Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: CustomTextFormField(
                                        filledColor: Colors.white,
                                        isFiled: true,
                                        controller:
                                            controller.categoryTextController,
                                        hintText: "Enter Category name *",
                                        labelText: "Enter Category name *",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 6, 50, 115)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.r),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // Get.back();
                                            controller.validatecategoryFiled()
                                                ? controller.addCategory()
                                                : null;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: const Color.fromARGB(
                                                    255, 6, 50, 115)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.r),
                                              child: Obx(() {
                                                return Text(
                                                  isLoading.value
                                                      ? "Processing..."
                                                      : "Save",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: const Color.fromARGB(255, 6, 50, 115)),
                        child: Padding(
                          padding: EdgeInsets.all(6.0.r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Add Category",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Obx(() {
                  return Expanded(
                    child: isLoading.value == true
                        ? Center(
                            child: SizedBox(
                              height: 80.w,
                              width: 80.w,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : controller.categoryList.length.toInt() == 0
                            ? Center(
                                child: Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      fontSize: 20.sp, color: Colors.black),
                                ),
                              )
                            : ListView.builder(
                                controller: controllers,
                                itemCount: controller.categoryList.length,
                                itemBuilder: (context, index) {
                                  CategoryModel obj =
                                      controller.categoryList[index];
                                  return ListTile(
                                    title: Text(
                                      obj.name.toString(),
                                    ),
                                    onTap: () {
                                      controller.selectedCate.value = obj;
                                      controller.cateController.text =
                                          obj.name.toString();

                                      Get.back();
                                    },
                                  );
                                },
                              ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
