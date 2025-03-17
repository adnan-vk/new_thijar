import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/constants/money_symbol.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/model/item_model.dart';
import 'package:newthijar/view/add_new_party/add_new_party.dart';
import 'package:newthijar/view/home_page/sub_screen/add_sale_item/add_sale_item.dart';
import 'package:newthijar/view/home_page/widgets/item_card_widget.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

// Widget buildTextField(String hint, IconData? icon, {bool enabled = true}) {
//   return TextField(
//     enabled: enabled,
//     decoration: InputDecoration(
//       hintText: hint,
//       suffixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
//       filled: true,
//       fillColor: enabled ? Colors.white : Colors.grey.shade200,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//     ),
//   );
// }

Widget buildDropdown(List<String> items, String selectedItem) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: (value) {},
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget buildAmountSection({controller}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      children: [
        buildAmountRow("Total Amount:", "₹ 0.0",
            bold: true, controller: controller.totalAmountContr),
        // buildAmountRow("Received:", "₹ 0.0", checkbox: true),
        buildReceived(
          "Received:",
          "₹ 0.0",
          checkbox: true,
          controller: controller.recivedAmountController,
        ),
        buildAmountRow(
          "Balance Due:",
          controller.isChecked.value
              ? "$moneySymbol ${controller.balanceDue}"
              : "$moneySymbol ${controller.totalAmountContr.text}",
        ),
      ],
    ),
  );
}

Widget buildAmountRow(String label, String value,
    {bool bold = false, bool checkbox = false, controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Text(
          label,
          style:
              TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
        const Spacer(),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            controller: controller,
          ),
        ),
      ],
    ),
  );
}

Widget buildReceived(String label, String value,
    {bool bold = false, bool checkbox = false, controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        if (checkbox) Checkbox(value: false, onChanged: (value) {}),
        Text(
          label,
          style:
              TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
        const Spacer(),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none)),
            controller: controller,
          ),
        ),
      ],
    ),
  );
}

