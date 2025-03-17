import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/widgets/text_style/text_style.dart'; // Import ScreenUtil

class AddItemButton extends StatelessWidget {
  AddItemButton({
    super.key,
    this.onTap,
  });
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r), // Responsive corner radius
          border: Border.all(
              width: 2.w, color: Colorconst.cGrey), // Responsive border width
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h), // Responsive padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                color: Colorconst.cBlue,
                size: 24.sp, // Responsive icon size
              ),
              SizedBox(
                width: 10.w, // Responsive space between elements
              ),
              Text(
                "Add Items",
                style: interFontBlack(
                  context,
                  color: Colorconst.cBlue,
                  fontWeight: FontWeight.bold,
                  fontsize: 16.sp, // Responsive font size
                ),
              ),
              // SizedBox(
              //   width: 5.w, // Responsive space between elements
              // ),
              // Text(
              //   "(Optional)",
              //   style: interFontBlack(
              //     context,
              //     color: Colorconst.cGrey,
              //     fontsize: 14.sp, // Responsive font size
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
