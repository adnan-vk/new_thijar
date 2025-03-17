import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/view/dashboard/dashboard.dart';
import 'package:newthijar/view/master_tab/master_tab.dart';
import 'package:newthijar/view/home_page/home.dart';
import 'package:newthijar/view/menu/menu_page.dart';
import 'package:newthijar/view/report/report_page.dart';

// import 'package:vyapar_clone/presentation/dash_board_screen/view/dash_board_screen.dart';
// import 'package:vyapar_clone/presentation/home_screen/view/home_screen.dart';
// import 'package:vyapar_clone/presentation/item_screen/master_tab_screen.dart';
// import 'package:vyapar_clone/presentation/login__screen/controller/controller.dart';
// import 'package:vyapar_clone/presentation/menu_screen/sub_screens/report/view/report_screen.dart';
// import 'package:vyapar_clone/presentation/menu_screen/view/menu_screen.dart';

// import '../../business_profile/controller.dart';
class BottomNavigationController extends GetxController {
  final PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;

  // final List<IconData> getIcons = [
  //   Icons.home_outlined,
  //   Icons.grid_3x3,
  //   Icons.apps_outlined,
  //   Icons.menu_outlined,
  //   Icons.abc,
  // ];
  // final List<String> iconsName = [
  //   "TASK BAR",
  //   "DASHBOARD",
  //   "MASTERS",
  //   "MENU",
  //   "Report",
  // ];

  final List<Widget> sampleWidgets = [
    // HomeScreen(),
    //  Center(child:  Text("home",style: TextStyle(color: Colors.red,fontSize: 20.sp),)),
    // const Center(
    //   child: Text("data1"),
    // ),
    // const HomePage(),
    HomePage(
      isSwitch: true,
      type: "Home",
    ),
    DashBoard(),
    // const Center(
    //   child: Text("data2"),
    // ),
    // const Center(
    //   child: Text("data3"),
    // ),
    MasterTab(),
    // const Center(
    //   child: Text("data4"),
    // ),
    MenuPage(),
    const ReportsPage(),
    // const Center(
    //   child: Text("data5"),
    // ),
    // HomeScreen(),
    // HomeScreen(),
    // HomeScreen(),
    // HomeScreen(),
    // HomeScreen(),
    // DashBoardScreen(),
    // // ItemPage(),
    // MasterTabScreen(),
    // MenuScreen(),
    // ReportScreen(),

    Center(
        child: Text(
      "Get Premium",
      style: TextStyle(color: Colors.red, fontSize: 20.sp),
    )),
  ];

  // @override
  // void onInit() {
  //   super.onInit();
  //   deleteSplashMemory();
  //   Get.put(BusinessController());
  // }

  // void deleteSplashMemory() {
  //   Get.delete<SignInController>(tag: 'SignInController memory deleted');
  // }
}
