import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';
import 'package:newthijar/widgets/vertical_divider/vertical_divider.dart';

class DateInvoiceWidget extends StatelessWidget {
  const DateInvoiceWidget(
      {super.key,
      this.ontapInvoice,
      this.invoiceNumber,
      this.date,
      this.titleOne,
      this.hideInvoice,
      this.titleTwo,
      this.onTapDate});
  final String? invoiceNumber;
  final String? date;
  final String? titleOne;
  final bool? hideInvoice;
  final String? titleTwo;
  final Function()? onTapDate;
  final Function()? ontapInvoice;

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final _controller = Get.put(TransactionDetailController());
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const VerticleDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .015),
            child: Row(
              children: [
                if ((hideInvoice ?? false) == false)
                  Flexible(
                      child: GestureDetector(
                    onTap: ontapInvoice,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleOne ?? "Invoce No.",
                          style:
                              interFontBlack(context, color: Colorconst.cGrey),
                        ),
                        SizedBox(
                          height: screenHeight * .0009,
                        ),
                        Row(
                          children: [
                            Text(
                              invoiceNumber ?? "",
                              style: interFontBlack(context,
                                  color: Colorconst.cBlack),
                            ),
                            SizedBox(
                              width: screenWidth * .009,
                            ),
                            Transform.rotate(
                                angle: -1.55,
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  size: 12.sp,
                                  color: Colors.black45,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )),
                Container(
                  height: screenHeight * .04,
                  width: 1,
                  color: Colors.black12,
                ),
                SizedBox(
                  width: screenWidth * .03,
                ),
                // Row(
                //   children: [
                //     const Text("Attach file"),
                //     IconButton(
                //         onPressed: () {}, icon: const Icon(Icons.attach_file))
                //   ],
                // ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        _controller.documentName.value != ''
                            ? _controller.documentName.value
                            : 'Attach File',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Choose an option"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text("Attach from Gallery"),
                                  onTap: () {
                                    _controller.chooseImage();
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.folder),
                                  title: const Text("Attach from Files"),
                                  onTap: () {
                                    _controller.chooseDocument();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.attach_file),
                    ),
                  ],
                ),

                SizedBox(
                  width: screenWidth * .03,
                ),
                Container(
                  height: screenHeight * .04,
                  width: 1,
                  color: Colors.black12,
                ),
                SizedBox(
                  width: screenWidth * .03,
                ),
                Flexible(
                    child: InkWell(
                  onTap: onTapDate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleTwo ?? "Date",
                        style: interFontBlack(context, color: Colorconst.cGrey),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          Text(
                            date ?? "",
                            style: interFontBlack(context,
                                color: Colorconst.cBlack),
                          ),
                          SizedBox(
                            width: screenWidth * .009,
                          ),
                          Transform.rotate(
                              angle: -1.55,
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 12.sp,
                                color: Colors.black45,
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * .01,
          ),
        ],
      ),
    );
  }
}
