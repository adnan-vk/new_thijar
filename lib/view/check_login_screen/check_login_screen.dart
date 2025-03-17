// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controller/controller.dart';

// class SplashScreen extends StatelessWidget {
//   SplashScreen({super.key});
//   final _controller = Get.put(SplashMainController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF470404), // Dark Red
//               Color(0xFF4D0404), // Slightly lighter Dark Red
//               Color(0xFF060B25), // Deep Blue-Black
//               Color(0xFF070C29), // Slightly lighter Blue-Black
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Image.asset(
//               //   'assets/images/thijar poster.jpeg',
//               //   fit: BoxFit.contain,
//               // ),
//               const SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           offset: Offset(2, 2),
//                           blurRadius: 6,
//                           color: Colors.white)
//                     ],
//                     border: Border.all(width: 3, color: Colors.white),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: const Text(
//                     'Welcome to Thijar App',
//                     style: TextStyle(
//                       shadows: [
//                         Shadow(
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                             color: Colors.amber)
//                       ],
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/splash_mai_controller/splash_main_controller.dart';

class CheckLoginScreen extends StatelessWidget {
  CheckLoginScreen({super.key});
  final _controller = Get.put(SplashMainController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colorconst.cSecondaryBlue,
      ),
    );
  }
}
