import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/model/item_model.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';
import 'package:newthijar/widgets/validator_class/validator_class.dart';

Widget buildBottomButtons(BuildContext context,
    {controller, priceDecimalPlace, itemIndex}) {
  final itemController = Get.put(ItemScreenController());
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
            onPressed: () async {
              if (controller.quantityContr.text == '') {
                SnackBars.showAlertSnackBar(text: "Please Add quantity");
              } else {
                bool isMatch = itemController.itemList.any(
                    (item) => item.itemName == controller.itemNameContr.text);
                if (isMatch) {
                  if (ValidatorClass().validatedItemForm(
                    iName: controller.itemNameContr.text,
                    price: controller.totalPrice.value.toString(),
                    unit: controller.unitModel.value.name,
                    taxPrecent: controller.selectedTax.value.id,
                  )) {
                    await SharedPreLocalStorage.addStringToItemList(
                        controller.itemNameContr.text);

                    //  log("Item list ===${await SharedPreLocalStorage.getItemList()}");

                    if (controller.isEditingItem.value) {
                      int index = controller.itemIndex.value;

                      // ItemModel obj = ItemModel(
                      controller.itemList[index].discount =
                          controller.totalDiscount.value.toString();
                      controller.itemList[index].itemName =
                          controller.itemNameContr.text;
                      controller.itemList[index].price =
                          controller.priceContr.text;
                      controller.itemList[index].mrp =
                          num.tryParse(controller.mrpContr.text) ?? 0.0;
                      controller.itemList[index].quantity =
                          controller.quantityContr.text;
                      controller.itemList[index].taxAmt =
                          controller.totalTaxes.value.toString();
                      controller.itemList[index].total =
                          controller.totalPrice.value.toString();
                      controller.itemList[index].discountP =
                          controller.discountContr.text;
                      controller.itemList[index].subtotalP = controller
                          .subTotalP.value
                          .toStringAsFixed(priceDecimalPlace);
                      controller.itemList[index].unit =
                          controller.unitModel.value.name;
                      controller.itemList[index].taxPercent =
                          controller.selectedTax.value.id;
                      Get.back();
                      // );
                      // _controller.addItem(item: obj);
                      // _controller.clearItemController();
                      SnackBars.showSuccessSnackBar(text: "Added item updated");
                    } else {
                      ItemModel obj = ItemModel(
                        discount: controller.totalDiscount.value.toString(),
                        itemName: controller.itemNameContr.text,
                        price: controller.priceContr.text,
                        quantity: controller.quantityContr.text,
                        taxAmt: controller.totalTaxes.value.toString(),
                        total: controller.totalPrice.value.toString(),
                        discountP: controller.discountContr.text,
                        subtotalP: controller.subTotalP.value
                            .toStringAsFixed(priceDecimalPlace),
                        unit: controller.unitModel.value.name,
                        taxPercent: controller.selectedTax.value.id,
                        taxRate: controller.selectedTax.value.rate,
                      );
                      controller.addItem(item: obj);
                      if (controller.isEditingItem.value) {
                        controller.deleteItem(itemIndex!);
                      }
                      Get.back();
                    }
                  }
                } else {
                  SnackBars.showErrorSnackBar(text: "Please Select a Item");
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

void showLowStockAlertDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colorconst.cwhite,
        // title: Text("Alert Title"),
        content: const Text(
          "Stock Is running Low,kindly Restock",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(); // Close the dialog
          //   },
          //   child: const Text("Cancel",style: TextStyle(color: Colorconst.cBlack),),
          // ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorconst.cRed,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "ok",
              style: TextStyle(
                color: Colorconst.cwhite,
              ),
            ),
          ),
        ],
      );
    },
  );
}
