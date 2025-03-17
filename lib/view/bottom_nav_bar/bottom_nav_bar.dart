// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:newthijar/controller/bottom_nav_controller/bottom_nav_controller.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  DateTime? _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async {
      //   // Check if we are on the home screen (index 0)
      //   if (_controller.selectedIndex.value == 0) {
      //     // Check if double press is detected
      //     if (_lastPressedAt == null ||
      //         DateTime.now().difference(_lastPressedAt!) >
      //             const Duration(seconds: 2)) {
      //       // If it's the first press, update the lastPressedAt time
      //       _lastPressedAt = DateTime.now();
      //       // Show a snackbar or a dialog for the user to know they need to press again to exit
      //       Get.showSnackbar(const GetSnackBar(
      //         message: "Press Back Again to Exit The App",
      //         backgroundColor: Color.fromARGB(255, 6, 50, 115),
      //         duration: Duration(seconds: 2),
      //         borderRadius: 10,
      //       ));
      //       return false;
      //     }
      //     return true; // Exit app on second press
      //   } else {
      //     // Navigate back to home page (index 0)
      //     _controller.selectedIndex.value = 0;
      //     return false; // Don't exit, just return to the home screen
      //   }
      // },
      onWillPop: () async {
        if (_controller.selectedIndex.value == 0) {
          DateTime now = DateTime.now();

          if (_lastPressedAt == null ||
              now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
            _lastPressedAt = now;

            // Show snackbar using ScaffoldMessenger
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Press Back Again to Exit The App"),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color.fromARGB(255, 6, 50, 115),
              ),
            );

            return false;
          }
          return true; // Exit app on second press
        } else {
          _controller.selectedIndex.value = 0;
          return false; // Return to home instead of exiting
        }
      },
      child: Scaffold(
        body: Obx(
            () => _controller.sampleWidgets[_controller.selectedIndex.value]),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) => _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final List<IconData> icons = [
      EneftyIcons.home_outline,
      EneftyIcons.grid_3_outline,
      EneftyIcons.more_square_outline,
      EneftyIcons.menu_outline,
      EneftyIcons.document_outline,
    ];

    final List<String> labels = [
      "HOME",
      "DASHBOARD",
      "MASTER",
      "MENUS",
      "REPORT"
    ];

    return GestureDetector(
      onTap: () => _controller.selectedIndex.value = index,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icons[index],
              color: _controller.selectedIndex.value == index
                  ? const Color.fromARGB(255, 6, 50, 115)
                  : Colors.grey,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              labels[index],
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: _controller.selectedIndex.value == index
                    ? const Color.fromARGB(255, 6, 50, 115)
                    : Colors.grey,
                fontWeight: _controller.selectedIndex.value == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
