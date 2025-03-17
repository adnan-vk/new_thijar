import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/login_logout_controller/login_logout_controller.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:restart_app/restart_app.dart';

void logOutBottomSheet() {
  var controller = Get.put(LoginController());
  Get.bottomSheet(Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      height: 190.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          children: [
            Icon(EneftyIcons.logout_outline, size: 35.sp, color: Colors.red),
            SizedBox(height: 30.h),
            Text(
              "Are you sure want to logout ?",
              style: TextStyle(color: Colors.black87, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _logoutButton("Cancel", () => Get.back()),
                  isLoading.value
                      ? const Center(child: Text("Wait..."))
                      : _logoutButton("Logout", () async {
                          await controller.logout();
                        }),
                ],
              );
            }),
          ],
        ),
      ),
    ),
  ));
}

Widget _logoutButton(String label, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: const Color.fromARGB(255, 6, 50, 115),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    ),
  );
}
