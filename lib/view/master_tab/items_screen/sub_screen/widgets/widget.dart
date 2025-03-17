import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/model/tax_model.dart';
import 'package:newthijar/view/home_page/widgets/item_card_widget.dart';
import 'package:newthijar/view/menu/sub_screens/settings/sub_screens/item_settings_screen.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

Widget buildBottomButtons(BuildContext context) {
  final controller = Get.find<ItemScreenController>();
  return Row(
    children: [
      Expanded(
        child: Container(
          height: 50, // Set height to match the image
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 50, // Set height to match the image
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 50, 115),
                Color.fromARGB(255, 30, 111, 191)
              ], // Gradient blue
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: TextButton(
            onPressed: () {
              if (!controller.isProductSelected &&
                  (controller.selectedPrimaryUnit.value.id == null ||
                      controller.selectedPrimaryUnit.value.id == "")) {
                // Validate Unit only when isProductSelected is false
                // controller.resetAllFields();
                // controller.unitList.clear();
                // controller.primaryUnitList.clear();
                // controller.allConversionReferences.clear();
                // controller.fetchUnitList();
                SnackBars.showErrorSnackBar(text: "Please Select Unit");
                // Get.to(() => AddItemUnitPage());
              } else if (controller.itemNameController.text.trim().isEmpty) {
                SnackBars.showErrorSnackBar(text: "Please enter item name.");
              } else {
                controller.selectedLocation.value = "";
                controller.unitList.clear();

                if (controller.youUpdating.value) {
                  controller.selectedSecondaryUnit.value.id == null
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
              "Save",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildCustomTextField({
  String? label,
  String? hint,
  IconData? suffixIcon,
  bool isDatePicker = false,
  VoidCallback? onIconPressed,
  TextEditingController? controller,
  GestureTapCallback? onTap,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                readOnly: isDatePicker,
                controller: controller,
                onTap: onTap, // Handle the tap event
                decoration: InputDecoration(
                  suffixIcon: isDatePicker
                      ? const Icon(Icons.calendar_today,
                          size: 20, color: Colors.grey)
                      : null,
                  labelText: label,
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (suffixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: onIconPressed,
                icon: Icon(suffixIcon, color: Colors.grey),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget buildNameTextField(
  String label,
  String hint,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildPricingFields(
    {required BuildContext context, required controller}) {
  return Obx(
    () => Column(
      children: [
        buildDropdownField(
          label: 'Sale Price',
          value: controller.salesPriceIncludingTax.value
              ? 'With Tax'
              : 'Without Tax',
          controller: controller.salePriceController,
          dropdownItems: ['With Tax', 'Without Tax'],
          onChnaged: (newValue) {
            controller.salesPriceIncludingTax.value =
                newValue.toString() == 'With Tax';
          },
        ),
        buildDropdownField(
          controller: controller.purchasePriceController,
          label: 'Purchase Price',
          value: controller.purchasePriceIncludingTax.value
              ? 'With Tax'
              : 'Without Tax',
          dropdownItems: ['With Tax', 'Without Tax'],
          onChnaged: (newValue) {
            controller.purchasePriceIncludingTax.value =
                newValue.toString() == 'With Tax';
          },
        ),
        buildDropdownField(
          controller: controller.discOnSaleController,
          label: 'Disc. On Sale Price',
          value: controller.discountType.value,
          dropdownItems: ['Percentage', 'Fixed Amount'],
          onChnaged: (newValue) {
            controller.discountType.value = newValue.toString();
          },
        ),
        if (itemSettingsController.settingModel.value.data?.enableItemMrp ==
                true &&
            controller.isProductSelected == false)
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (itemSettingsController
                              .settingModel.value.data?.enableItemMrp ==
                          true &&
                      controller.isProductSelected == false)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'MRP',
                            border: InputBorder.none,
                          ),
                          controller: controller.mrpController,
                        ),
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
                          showTaxsDialog(
                              context); // Context is now passed correctly
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0.r),
                          child: Text(
                            "${controller.selectedTaxValue.value.rate.toString()} % ${controller.selectedTaxValue.value.taxType.toString()}",
                            style: TextStyle(
                              color: controller.taxList.isEmpty
                                  ? Colors.grey.shade400
                                  : Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

// Stock fields
Widget buildStockFields(controller, context) {
  return Column(
    children: [
      buildCustomTextField(
          label: 'Opening Stock',
          controller: controller.openingStockCon,
          context: context),
      Row(
        children: [
          Expanded(
            child: buildCustomTextField(
              context: context,
              label: 'As of Date',
              hint: '21/12/2024',
              controller: controller.stockDateCon,
              isDatePicker: true,
              onTap: () async {
                String? date = await ContextProvider().selectDate(context);
                log("date == $date");
                if (date != null) {
                  controller.stockDateCon.text = date; // Update the controller
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildCustomTextField(
              context: context,
              label: 'At Price/Unit',
              hint: 'Ex: 2,000',
              controller: controller.stockPriceUnitCont,
            ),
          ),
        ],
      ),
      buildCustomTextField(
        label: 'Min Stock Qty',
        hint: 'Ex: 5',
        context: context,
        controller: controller.stockMinQtyCont,
      ),
      Expanded(
        child: Obx(() => controller.locationList.isEmpty
            ? const CircularProgressIndicator()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Item Location',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  value: controller.selectedLocation.value.isEmpty
                      ? null
                      : controller.selectedLocation.value,
                  items: controller.locationList
                      .map<DropdownMenuItem<String>>((location) {
                    // Explicit type declaration
                    return DropdownMenuItem<String>(
                      value: location
                          .toString(), // Ensure it's treated as a String
                      child: Text(location.toString()), // Ensure String value
                    );
                  }).toList(), // Convert to List<DropdownMenuItem<String>>
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedLocation.value = newValue;
                      controller.itemLocationCont.text =
                          controller.selectedLocation.value;
                    }
                  },
                ),
              )),
      ),
      const SizedBox(
        height: 40,
      ),
    ],
  );
}

Widget buildDropdownField({
  String? label,
  String? value,
  TextEditingController? controller,
  required List<String> dropdownItems, // Accept list of values
  Function(String?)? onChnaged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
              onChanged: onChnaged,
            ),
          ),
        ],
      ),
    ),
  );
}

void showTaxsDialog(context) {
  final controller = Get.find<ItemScreenController>();
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
                                      borderRadius: BorderRadius.circular(8.r),
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
