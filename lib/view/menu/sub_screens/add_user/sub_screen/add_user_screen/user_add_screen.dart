import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/sync_and_share_controller/sync_and_share_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class UserAddScreen extends StatelessWidget {
  UserAddScreen({super.key});
  final controller = Get.put(SyncAndShareController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Add User",
            ),
          ),
          Positioned(
            top: 150,
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
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CustomTextFormField(
                    //   controller: controller.nameController,
                    //   hintText: "Enter Full Name *",
                    //   labelText: "Enter Full Name *",
                    // ),
                    textField(
                      hint: "Enter Full Name *",
                      controller: controller.nameController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // CustomTextFormField(
                    //   inputFormaters: [
                    //     FilteringTextInputFormatter.digitsOnly,
                    //   ],
                    //   keyboardType: TextInputType.phone,
                    //   controller: controller.phoneNumberController,
                    //   hintText: "Enter Phone Number or Email *",
                    //   labelText: "Enter Phone Number or Email  *",
                    // ),
                    textField(
                      hint: "Enter Phone Number*",
                      controller: controller.phoneNumberController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'User will receive an invite on this number or email.',
                      style:
                          TextStyle(fontSize: 13.sp, color: Colorconst.cGrey),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButtonFormField<String>(
                        // value: controller.userRoleController,
                        decoration: InputDecoration(
                          labelText: 'Choose User Role',
                          labelStyle: TextStyle(
                              fontSize: 14.sp, color: Colorconst.cGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixText: '*',
                          suffixStyle: const TextStyle(color: Colorconst.cRed),
                        ),
                        items: <String>[
                          'Secondary Admin',
                          'Salesman',
                          "Auditor",
                          // 'Biller',
                          // "Biller and Salesman",
                          "Accountant",
                          // "Stock Keeper"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colorconst.cBlack),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          controller.userRoleController = newValue.toString();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // CustomTextFormField(
                    //   controller: controller.prefixController,
                    //   hintText: "Add Prefix *",
                    //   labelText: "Add Prefix *",
                    // ),
                    textField(
                      hint: "Add Prefix *",
                      controller: controller.prefixController,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            controller.addSyncCompany();
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191) // Lighter blue
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add User',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textField({hint, controller}) {
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
              controller: controller,
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
}
