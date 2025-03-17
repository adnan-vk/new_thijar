import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/add_godown_controller/add_godown_controller.dart';
import 'package:newthijar/model/add_stock_transfer.dart';
import 'package:newthijar/model/item_bar_list_model.dart';
import 'package:newthijar/view/home_page/widgets/custom_textfield.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_item.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class AddItemToStockTransfer extends StatefulWidget {
  const AddItemToStockTransfer({super.key});

  @override
  State<AddItemToStockTransfer> createState() => _AddItemToStockTransferState();
}

class _AddItemToStockTransferState extends State<AddItemToStockTransfer> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await addGodownController.fetchItemList();
      },
    );
    super.initState();
  }

  final GlobalKey<FormState> addItemKey = GlobalKey<FormState>();

  final AddStockItem addStockItem = AddStockItem();
  final TextEditingController quantityContr = TextEditingController();

  final addGodownController = Get.find<AddGodownController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "Add Stock Item",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20),
        height: 80,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: 1.0,
          child: InkWell(
            onTap: () {},
            child: InkWell(
              onTap: () async {
                addGodownController.stockItemList.add(addStockItem);
                Get.back();
              },
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Center(
                      child: Text(
                    "Add",
                    style: interFontGrey(context),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .025),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * .04,
                      ),
                      Obx(() {
                        return DropdownSearch<ItemBarList>(
                          items: (filter, loadProps) async {
                            await addGodownController.fetchItemList();

                            return addGodownController.filterdItemList;
                          },
                          itemAsString: (item) => item.itemName ?? "",
                          selectedItem: addGodownController.selectedItem.value,
                          onChanged: (value) {
                            addGodownController.selectedItem.value = value;
                            if (value != null) {
                              addStockItem.productId = value.id!;
                              addStockItem.name = value.itemName ?? "";
                            }
                          },
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: "e.g. Chocolate Cake",
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
                              suffixIcon: InkWell(
                                onTap: () {
                                  addGodownController.filterdItemList
                                      .assignAll([]);
                                  Get.to(() => const AddItemPage());
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
                                      child: Text(
                                        "Stock: ${item.stock?.totalQuantity ?? 0}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
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
                      SizedBox(
                        height: screenHeight * .025,
                      ),
                      CustomTextFormField(
                        controller: quantityContr,
                        keyboardType: TextInputType.number,
                        inputFormaters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.trim().isNotEmpty) {
                            addStockItem.quantity = int.tryParse(value) ?? 1;
                          }
                        },
                        hintText: "Enter Quantity",
                        labelText: "Quantity",
                      ),
                      SizedBox(
                        height: screenHeight * .025,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
