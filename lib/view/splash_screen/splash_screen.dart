import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/view/login_page/login_page.dart';
import 'package:newthijar/view/register_page/register_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Image.asset(
                  'assets/images/splash image.jpg', // Place your image in the assets/images directory
                  height: 300.h,
                ),
              ),
              SizedBox(height: 60.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 3, color: const Color.fromARGB(255, 6, 50, 115)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Text(
                  'THIJAR',
                  style: TextStyle(
                    fontSize: 32.sp,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 50, 115),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.h),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => RegisterPage());
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                  side:
                      const BorderSide(color: Color.fromARGB(255, 6, 50, 115)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Continue as a guest',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.cyan,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
