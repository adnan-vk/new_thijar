// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/controller/item_settings_controller/item_settings_controller.dart';
import 'package:newthijar/model/category_model.dart';
import 'package:newthijar/model/tax_model.dart';
import 'package:newthijar/model/unit_model.dart';
import 'package:newthijar/utils/bar_code_number_generator.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_item_unit.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/item_settings_screen.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

final ItemSettingController itemSettingsController = ItemSettingController();

class _AddItemPageState extends State<AddItemPage>
    with SingleTickerProviderStateMixin {
  String? selectedUnit;
  bool showAdditionalFields = true; // Flag to control additional fields
  String? selectedValue;

  late TabController _tabController; // For controlling the tab switching

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // ItemScreenController().fetchAllGodowns();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // itemNameController.dispose();
    super.dispose();
  }

  final controller = Get.find<ItemScreenController>();
  @override
  Widget build(BuildContext context) {
    itemSettingsController.fetchSettingData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add/Edit Item',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
            onPressed: () {
              // Handle camera icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              // Handle settings icon press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Text(
            //       isProductSelected ? 'Product' : 'Services',
            //       style: const TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black,
            //       ),
            //     ),
            //     Switch(
            //       value: isProductSelected,
            //       onChanged: (value) {
            //         setState(() {
            //           isProductSelected = value;
            //         });
            //       },
            //       activeColor: Colors.blue,
            //     ),
            //     Text(
            //       isProductSelected ? 'Services' : 'Product',
            //       style: const TextStyle(fontSize: 18, color: Colors.black),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Toggle Container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(20),
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
                        activeTrackColor: Colors.blue,
                      ),

                      // Services Option
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: controller.isProductSelected
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Obx(
                () => Column(
                  children: [
                    TextFormField(
                      controller: controller.itemNameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
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
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                    if (itemSettingsController
                            .settingModel.value.data?.enableItemCode ==
                        true)
                      const SizedBox(height: 16),

                    // Conditionally display the rest of the form fields
                    if (showAdditionalFields) ...[
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemCode ==
                          true)
                        TextFormField(
                          controller: controller.itemCodeController,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                          decoration: InputDecoration(
                            labelText: 'Item Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            suffixIcon: _buildAssignCodeButton(context),
                          ),
                        ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemCategory ==
                          true)
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                showCateGorySelectionBottomSheet(context);
                              },
                              child: TextFormField(
                                controller: controller.cateController,
                                enabled: false,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.sp),
                                decoration: InputDecoration(
                                  labelText: 'Item Category',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemHsn ==
                          true)
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.itemHsnCodeController,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.sp),
                              decoration: InputDecoration(
                                labelText: 'HSN/SAV Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            if (showAdditionalFields)
              TabBar(
                controller: _tabController,
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (value) {
                  // setState(() {});
                },
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
                    pricingTab(),
                    if (controller.isProductSelected == false) stockTab(),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Cancel action
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Obx(
                () {
                  return isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // if (controller.selectedTaxValue.value.id
                            //             ?.toString() ==
                            //         "id" ||
                            //     controller.selectedTaxValue.value.id == null ||
                            //     controller.selectedTaxValue.value.id == "") {
                            //   SnackBars.showErrorSnackBar(
                            //       text: "Please select tax rate.");
                            // } else
                            if (!controller.isProductSelected &&
                                (controller.selectedPrimaryUnit.value.id ==
                                        null ||
                                    controller.selectedPrimaryUnit.value.id ==
                                        "")) {
                              // Validate Unit only when isProductSelected is false
                              // controller.resetAllFields();
                              // controller.unitList.clear();
                              // controller.primaryUnitList.clear();
                              // controller.allConversionReferences.clear();
                              // controller.fetchUnitList();
                              SnackBars.showErrorSnackBar(
                                  text: "Please Select Unit");
                              // Get.to(() => AddItemUnitPage());
                            } else if (controller.itemNameController.text
                                .trim()
                                .isEmpty) {
                              SnackBars.showErrorSnackBar(
                                  text: "Please enter item name.");
                            } else {
                              controller.selectedLocation.value = "";
                              controller.unitList.clear();

                              if (controller.youUpdating.value) {
                                controller.selectedSecondaryUnit.value.id ==
                                        null
                                    ? controller.updateItem()
                                    : controller.updateItemwithtwounits();
                              } else {
                                controller.selectedLocation.value = "";
                                controller.newConversionId.value == ""
                                    ? controller.addItem()
                                    : controller.addItemWithConversion();
                                controller.unitList.clear();
                              }
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  pricingTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tabs for Pricing and Online Store
          if (showAdditionalFields)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sale Price Row with Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                        controller: controller.salePriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Sale Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: Obx(() {
                        return Text(
                          controller.salesPriceIncludingTax.value
                              ? 'With Tax'
                              : 'Without Tax',
                        );
                      }),
                      // value: 'Without Tax', // Default value
                      items: ['Without Tax', 'With Tax'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.salesPriceIncludingTax.value =
                            newValue.toString() == 'With Tax' ? true : false;
                        // Handle dropdown change
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (controller.isProductSelected == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                          controller: controller.purchasePriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Purchase Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        hint: Obx(() {
                          return Text(
                            controller.purchasePriceIncludingTax.value
                                ? 'With Tax'
                                : 'Without Tax',
                          );
                        }), // Default value
                        items: ['Without Tax', 'With Tax'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          controller.purchasePriceIncludingTax.value =
                              newValue.toString() == 'With Tax' ? true : false;
                          // Handle dropdown change
                        },
                      ),
                    ],
                  ),
                if (controller.isProductSelected == false)
                  const SizedBox(height: 16),

                // Discount on Sale Price with Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Disc. On Sale Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: controller.discOnSaleController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: Obx(() {
                        return Text(
                          controller.discountType.value,
                        );
                      }),
                      // value: 'Percentage', // Default value
                      items: ['Percentage', 'Fixed Amount'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.discountType.value = newValue.toString();

                        // Handle dropdown change
                      },
                    ),
                  ],
                ),
                // TextFormField(
                //   controller: controller.itemHsnCodeController,
                //   style: TextStyle(color: Colors.black, fontSize: 16.sp),
                //   decoration: InputDecoration(
                //     labelText: 'HSN/SAV Code',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),

                // Add Wholesale Price Button
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: TextButton.icon(
                //     onPressed: () {
                //       // Handle Add Wholesale Price logic
                //     },
                //     icon: const Icon(Icons.add),
                //     label: const Text('Add Wholesale Price'),
                //   ),
                // ),
                // const SizedBox(height: 16),

                // Taxes Dropdown
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (itemSettingsController
                                  .settingModel.value.data?.enableItemMrp ==
                              true &&
                          controller.isProductSelected == false)
                        Expanded(
                          child: TextFormField(
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'MRP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            controller: controller.mrpController,
                          ),
                        ),
                      if (itemSettingsController
                              .settingModel.value.data?.enableItemMrp ==
                          true)
                        const SizedBox(width: 16),
                      Obx(() {
                        return Expanded(
                          child: InkWell(
                            onTap: () {
                              showTaxsDialog(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.w, color: Colors.grey.shade300),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8.0.r),
                                child: Text(
                                  "${controller.selectedTaxValue.value.rate.toString()} % ${controller.selectedTaxValue.value.taxType.toString()}",
                                  style: TextStyle(
                                      color: controller.taxList.isEmpty
                                          ? Colors.grey.shade400
                                          : Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                if (_tabController.index == 1) ...{
                  TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Online Store Item Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Online Store Item Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black)),
                    ),
                  ),
                }
              ],
            ),
        ],
      ),
    );
  }

  stockTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opening Stock
          _buildInputField(
              label: 'Opening Stock',
              hint: 'Ex: 300',
              controller: controller.openingStockCon,
              inputFormate: [FilteringTextInputFormatter.digitsOnly]),

          const SizedBox(height: 16),

          // As of Date and At Price/Unit
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    String? date = await ContextProvider().selectDate(context);
                    log("date ==$date");
                    controller.stockDateCon.text = date.toString();
                  },
                  child: _buildInputField(
                      label: 'As of Date',
                      hint: '21/12/2024',
                      controller: controller.stockDateCon,
                      isDatePicker: true,
                      isEditable: false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                    label: 'At Price/Unit',
                    hint: 'Ex: 2,000',
                    controller: controller.stockPriceUnitCont,
                    inputFormate: [FilteringTextInputFormatter.digitsOnly]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Min Stock Qty and Item Location
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                    label: 'Min Stock Qty',
                    hint: 'Ex: 5',
                    controller: controller.stockMinQtyCont,
                    inputFormate: [FilteringTextInputFormatter.digitsOnly]),
              ),
              const SizedBox(width: 16),
              // Expanded(
              //   child: _buildInputField(
              //       label: 'Item Location',
              //       controller: controller.itemLocationCont),
              // ),
              Expanded(
                child: Obx(() => controller.locationList.isEmpty
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Item Location',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        value: controller.selectedLocation.value.isEmpty
                            ? null
                            : controller.selectedLocation.value,
                        items: controller.locationList.map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            controller.selectedLocation.value = newValue;
                            controller.itemLocationCont.text =
                                controller.selectedLocation.value;
                          }
                        },
                      )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? hint,
    bool isDatePicker = false,
    bool? isEditable,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormate,
    context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: isDatePicker,
          enabled: isEditable,
          style: const TextStyle(
            color: Colors.black,
          ),
          inputFormatters: inputFormate,
          decoration: InputDecoration(
              hintText: hint,
              labelText: "$label ⓘ",
              suffixIcon: isDatePicker
                  ? const Icon(Icons.calendar_today,
                      size: 20, color: Colors.grey)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          onTap: isDatePicker
              ? () {
                  // Show date picker
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                }
              : null,
        ),
      ],
    );
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
                  title: const Text("Select Category"),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
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
                                                    BorderRadius.circular(16.r),
                                                color: Colors.blue),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.r),
                                              child: Text(
                                                "Cencel",
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
                                                    BorderRadius.circular(16.r),
                                                color: Colors.blue),
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
                            borderRadius: BorderRadius.circular(13.r),
                            color: Colors.blue),
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

  void showUnitsDialog(context) {
    controller.fetchUnitList();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Unit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
            ),
          ),
          content: Obx(() {
            return isLoading.value == true
                ? SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: controller.unitList.map((unit) {
                            UnitModel ob = unit;
                            return ListTile(
                              title: Text(
                                ob.name.toString(),
                              ),
                              onTap: () {
                                controller.selectedUnitModel.value = ob;
                                Get.back();
                              },
                            );
                          }).toList(),
                        ),
                        InkWell(
                          onTap: () => Get.to(
                            () => AddItemUnitPage(),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Add"),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
          }),
        );
      },
    );
  }

  void showTaxsDialog(context) {
    controller.fetchTax();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Tax',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
            ),
          ),
          content: Obx(() {
            return isLoading.value == true
                ? SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.taxList.isEmpty
                            ? Column(
                                children: [
                                  Text(
                                    "Please enable VAT or GST to retrieve the tax rates list.",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();

                                      Get.to(
                                        () => ItemSettingScreen(),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("Item Setting"),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: controller.taxList.map((unit) {
                            TaxModel ob = unit;
                            return ListTile(
                              title: Text(
                                "${ob.rate} ${ob.taxType}",
                              ),
                              onTap: () {
                                log("tax rate in add item screen : $ob");
                                controller.selectedTaxValue.value = ob;
                                Get.back();
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
          }),
        );
      },
    );
  }

  // Build Unit Button
  Widget _buildUnitButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade50, width: 1),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade50,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
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
                  "${controller.selectedPrimaryUnit.value.id != null ? "1" : ""} ${controller.selectedPrimaryUnit.value.name} = ${controller.conversionRateValue.value.toString() ?? ""} ${controller.selectedSecondaryUnit.value.name ?? ""}",
                  style: const TextStyle(color: Colors.blue),
                );
              }),
              const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignCodeButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code_scanner),
      onPressed: () {
        _showAssignCodeDialog(context);
      },
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
                  backgroundColor: Colors.blueAccent,
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
                  backgroundColor: Colors.green,
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
                foregroundColor: Colors.redAccent,
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
}
