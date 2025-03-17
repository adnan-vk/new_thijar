// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newthijar/controller/add_godown_controller/add_godown_controller.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_godown.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/add_item_to_stock.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/date_inv_widget/date_inv_widget.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class StockTransferPage extends StatefulWidget {
  const StockTransferPage({super.key});

  @override
  _StockTransferPageState createState() => _StockTransferPageState();
}

class _StockTransferPageState extends State<StockTransferPage> {
  final AddGodownController controller = Get.find<AddGodownController>();

  // final List<Map<String, dynamic>> _tableData = [];
  String? _selectedFrom;
  String? _selectedTo;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    controller.stockItemList.clear();
    controller.fetchAllGodowns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20),
        height: 80,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: 1.0,
          child: InkWell(
            onTap: () async {
              await controller.addStockTransfer(
                  toGodown: _selectedTo ?? "",
                  fromGodown: _selectedFrom ?? "",
                  transferDate: _selectedDate ?? DateTime.now());
            },
            child: Container(
              color: const Color.fromARGB(255, 6, 50, 115),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Center(
                    child: Text(
                  "Save",
                  style: interFontGrey(context).copyWith(
                    color: Colors.white,
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Stock Transfer",
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateInvoiceWidget(
                      date: _selectedDate == null
                          ? 'date'
                          : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                      invoiceNumber: 'Doc No',
                      hideInvoice: true,
                      onTapDate: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _selectedDate = selectedDate;
                        }
                        setState(() {});
                      },
                    ),
                    const Divider(
                        thickness: 1.2, color: Colors.grey), // Thicker divider
                    const SizedBox(height: 16),

                    // From and To Dropdowns with Shadow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // From Dropdown
                        Expanded(
                          child: Obx(() {
                            final items = controller.allGodowns
                                .map((godown) => godown.name ?? '')
                                .where((name) => name.isNotEmpty)
                                .toSet()
                                .toList();

                            return _buildBottomSheetSelector(
                              title: 'Select From',
                              value: _selectedFrom,
                              items: items,
                              onItemSelected: (value) {
                                setState(() {
                                  _selectedFrom = value;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 16),
                        // To Dropdown
                        Expanded(
                          child: Obx(() {
                            final items = controller.allGodowns
                                .map((godown) => godown.name ?? '')
                                .where((name) => name.isNotEmpty)
                                .toSet()
                                .toList();

                            return _buildBottomSheetSelector(
                              title: 'Select To',
                              value: _selectedTo,
                              items: items,
                              onItemSelected: (value) {
                                if ((_selectedFrom ?? "")
                                        .trim()
                                        .toLowerCase() ==
                                    (value ?? "").trim().toLowerCase()) {
                                  Get.snackbar(
                                    "Note",
                                    "'To-Godown' should be different then 'From-Godown'",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  setState(() {
                                    _selectedTo = value;
                                  });
                                }
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Table to display added rows
                    Obx(() {
                      return ListView.builder(
                        itemCount: controller.stockItemList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final row = controller.stockItemList[index];
                          return Card(
                            color: Colors.white,
                            elevation: 5,
                            // Subtle shadow for depth
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row with Sl No and delete button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        row.name ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            controller.stockItemList
                                                .removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: TextButton(
        onPressed: () {
          Get.to(const AddItemToStockTransfer());
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        child: const Text(
          'Add Item',
          style: TextStyle(color: Color.fromARGB(255, 6, 50, 115)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBottomSheetSelector({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onItemSelected,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // List of items
                ...items.map((item) {
                  return ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(item);
                    },
                  );
                }),
                const Divider(),
                // Button to add new godown
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.to(const AddGodown());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Godown"),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Add this to allow text to take available space
              child: Text(
                value ?? title,
                style: TextStyle(
                  color: value == null ? Colors.grey : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow
                    .ellipsis, // This handles overflow by showing ellipsis
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
