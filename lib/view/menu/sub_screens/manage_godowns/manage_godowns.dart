import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/add_godown_controller/add_godown_controller.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_godown.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/godown_transaction_page.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/stock_transfer.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class ManageGodownsScreen extends StatelessWidget {
  final AddGodownController controller = Get.put(AddGodownController());

  ManageGodownsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchAllGodowns();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 185,
            child: TopBar(
              page: "Manage Godowns",
            ),
          ),
          Positioned(
            top: 155,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildGodownCard(
                      title: 'Main Godown',
                      subtitle: '+ Add Phone or Email\n+ Add Address',
                      badgeText: 'MAIN GODOWN',
                      isMain: true,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Godowns',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Obx(() {
                        return isLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : controller.allGodowns.isEmpty
                                ? const Center(
                                    child: Text('No Godowns available'),
                                  )
                                : ListView.builder(
                                    itemCount: controller.allGodowns.length,
                                    itemBuilder: (context, index) {
                                      final godown =
                                          controller.allGodowns[index];
                                      return buildGodownCard(
                                        onDelete: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Are you sure?'),
                                                content: const Text(
                                                    'Do you really want to delete this item?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .red, // Delete button color
                                                    ),
                                                    onPressed: () {
                                                      controller.deleteGodown(
                                                          godown.id.toString());
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        title: godown.name ?? 'Unnamed',
                                        subtitle:
                                            '${godown.phoneNo ?? 'No Phone'}\n${godown.address ?? '+ Add Address'}',
                                        badgeText: godown.isMain == true
                                            ? 'MAIN GODOWN'
                                            : godown.type.toString(),
                                        isMain: godown.isMain ?? false,
                                      );
                                    },
                                  );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(context),
    );
  }

  Widget buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextButton(
              onPressed: () {
                Get.to(const StockTransferPage());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    EneftyIcons.arrow_swap_horizontal_outline,
                    color: Colors.black,
                  ),
                  Text(
                    "Transfer Stock",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191)
                ], // Gradient blue
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: TextButton(
              onPressed: () async {
                Get.to(const AddGodown());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    EneftyIcons.add_outline,
                    color: Colors.white,
                  ),
                  Text(
                    "Add Godown",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGodownCard({
    required String title,
    required String subtitle,
    required String badgeText,
    bool isMain = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(const GodownTransactionsPage());
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isMain
                              ? const Color.fromARGB(255, 6, 50, 115)
                              : Colors.black,
                        ),
                      ),
                    ),
                    if (badgeText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 6, 50, 115),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: onEdit,
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
