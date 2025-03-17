import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/view/menu/sub_screens/business_card/widget/card_widget.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class BusinessCardScreen extends StatelessWidget {
  BusinessCardScreen({super.key});
  // final _controller = Get.put(BusinessCardController());
  final controller = Get.put(BusinessController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorconst.cSecondaryGrey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Business Card",
            ),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BusinessCard(
                    businessName:
                        controller.businessNameController.text.isNotEmpty
                            ? controller.businessNameController.text
                            : 'Business Name',
                    address:
                        controller.businessAddressController.text.isNotEmpty
                            ? controller.businessAddressController.text
                            : 'Address',
                    email: controller.emailIdController.text.isNotEmpty
                        ? controller.emailIdController.text
                        : 'Email',
                    phone: controller.phoneController.text.isNotEmpty
                        ? controller.phoneController.text
                        : 'Phone Number',
                    // image:
                    //     "http://3.110.41.88:8081/uploads/images/${_controller.businessProfile.value.businessProfile?.logo ?? ""}",
                  ),
                ],
              ),
            ),
          ),
          // _bottomButtonWidget()
        ],
      ),
    );
  }

  Widget _bottomButtonWidget() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0.r)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 43.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _bottomWidgets(
                          onTap: () => Get.back(),
                        ),
                        _bottomWidgets(
                            icon: FontAwesomeIcons.whatsapp,
                            iconColor: Colors.green,
                            text: "Whatsapp"),
                        _bottomWidgets(
                            icon: FontAwesomeIcons.share,
                            iconColor: Colors.black,
                            text: "Share"),
                        _bottomWidgets(
                            icon: Icons.edit,
                            iconColor: Colors.blue,
                            text: "Edit"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomWidgets(
      {Function()? onTap, String? text, IconData? icon, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          children: [
            Icon(
              icon ?? Icons.home_outlined,
              size: 26.sp,
              color: iconColor ?? Colors.blue,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              text ?? "Home",
              style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
