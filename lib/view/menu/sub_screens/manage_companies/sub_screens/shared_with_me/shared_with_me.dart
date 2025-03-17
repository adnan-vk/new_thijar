// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newthijar/controller/shared_with_me_controller/shared_with_me_controller.dart';
// import 'package:newthijar/widgets/loading/loading.dart';
// import 'package:restart_app/restart_app.dart';

// class SharedWithMeScreen extends StatelessWidget {
//   SharedWithMeScreen({super.key});
//   final controller = Get.put(SharedWithMeController());

//   @override
//   Widget build(BuildContext context) {
//     controller.getSharedWithMe();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Obx(
//         () {
//           return isLoading.value == true
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : controller.allShareCompany.isEmpty
//                   ? const Center(
//                       child: Text("No Shared companies found"),
//                     )
//                   : ListView.builder(
//                       itemCount: controller.allShareCompany.length,
//                       itemBuilder: (context, index) {
//                         final item = controller.allShareCompany[index];

//                         return _buildCompanyCard(
//                           item.companyId?.companyName.toString() ?? "No Name",
//                           item.companyId?.phoneNo.toString() ??
//                               "No Phone Number",
//                           showJoinButton: true,
//                           onJoinPressed: () async {
//                             log("Joining company: ${item.companyId}");
//                             controller.approveRequest(item.id.toString());
//                             await controller.switchCompany(
//                               item.companyId!.id.toString(),
//                             );
//                             Restart.restartApp();
//                           },
//                           onRemovePressed: () {
//                             log("Removing company: ${item.companyId}");
//                           },
//                         );
//                       },
//                     );
//         },
//       ),
//     );
//   }

//   Widget _buildCompanyCard(
//     String name,
//     String phoneNumber, {
//     required bool showJoinButton,
//     required VoidCallback onJoinPressed,
//     required VoidCallback onRemovePressed,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ListTile(
//         title: Text(
//           name,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16.0,
//           ),
//         ),
//         subtitle: Text(
//           phoneNumber,
//           style: const TextStyle(fontSize: 14.0, color: Colors.grey),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.more_vert),
//               onPressed: () {},
//             ),
//             TextButton(
//               onPressed: onJoinPressed,
//               child: const Text(
//                 "Join",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/shared_with_me_controller/shared_with_me_controller.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:restart_app/restart_app.dart';

class SharedWithMeScreen extends StatelessWidget {
  SharedWithMeScreen({super.key});

  final controller = Get.put(SharedWithMeController());
  bool value = false;
  @override
  Widget build(BuildContext context) {
    controller.getSharedWithMe();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () {
          return isLoading.value == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.allShareCompany.isEmpty
                  ? const Center(
                      child: Text("No Shared companies found"),
                    )
                  : ListView.builder(
                      itemCount: controller.allShareCompany.length,
                      itemBuilder: (context, index) {
                        final item = controller.allShareCompany[index];

                        return _buildCompanyCard(
                          item.companyId?.companyName.toString() ?? "No Name",
                          item.companyId?.phoneNo.toString() ??
                              "No Phone Number",
                          status: item.status,
                          showJoinButton: true,
                          onJoinPressed: (value) async {
                            controller.approveRequest(item.id.toString());
                            await controller.switchCompany(
                              item.companyId!.id.toString(),
                            );
                            Restart.restartApp();
                            value = true;
                          },
                          value: value,
                          onRemovePressed: () {
                            log("Removing company: ${item.companyId}");
                          },
                        );
                      },
                    );
        },
      ),
    );
  }

  Widget _buildCompanyCard(
    String name,
    String phoneNumber, {
    String? status,
    required bool showJoinButton,
    required ValueChanged<bool?>? onJoinPressed,
    required VoidCallback onRemovePressed,
    bool? value,
  }) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2, color: const Color.fromARGB(255, 6, 50, 115))),
          child: Icon(
            EneftyIcons.building_outline,
            size: 20.sp,
            color: const Color.fromARGB(255, 6, 50, 115),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color.fromARGB(255, 6, 50, 115),
          ),
        ),
        subtitle: Text(
          phoneNumber,
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        trailing: status == "Accepted"
            ? const SizedBox.shrink()
            : Checkbox(
                checkColor: const Color.fromARGB(255, 6, 50, 115),
                activeColor: Colors.white,
                value: false,
                onChanged: onJoinPressed,
              ),
      ),
    );
  }
}
