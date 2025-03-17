import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/constants/money_symbol.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/item_bar_list_model.dart';
import 'package:newthijar/model/tax_model.dart';
import 'package:newthijar/model/unit_model.dart';
import 'package:newthijar/view/home_page/sub_screen/add_sale_item/widgets/widgets.dart';
import 'package:newthijar/view/home_page/widgets/item_card_widget.dart';
import 'package:newthijar/view/master_tab/items_screen/sub_screen/add_new_item.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class AddSaleItem extends StatefulWidget {
  final int? itemIndex;
  const AddSaleItem({super.key, this.itemIndex});

  @override
  State<AddSaleItem> createState() => _AddSaleItemState();
}

class _AddSaleItemState extends State<AddSaleItem> {
  @override
  void initState() {
    _controller.unitModel.value = UnitModel();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        itemController.fetchItemList(isLoadMore: true);
      },
    );
    super.initState();
  }

  final GlobalKey<FormState> addItemKey = GlobalKey<FormState>();

  final _controller = Get.put(TransactionDetailController());

  final itemController = Get.put(ItemScreenController());

  @override
  Widget build(BuildContext context) {
    itemSettingsController.fetchSettingData();
    final priceDecimalPlace =
        itemSettingsController.priceNotifier.value.toInt();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(
        context,
        controller: _controller,
        itemIndex: widget.itemIndex,
        priceDecimalPlace: priceDecimalPlace,
      ),
      backgroundColor: Colors.white,
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Obx(() {
                        return DropdownSearch<ItemBarList>(
                          items: (filter, loadProps) async {
                            itemController.fetchItemList(isLoadMore: true);

                            return itemController.filterdItemList;
                          },
                          itemAsString: (item) => item.itemName ?? "",
                          selectedItem: itemController.selectedItem.value,
                          onChanged: (value) {
                            _controller.conversionRate.value = 1.0;
                            _controller.priceForBaseUnit.value = 0.0;
                            _controller.isSecondaryChoosed.value = false;
                            _controller.unitNames.clear();
                            _controller.secondaryUnitName.value = '';
                            _controller.primaryUnitName.value = '';

                            _controller.quantityContr.text = '';
                            itemController.selectedItem.value = value;

                            if (value != null) {
                              _controller.clearItemControllerWithoutItemName();
                              _controller.unitModel.value = UnitModel();
                              if ((value.stock?.totalQuantity ?? 0) < 10) {
                                showLowStockAlertDialog(context);
                              }
                              if (value.salePriceIncludesTax!) {
                                _controller.isTaxOrNo.value = "With Tax";
                              } else {
                                _controller.isTaxOrNo.value = "Without Tax";
                              }
                              _controller.isTaxOrNo.refresh();

                              _controller.itemNameContr.text =
                                  value.itemName.toString();
                              _controller.priceContr.text = value.salePrice!
                                  .toStringAsFixed(priceDecimalPlace);
                              _controller.mrpContr.text = value.mrp
                                      ?.toStringAsFixed(priceDecimalPlace) ??
                                  "";
                              _controller.isPriceEntered.value = true;

                              if (value.unit != null) {
                                _controller.unitModel.value = UnitModel(
                                  id: value.unit!.id.toString(),
                                  name: value.unit!.name.toString(),
                                  shortName: value.unit!.shortName.toString(),
                                );
                                _controller.primaryUnitName.value =
                                    value.unit!.name ?? "Error fetching";
                                _controller.unitModel.value.name =
                                    value.unit!.name ?? "Error fetching";
                              }

                              // Store baseUnit.name and secondaryUnit.name in a globally accessible list
                              // Store baseUnit and secondaryUnit details in a globally accessible list
                              _controller.unitNames.clear();
                              _controller.priceForBaseUnit.value =
                                  double.parse(value.salePrice.toString());
                              if (value.unitConversion != null) {
                                if (value.unitConversion!.baseUnit != null) {
                                  _controller.primaryUnitName.value =
                                      value.unitConversion!.baseUnit!.name ??
                                          "Error fetching";
                                  _controller.unitModel.value.name =
                                      value.unitConversion!.baseUnit!.name ??
                                          "Error fetching";
                                  _controller.unitNames.add({
                                    "id": value.unitConversion!.baseUnit!.id
                                        .toString(),
                                    "name":
                                        value.unitConversion!.baseUnit!.name ??
                                            "Error",
                                    "shortName": value.unitConversion!.baseUnit!
                                            .shortName ??
                                        "",
                                  });
                                }
                                if (value.unitConversion!.secondaryUnit !=
                                    null) {
                                  _controller.secondaryUnitName.value = value
                                          .unitConversion!
                                          .secondaryUnit!
                                          .name ??
                                      "Error fetching";
                                  _controller.unitNames.add({
                                    "id": value
                                        .unitConversion!.secondaryUnit!.id
                                        .toString(),
                                    "name": value.unitConversion!.secondaryUnit!
                                            .name ??
                                        "Error",
                                    "shortName": value.unitConversion!
                                            .secondaryUnit!.shortName ??
                                        "",
                                  });
                                }

                                // Store conversionRate in the controller
                                if (value.unitConversion!.conversionRate !=
                                    null) {
                                  _controller.conversionRate.value =
                                      double.parse(value
                                          .unitConversion!.conversionRate!
                                          .toString());
                                }
                                double currentRate =
                                    _controller.conversionRate.value;
                                print("conversionRate $currentRate");
                              }

                              if (value.taxRate != null) {
                                _controller.selectedTax.value = TaxModel(
                                  id: value.taxRate!.id.toString(),
                                  rate: value.taxRate!.rate.toString(),
                                  taxType: value.taxRate!.taxType.toString(),
                                );
                              }
                            }
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              hintText: _controller.isEditingItem.value
                                  ? _controller.itemNameContr.text
                                  : "e.g. Chocolate Cake",
                              constraints: BoxConstraints(maxHeight: 50.h),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w,
                                      color: Colorconst
                                          .cGrey), // Scalable border width
                                  borderRadius: BorderRadius.circular(5.r)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5.r)),

                              //add item button
                              suffixIcon: InkWell(
                                onTap: () {
                                  _controller.itemNameContr.text = '';
                                  itemController.filterdItemList.assignAll([]);
                                  Get.to(() => const AddNewItem());
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 25.sp,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          suffixProps: const DropdownSuffixProps(
                              dropdownButtonProps:
                                  DropdownButtonProps(isVisible: false)),
                          compareFn: (item1, item2) {
                            return item1.itemName?.trim().toLowerCase() ==
                                item2.itemName?.trim().toLowerCase();
                          },
                          dropdownBuilder: (context, selectedItem) {
                            return Text(selectedItem?.itemName ?? "",
                                style: const TextStyle(color: Colors.black));
                          },
                          popupProps: PopupProps.menu(
                            cacheItems: true,
                            showSearchBox: true,
                            containerBuilder: (context, popupWidget) =>
                                Container(
                              color: Colors.white,
                              child: popupWidget,
                            ),
                            searchFieldProps: TextFieldProps(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Search & Select Item",
                                constraints: BoxConstraints(maxHeight: 50.h),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w,
                                        color: Colorconst
                                            .cGrey), // Scalable border width
                                    borderRadius: BorderRadius.circular(5.r)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5.r)),
                              ),
                            ),
                            itemBuilder:
                                (context, item, isDisabled, isSelected) {
                              return Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    title: Text(
                                      item.itemName ?? "",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      "Price: ${item.salePrice}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Stock: ${item.stock?.totalQuantity ?? 0}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          Text(item.unitConversion
                                                  ?.conversionRate
                                                  .toString() ??
                                              "1")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            searchDelay: const Duration(milliseconds: 500),
                          ),
                        );
                      }),
                      // CustomTextFormField(
                      //   controller: _controller.quantityContr,
                      //   keyboardType: TextInputType.number,
                      //   onChanged: (value) {
                      //     printInfo(info: "quantity changed");

                      //     // ✅ Clear discount values when quantity changes
                      //     _controller.discountContr.text = "0";
                      //     _controller.discountAmountContr.text = "0";
                      //     _controller.totalDiscount.value = 0.00;

                      //     if (_controller.quantityContr.text.isNotEmpty &&
                      //         _controller.priceContr.text.isNotEmpty) {
                      //       _controller.calculateTotalAmount(
                      //         price: double.parse(_controller.priceContr.text),
                      //         quantity:
                      //             double.parse(_controller.quantityContr.text),
                      //         discountPercentage:
                      //             0.0, // ✅ Set to 0 after clearing
                      //         taxPercentage: double.parse(
                      //           _controller.selectedTax.value.rate.toString(),
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   hintText: "Enter Quantity",
                      //   labelText: "Quantity",
                      // ),
                      Obx(
                        () => _buildTextFieldWithDropdown(
                          hint: 'Quantity',
                          dropdownHint: _controller.unitModel.value.name == null
                              ? _controller.primaryUnitName.value
                              : _controller.unitModel.value.name.toString(),
                          // onTap: _controller.secondaryUnitName.value != ''
                          //     ? showUnitsDialog(context)
                          //     : {},
                          onChanged: (value) {
                            printInfo(info: "quantity changed");

                            // ✅ Clear discount values when quantity changes
                            _controller.discountContr.text = "0";
                            _controller.discountAmountContr.text = "0";
                            _controller.totalDiscount.value = 0.00;

                            if (_controller.quantityContr.text.isNotEmpty &&
                                _controller.priceContr.text.isNotEmpty) {
                              _controller.calculateTotalAmount(
                                price:
                                    double.parse(_controller.priceContr.text),
                                quantity: double.parse(
                                    _controller.quantityContr.text),
                                discountPercentage:
                                    0.0, // ✅ Set to 0 after clearing
                                taxPercentage: double.parse(
                                  _controller.selectedTax.value.rate.toString(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Obx(
                        () => _buildTextFieldWithDropdown(
                          hint: 'Price',
                          dropdownHint: _controller.isTaxOrNo.value.toString(),
                          onChanged: (value) {
                            _controller.isPriceEntered.value =
                                value!.isNotEmpty;

                            // ✅ Clear discount values when price changes
                            _controller.discountContr.text = "0";
                            _controller.discountAmountContr.text = "0";
                            _controller.totalDiscount.value = 0.00;

                            if (_controller.priceContr.text.isNotEmpty) {
                              _controller.calculateTotalAmount(
                                price:
                                    double.parse(_controller.priceContr.text),
                                quantity: double.parse(
                                  _controller.quantityContr.text.isEmpty
                                      ? "1.0"
                                      : _controller.quantityContr.text,
                                ),
                                discountPercentage:
                                    0.0, // ✅ Reset discount after clearing
                                taxPercentage: double.parse(_controller
                                    .selectedTax.value.rate
                                    .toString()),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(height: 8.h),
                      Obx(() {
                        if (itemSettingsController.enableItemMrp.value) {
                          return _buildTextField('MRP');
                        } else {
                          return const SizedBox
                              .shrink(); // Returns an empty widget if condition is false
                        }
                      }),

                      SizedBox(height: 16.h),
                      _buildUpdatedTotalAndTaxesSection(
                          priceDecimalPlace: priceDecimalPlace),
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

  Widget _buildTextField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller.mrpContr,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithDropdown(
      {String? hint,
      String? dropdownHint,
      ValueChanged<String?>? onChanged,
      onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: hint == "Quantity"
                      ? _controller.quantityContr
                      : _controller.priceContr,
                  onChanged: (value) {
                    printInfo(info: "quantity changed");

                    // ✅ Clear discount values when quantity changes
                    _controller.discountContr.text = "0";
                    _controller.discountAmountContr.text = "0";
                    _controller.totalDiscount.value = 0.00;

                    if (_controller.quantityContr.text.isNotEmpty &&
                        _controller.priceContr.text.isNotEmpty) {
                      _controller.calculateTotalAmount(
                        price: double.parse(_controller.priceContr.text),
                        quantity: double.parse(_controller.quantityContr.text),
                        discountPercentage: 0.0, // ✅ Set to 0 after clearing
                        taxPercentage: double.parse(
                          _controller.selectedTax.value.rate.toString(),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 48.h,
                width: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: hint == "Quantity"
                        ? const Icon(
                            EneftyIcons.arrow_down_outline,
                            color: Colors.black,
                          )
                        : const SizedBox.shrink(),
                    hint: Text(
                      dropdownHint.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: onTap,
                    items: const [],
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatedTotalAndTaxesSection({priceDecimalPlace}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total & Taxes',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 6, 50, 115),
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        Obx(
          () {
            return _controller.isPriceEntered.value
                ? _buildTotalRow('Subtotal (Rate x Qty)',
                    "$moneySymbol ${_controller.subTotalP.value.toStringAsFixed(priceDecimalPlace)}",
                    isGreyedOut: true)
                : const SizedBox();
          },
        ),
        _buildDiscountField(
          controller: _controller,
          priceDecimalPlace: priceDecimalPlace,
        ),
        SizedBox(height: 12.h),
        _buildTaxPercentageField(
          priceDecimalPlace: priceDecimalPlace,
        ),
        SizedBox(height: 12.h),
        Divider(
          color: Colors.grey.shade300,
        ),
        Row(
          children: [
            Text(
              'Total Amount: ',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 6, 50, 115),
              ),
            ),
            Expanded(
              child: TextField(
                keyboardType:
                    TextInputType.number, // Optional: Restrict input to numbers
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                controller: _controller.totalAmountContr,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, amount, {bool isGreyedOut = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isGreyedOut ? Colors.grey : Colors.black,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountField({controller, priceDecimalPlace}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        const Text("Discount"),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _controller.discountAmountContr.text = "0";
                          } else {
                            double discountPercentage =
                                double.tryParse(value) ?? 0.0;
                            double price =
                                double.tryParse(_controller.priceContr.text) ??
                                    0.0;
                            double quantity = double.tryParse(
                                    _controller.quantityContr.text) ??
                                1.0;

                            // Call function to update amount & price
                            _controller.calculateTotalAmount(
                              price: price,
                              quantity: quantity,
                              discountPercentage: discountPercentage,
                              taxPercentage: double.tryParse(_controller
                                      .selectedTax.value.rate
                                      .toString()) ??
                                  0.0,
                            );

                            // Update Discount Amount Field
                            double discountAmount =
                                (discountPercentage / 100) * (price * quantity);
                            _controller.discountAmountContr.text =
                                discountAmount
                                    .toStringAsFixed(priceDecimalPlace);
                          }
                        },
                        controller: controller.discountContr,
                        decoration: const InputDecoration(
                          hintText: 'Discount',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 48.h,
                      width: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 15.w),
                    Text(
                      '%',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.discountAmountContr,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _controller.discountContr.text = "0.00";
                          } else {
                            double discountAmount =
                                double.tryParse(value) ?? 0.0;
                            double price =
                                double.tryParse(_controller.priceContr.text) ??
                                    0.0;
                            double quantity = double.tryParse(
                                    _controller.quantityContr.text) ??
                                1.0;

                            // Calculate discount percentage
                            double discountPercentage = (price * quantity == 0)
                                ? 0.0
                                : (discountAmount / (price * quantity)) * 100;

                            // Call function to update percentage & price
                            _controller.calculateTotalAmount(
                              price: price,
                              quantity: quantity,
                              discountPercentage: discountPercentage,
                              taxPercentage: double.tryParse(_controller
                                      .selectedTax.value.rate
                                      .toString()) ??
                                  0.0,
                            );

                            // Update Discount Percentage Field
                            _controller.discountContr.text =
                                discountPercentage.toStringAsFixed(2);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: '0.00',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 48.h,
                      width: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaxPercentageField({priceDecimalPlace}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        const Text("Tax Percentage"),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Obx(
                            () => Text(
                                "${_controller.selectedTax.value.taxType} ${_controller.selectedTax.value.rate}%"),
                          ),
                          items: const [],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    Container(
                      height: 48.h,
                      width: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 7.w),
                    Text('%',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8.w),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => TextField(
                          decoration: InputDecoration(
                            hintText: _controller.totalTaxes.value
                                .toStringAsFixed(priceDecimalPlace),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48.h,
                      width: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showUnitsDialog(context) {
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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return isLoading.value
                      ? SizedBox(
                          height: 60.h,
                          width: 60.w,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _controller.unitNames
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var unit = entry.value;

                            return ListTile(
                              title: Text(unit["name"].toString()),
                              onTap: () {
                                _controller
                                    .clearItemControllerWithoutItemName();
                                _controller.unitModel.value = UnitModel(
                                  id: unit["id"],
                                  name: unit["name"],
                                  shortName: unit["shortName"],
                                );

                                // ✅ Check if index 1 exists and compare names
                                if (_controller.unitNames.length > 1 &&
                                    unit["name"] ==
                                        _controller.secondaryUnitName.value) {
                                  _controller.priceContr.text =
                                      (_controller.priceForBaseUnit /
                                              _controller.conversionRate.value)
                                          .toStringAsFixed(3);
                                  print(
                                      "Price per unit ${_controller.priceContr.text}");
                                  _controller.isSecondaryChoosed.value = true;
                                  print("✅ Secondary unit is selected");
                                } else {
                                  _controller.isSecondaryChoosed.value = false;
                                  _controller.priceContr.text =
                                      (_controller.priceForBaseUnit).toString();
                                  print("✅ Primary unit is selected");
                                }
                                Get.back();
                              },
                            );
                          }).toList(),
                        );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
