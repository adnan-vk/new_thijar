import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/item_settings_controller/item_settings_controller.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

final ItemSettingController itemSettingsController = ItemSettingController();

class ItemsCardWidget extends StatelessWidget {
  ItemsCardWidget({
    this.subtotal,
    this.discountP,
    this.itemName,
    this.itemNum,
    this.price,
    this.quantity,
    this.total,
    this.tax,
    this.taxRate,
    this.discount,
    this.onDelete,
  });

  final String? itemName;
  final String? itemNum;
  final String? price;
  final String? quantity;
  final String? total;
  final String? tax;
  final String? taxRate;
  final String? discount;
  final String? subtotal;
  final String? discountP;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    itemSettingsController.fetchSettingData();
    final priceDecimalPlace =
        itemSettingsController.priceNotifier.value.toInt();
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colorconst.cSecondaryGrey,
              borderRadius: BorderRadius.circular(5.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: [
                //  Padding(
                //   padding: const EdgeInsets.only(right: 8.0,bottom: 10),
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //       child: IconButton(
                //         icon: const Icon(Icons.delete, color: Colors.red),
                //         onPressed: onDelete,
                //       ),),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.5.h),
                                child: Text(
                                  "#$itemNum",
                                  style: interFontBlack1(
                                      fontsize: 9.sp, color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              itemName ?? "Item Name",
                              style: interFontBlack1(
                                  fontsize: 13.sp, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(total ?? "690.00",
                          style: interFontBlack1(
                              fontsize: 13.sp, color: Colors.black))
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
                        "Item Subtotal",
                        style: interFontBlack1(
                          fontsize: 11.sp,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        "$quantity x $price = ${(double.parse(quantity ?? "0") * double.parse(price ?? "0")).toStringAsFixed(priceDecimalPlace)}",
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
                        "Discount (%): ${discountP ?? "0"}",
                        style: interFontBlack1(
                          fontsize: 11.sp,
                          color: Colorconst.cYellowLight,
                        ),
                      ),
                      Text(
                        discount ?? "0",
                        style: interFontBlack1(
                          fontsize: 11.sp,
                          color: Colorconst.cYellowLight,
                        ),
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
                        "Tax $taxRate%",
                        style: interFontBlack1(
                          fontsize: 11.sp,
                          color: Colors.black45,
                        ),
                      ),

// Text(
//                         tax != null || tax == "" || tax == "null"
//                             ? double.parse(tax.toString()).toStringAsFixed(2)
//                             : "0.00",
//                         style: interFontBlack1(
//                             fontsize: 11.sp, color: Colors.black45),
//                       ),

                      Text(
                        (tax != null &&
                                tax != "" &&
                                tax != "null" &&
                                double.tryParse(tax.toString()) != null)
                            ? double.parse(tax.toString()).toStringAsFixed(2)
                            : "0.00",
                        style: interFontBlack1(
                            fontsize: 11.sp, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