Widget buildFormContainer(context, {controller}) {
  return Obx(() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Obx(() {
          //   return DropdownSearch<CustomerPartyModelList>(
          //     items: (filter, loadProps) async {
          //       if (controller.customerPartyNmList.isEmpty) {
          //         await controller.fetchCustomerParty();
          //       }
          //       return controller.customerPartyNmList;
          //     },
          //     itemAsString: (item) => item.name ?? "",
          //     selectedItem: controller.selectedCustomer.value,
          //     onChanged: (value) {
          //       controller.selectedCustomer.value = value;
          //       if (value != null) {
          //         controller.customerTxtCont.text = value.name ?? "";
          //         controller.phoneNumberController.text = value.phoneNo ?? "";
          //       }
          //     },
          //     decoratorProps: DropDownDecoratorProps(
          //       decoration: InputDecoration(
          //         hintText: controller.youRedting.value
          //             ? controller.customerTxtCont.text
          //             : controller.selectedIndex.value == 0
          //                 ? "Customer *"
          //                 : "Billing Name *",
          //         labelText: "Customer Name",
          //         constraints: BoxConstraints(maxHeight: 50.h),
          //         border: OutlineInputBorder(
          //             borderSide:
          //                 BorderSide(width: 1.w, color: Colorconst.cGrey),
          //             borderRadius: BorderRadius.circular(5.r)),
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(width: 1.w, color: Colors.blue),
          //             borderRadius: BorderRadius.circular(5.r)),
          //         suffixIcon: InkWell(
          //           onTap: () {
          //             controller.customerTxtCont.text = '';
          //             Get.to(() => AddNewPartyPage());
          //           },
          //           child: Icon(
          //             Icons.add,
          //             size: 25.sp,
          //             color: Colors.blue,
          //           ),
          //         ),
          //       ),
          //     ),
          //     suffixProps: const DropdownSuffixProps(
          //         dropdownButtonProps: DropdownButtonProps(isVisible: false)),
          //     compareFn: (item1, item2) {
          //       return item1.name?.trim().toLowerCase() ==
          //           item2.name?.trim().toLowerCase();
          //     },
          //     dropdownBuilder: (context, selectedItem) {
          //       return Text(selectedItem?.name ?? "",
          //           style: const TextStyle(color: Colors.black));
          //     },
          //     popupProps: PopupProps.menu(
          //       cacheItems: true,
          //       showSearchBox: true,
          //       containerBuilder: (context, popupWidget) => Container(
          //         color: Colors.white,
          //         child: popupWidget,
          //       ),
          //       searchFieldProps: TextFieldProps(
          //         style: const TextStyle(color: Colors.black),
          //         decoration: InputDecoration(
          //           labelText: "Search",
          //           constraints: BoxConstraints(maxHeight: 50.h),
          //           border: OutlineInputBorder(
          //               borderSide:
          //                   BorderSide(width: 1.w, color: Colorconst.cGrey),
          //               borderRadius: BorderRadius.circular(5.r)),
          //           focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(width: 1.w, color: Colors.blue),
          //               borderRadius: BorderRadius.circular(5.r)),
          //         ),
          //       ),
          //       itemBuilder: (context, obj, isDisabled, isSelected) {
          //         return Container(
          //           color: Colors.white,
          //           child: Padding(
          //             padding: const EdgeInsets.all(10.0),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: ListTile(
          //                     title: Text(
          //                       obj.name.toString(),
          //                       style: TextStyle(
          //                           color: Colors.black, fontSize: 15.sp),
          //                     ),
          //                     trailing: Padding(
          //                       padding: EdgeInsets.symmetric(vertical: 6.h),
          //                       child: Column(
          //                         children: [
          //                           double.parse(obj.balance.toString()) > 0
          //                               ? Icon(Icons.arrow_outward_outlined,
          //                                   color: Colors.green, size: 22.sp)
          //                               : Icon(Icons.arrow_downward_outlined,
          //                                   color: Colors.red, size: 22.sp),
          //                           Text(obj.balance.toString())
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
          //                 SizedBox(width: 10.w)
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //       searchDelay: const Duration(milliseconds: 500),
          //     ),
          //   );
          // }),
          Obx(() {
            return DropdownSearch<CustomerPartyModelList>(
              items: (filter, loadProps) async {
                if (controller.customerPartyNmList.isEmpty) {
                  await controller.fetchCustomerParty();
                }
                return controller.customerPartyNmList;
              },
              itemAsString: (item) => item.name ?? "",
              selectedItem: controller.selectedCustomer.value,
              onChanged: (value) {
                controller.selectedCustomer.value = value;
                if (value != null) {
                  controller.customerTxtCont.text = value.name ?? "";
                  controller.phoneNumberController.text = value.phoneNo ?? "";
                }
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: controller.youRedting.value
                      ? controller.customerTxtCont.text
                      : controller.selectedIndex.value == 0
                          ? "Customer *"
                          : "Billing Name *",
                  constraints: BoxConstraints(maxHeight: 50.h),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.w, color: Colorconst.cGrey),
                      borderRadius: BorderRadius.circular(5.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.w, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.r)),
                  suffixIcon: InkWell(
                    onTap: () {
                      controller.customerTxtCont.text = '';
                      Get.to(() => AddNewPartyPage());
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
                  dropdownButtonProps: DropdownButtonProps(isVisible: false)),
              compareFn: (item1, item2) {
                return item1.name?.trim().toLowerCase() ==
                    item2.name?.trim().toLowerCase();
              },
              dropdownBuilder: (context, selectedItem) {
                return Text(selectedItem?.name ?? "",
                    style: const TextStyle(color: Colors.black));
              },
              popupProps: PopupProps.menu(
                cacheItems: true,
                showSearchBox: true,
                containerBuilder: (context, popupWidget) => Container(
                  color: Colors.white,
                  child: popupWidget,
                ),
                searchFieldProps: TextFieldProps(
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Search",
                    constraints: BoxConstraints(maxHeight: 50.h),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.w, color: Colorconst.cGrey),
                        borderRadius: BorderRadius.circular(5.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.w, color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.r)),
                  ),
                ),
                itemBuilder: (context, obj, isDisabled, isSelected) {
                  return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                obj.name.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Column(
                                  children: [
                                    double.parse(obj.balance.toString()) > 0
                                        ? Icon(Icons.arrow_outward_outlined,
                                            color: Colors.green, size: 22.sp)
                                        : Icon(Icons.arrow_downward_outlined,
                                            color: Colors.red, size: 22.sp),
                                    Text(obj.balance.toString())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
                          SizedBox(width: 10.w)
                        ],
                      ),
                    ),
                  );
                },
                searchDelay: const Duration(milliseconds: 500),
              ),
            );
          }),
          SizedBox(height: 25.h),
          // Obx(() {
          //   return DropdownSearch<CustomerPartyModelList>(
          //     items: (filter, loadProps) async {
          //       if (controller.customerPartyNmList.isEmpty) {
          //         await controller.fetchCustomerParty();
          //       }
          //       return controller.customerPartyNmList;
          //     },
          //     itemAsString: (item) => item.phoneNo ?? "",
          //     selectedItem: controller.selectedCustomer.value,
          //     onChanged: (value) {
          //       controller.selectedCustomer.value = value;
          //       if (value != null) {
          //         controller.phoneNumberController.text = value.phoneNo ?? "";
          //         controller.customerTxtCont.text = value.name ?? "";
          //       }
          //     },
          //     decoratorProps: DropDownDecoratorProps(
          //       decoration: InputDecoration(
          //         hintText: controller.youRedting.value
          //             ? controller.phoneNumberController.text
          //             : "Phone Number",
          //         labelText: "Phone Number",
          //         constraints: BoxConstraints(maxHeight: 50.h),
          //         border: OutlineInputBorder(
          //             borderSide:
          //                 BorderSide(width: 1.w, color: Colorconst.cGrey),
          //             borderRadius: BorderRadius.circular(5.r)),
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(width: 1.w, color: Colors.blue),
          //             borderRadius: BorderRadius.circular(5.r)),
          //       ),
          //     ),
          //     suffixProps: const DropdownSuffixProps(
          //         dropdownButtonProps: DropdownButtonProps(isVisible: false)),
          //     compareFn: (item1, item2) {
          //       return item1.phoneNo?.trim().toLowerCase() ==
          //           item2.phoneNo?.trim().toLowerCase();
          //     },
          //     dropdownBuilder: (context, selectedItem) {
          //       return Text(selectedItem?.phoneNo ?? "",
          //           style: const TextStyle(color: Colors.black));
          //     },
          //     popupProps: PopupProps.menu(
          //       cacheItems: true,
          //       showSearchBox: true,
          //       containerBuilder: (context, popupWidget) => Container(
          //         color: Colors.white,
          //         child: popupWidget,
          //       ),
          //       searchFieldProps: TextFieldProps(
          //         style: const TextStyle(color: Colors.black),
          //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //         keyboardType: TextInputType.number,
          //         decoration: InputDecoration(
          //           labelText: "Search",
          //           constraints: BoxConstraints(maxHeight: 50.h),
          //           border: OutlineInputBorder(
          //               borderSide:
          //                   BorderSide(width: 1.w, color: Colorconst.cGrey),
          //               borderRadius: BorderRadius.circular(5.r)),
          //           focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(width: 1.w, color: Colors.blue),
          //               borderRadius: BorderRadius.circular(5.r)),
          //         ),
          //       ),
          //       itemBuilder: (context, obj, isDisabled, isSelected) {
          //         return Container(
          //           color: Colors.white,
          //           child: Padding(
          //             padding: const EdgeInsets.all(10.0),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: ListTile(
          //                     title: Text(
          //                       obj.phoneNo.toString(),
          //                       style: TextStyle(
          //                           color: Colors.black, fontSize: 15.sp),
          //                     ),
          //                     trailing: Padding(
          //                       padding: EdgeInsets.symmetric(vertical: 6.h),
          //                       child: Column(
          //                         children: [
          //                           double.parse(obj.balance.toString()) > 0
          //                               ? Icon(Icons.arrow_outward_outlined,
          //                                   color: Colors.green, size: 22.sp)
          //                               : Icon(Icons.arrow_downward_outlined,
          //                                   color: Colors.red, size: 22.sp),
          //                           Text(obj.balance.toString())
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
          //                 SizedBox(width: 10.w)
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //       searchDelay: const Duration(milliseconds: 500),
          //     ),
          //   );
          // }),
          Obx(() {
            return DropdownSearch<CustomerPartyModelList>(
              items: (filter, loadProps) async {
                if (controller.customerPartyNmList.isEmpty) {
                  await controller.fetchCustomerParty();
                }
                return controller.customerPartyNmList;
              },
              itemAsString: (item) => item.phoneNo ?? "",
              selectedItem: controller.selectedCustomer.value,
              onChanged: (value) {
                controller.selectedCustomer.value = value;
                if (value != null) {
                  controller.phoneNumberController.text = value.phoneNo ?? "";
                  controller.customerTxtCont.text = value.name ?? "";
                }
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: controller.youRedting.value
                      ? controller.phoneNumberController.text
                      : "Phone Number",
                  constraints: BoxConstraints(maxHeight: 50.h),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.w, color: Colorconst.cGrey),
                      borderRadius: BorderRadius.circular(5.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.w, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.r)),
                ),
              ),
              suffixProps: const DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(isVisible: false)),
              compareFn: (item1, item2) {
                return item1.phoneNo?.trim().toLowerCase() ==
                    item2.phoneNo?.trim().toLowerCase();
              },
              dropdownBuilder: (context, selectedItem) {
                return Text(selectedItem?.phoneNo ?? "",
                    style: const TextStyle(color: Colors.black));
              },
              popupProps: PopupProps.menu(
                cacheItems: true,
                showSearchBox: true,
                containerBuilder: (context, popupWidget) => Container(
                  color: Colors.white,
                  child: popupWidget,
                ),
                searchFieldProps: TextFieldProps(
                  style: const TextStyle(color: Colors.black),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Search",
                    constraints: BoxConstraints(maxHeight: 50.h),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.w, color: Colorconst.cGrey),
                        borderRadius: BorderRadius.circular(5.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.w, color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.r)),
                  ),
                ),
                itemBuilder: (context, obj, isDisabled, isSelected) {
                  return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                obj.phoneNo.toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.sp),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Column(
                                  children: [
                                    double.parse(obj.balance.toString()) > 0
                                        ? Icon(Icons.arrow_outward_outlined,
                                            color: Colors.green, size: 22.sp)
                                        : Icon(Icons.arrow_downward_outlined,
                                            color: Colors.red, size: 22.sp),
                                    Text(obj.balance.toString())
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
                          SizedBox(width: 10.w)
                        ],
                      ),
                    ),
                  );
                },
                searchDelay: const Duration(milliseconds: 500),
              ),
            );
          }),
          SizedBox(height: 20.h),
          controller.itemList.isNotEmpty
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 6, 50, 115),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 12.w,
                        ),
                        CircleAvatar(
                          radius: 8.r,
                          backgroundColor: Colors.white,
                          child: Transform.rotate(
                              angle: 4.7,
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 10.sp,
                                color: Colors.black45,
                              )),
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text(
                          "Billed Items",
                          style: interFontGrey1(
                              fontsize: 12.sp, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: 6.h,
          ),
          Column(
              children: List.generate(
            controller.itemList.length,
            (index) {
              ItemModel obj = controller.itemList[index];
              return InkWell(
                onTap: () {
                  controller.isEditingItem.value = true;
                  controller.updateItemValues(object: obj, index: index);
                },
                child: ItemsCardWidget(
                  discount: obj.discount,
                  itemName: obj.itemName,
                  itemNum: (index + 1).toString(),
                  price: obj.price.toString(),
                  quantity: obj.quantity,
                  tax: obj.taxAmt,
                  total: obj.total,
                  discountP: obj.discountP,
                  subtotal: obj.subtotalP,
                  taxRate: obj.taxRate,
                  onDelete: () => controller.deleteItem(index),
                ),
              );
            },
          )),
          controller.itemList.length.toInt() == 0
              ? const SizedBox()
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tatal Disc: ${controller.grandDiscount}",
                            style: interFontBlack1(
                              fontsize: 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            "Total Tax Amt: ${controller.grandTax.toString()}",
                            style: interFontBlack1(
                                fontsize: 11.sp, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tatal Qty: ${controller.grandQty}",
                            style: interFontBlack1(
                              fontsize: 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            "Subtotal: ${controller.grandSubTotal}",
                            style: interFontBlack1(
                              fontsize: 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                controller.conversionRate.value = 1.0;
                controller.priceForBaseUnit.value = 0.0;
                controller.isSecondaryChoosed.value = false;
                controller.unitNames.clear();
                controller.secondaryUnitName.value = '';
                controller.primaryUnitName.value = '';
                controller.discountContr.text = "0.00";
                controller.discountAmountContr.text = "0";
                controller.isEditingItem.value = false;
                controller.clearItemController();
                Get.to(() => const AddSaleItem());
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Items"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 6, 50, 115),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
