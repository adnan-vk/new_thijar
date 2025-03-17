import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class BottomButton extends StatelessWidget {
  BottomButton({super.key, this.onClickCancel, this.onClickSave});

  // final Function()? onClickSaveNew;
  final Function()? onClickCancel;
  final Function()? onClickSave;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: Platform.isIOS
          ? (screenHeight * .035 + MediaQuery.viewPaddingOf(context).bottom)
          : (screenHeight * .058 + MediaQuery.viewPaddingOf(context).bottom),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: onClickCancel,
                // onTap: onClickSaveNew,
                child: Container(
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    "Cancel",
                    // "Save & New",
                    style: interFontGrey(context,
                        color: Colorconst.cBlack,
                        fontsize: 15,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: onClickSave,
                child: Container(
                  color: Colors.blue,
                  child: Center(
                      child: Text(
                    "Save",
                    style: interFontGrey(context,
                        color: Colorconst.cwhite,
                        fontsize: 15,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )),
            ],
          )),
          SizedBox(
            width: screenWidth * .06,
          ),
          // Transform(
          //   transform: Matrix4.diagonal3Values(-1, 1, 1),
          //   alignment: Alignment.center,
          //   child: const Icon(
          //     Icons.reply,
          //     size: 23,
          //     color: Colors.blue,
          //   ),
          // )
        ],
      ),
    );
  }
}
