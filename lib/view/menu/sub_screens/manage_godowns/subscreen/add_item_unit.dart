// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/item_screen_controller/item_screen_controller.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';
import '../../../../../model/unit_model.dart';

class AddItemUnitPage extends StatefulWidget {
  const AddItemUnitPage({super.key});

  @override
  _AddItemUnitPageState createState() => _AddItemUnitPageState();
}

class _AddItemUnitPageState extends State<AddItemUnitPage> {
  final ItemScreenController controller = Get.put(ItemScreenController());
  String? selectedConversionRateOption;
  @override
  void initState() {
    super.initState();
    selectedConversionRateOption = null;
  }

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
              page: "Add Units",
            ),
          ),
          Positioned(
            top: 145,
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
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Primary Unit Dropdown
                      DropdownButtonFormField<UnitModel>(
                        decoration: const InputDecoration(
                            labelText: 'Primary Unit',
                            border: OutlineInputBorder()),
                        items: controller.primaryUnitList
                            .map(
                              (unit) => DropdownMenuItem(
                                  value: unit, child: Text(unit.name ?? "")),
                            )
                            .toList(),
                        onChanged: (newValue) {
                          if (newValue != null &&
                              newValue.id !=
                                  controller.selectedPrimaryUnit.value.id) {
                            controller.selectedPrimaryUnit.value = newValue;

                            // Reset the selected secondary unit properly
                            controller.selectedSecondaryUnit.value =
                                UnitModel();
                            selectedConversionRateOption =
                                null; // Reset conversion rate option

                            // Update secondary unit list
                            controller.secondaryUnit.assignAll(
                              controller.unitList
                                  .where((item) => item.id != newValue.id)
                                  .toList(),
                            );

                            // Force UI update for proper dropdown reset
                            controller.selectedSecondaryUnit.refresh();
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Secondary Unit Dropdown
                      DropdownButtonFormField<UnitModel>(
                        value: controller.selectedSecondaryUnit.value.id == null
                            ? null
                            : controller.selectedSecondaryUnit.value,
                        decoration: const InputDecoration(
                            labelText: 'Secondary Unit',
                            border: OutlineInputBorder()),
                        items: controller.secondaryUnit
                            .map(
                              (unit) => DropdownMenuItem(
                                  value: unit, child: Text(unit.name ?? "")),
                            )
                            .toList(),
                        onChanged: (newValue) {
                          controller.selectedSecondaryUnit.value =
                              newValue ?? UnitModel();
                        },
                      ),

                      const SizedBox(height: 30),

                      // Conversion Rates Section
                      Obx(() {
                        if (controller.selectedSecondaryUnit.value.id == null) {
                          return const SizedBox.shrink();
                        }

                        // Filter conversion rates that match the selected units
                        final matchingConversions = controller
                            .allConversionReferences
                            .where((reference) =>
                                reference.baseUnit?.id ==
                                    controller.selectedPrimaryUnit.value.id &&
                                reference.secondaryUnit?.id ==
                                    controller.selectedSecondaryUnit.value.id)
                            .toList();

                        // Don't show the section if there are no matching conversions
                        if (matchingConversions.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Previous Conversion Rate',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: matchingConversions.length,
                              itemBuilder: (context, index) {
                                final reference = matchingConversions[index];
                                return Row(
                                  children: [
                                    Radio<String>(
                                      value: reference.conversionRate
                                          .toString(), // Store actual conversion rate
                                      groupValue: selectedConversionRateOption,
                                      onChanged: (value) {
                                        controller.newConversionId.value =
                                            reference.id!;
                                        setState(() {
                                          selectedConversionRateOption =
                                              value; // Update the selected rate
                                        });
                                      },
                                    ),
                                    Text(
                                        '1 ${controller.selectedPrimaryUnit.value.name} = '
                                        '${reference.conversionRate} ${controller.selectedSecondaryUnit.value.name}')
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 20),

                      // Add New Conversion Rate Section
                      Obx(() {
                        if (controller.selectedSecondaryUnit.value.id == null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Add New Conversion Rate',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'custom_conversion',
                                  groupValue: selectedConversionRateOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedConversionRateOption = value;
                                    });
                                  },
                                ),
                                Text(
                                    '1 ${controller.selectedPrimaryUnit.value.name ?? "Select"} = '),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        controller.conversionRateController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*$')),
                                    ],
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(controller
                                        .selectedSecondaryUnit.value.name ??
                                    ''),
                              ],
                            ),
                          ],
                        );
                      }),

                      const Spacer(),
                      // Obx(() => Text("New Conversion ID: ${controller.newConversionId.value}")),
                      // Cancel and Save Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 50, 115),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.youUpdating.value) {}

                              if (controller.selectedPrimaryUnit.value.id ==
                                  null) {
                                SnackBars.showErrorSnackBar(
                                    text: "Please Select Primary Unit");
                                // } else if (controller.selectedSecondaryUnit.value.id == null) {
                                //   SnackBars.showErrorSnackBar(text: "Please Select Secondary Unit");
                              } else if (controller
                                          .selectedSecondaryUnit.value.id !=
                                      null &&
                                  selectedConversionRateOption == null) {
                                SnackBars.showErrorSnackBar(
                                    text:
                                        "Please Select or Add a Conversion Rate");
                              } else if (selectedConversionRateOption ==
                                      'custom_conversion' &&
                                  (controller.conversionRateController.text
                                          .isEmpty ||
                                      double.tryParse(controller
                                              .conversionRateController.text) ==
                                          null)) {
                                SnackBars.showErrorSnackBar(
                                    text:
                                        "Please Enter a Valid Conversion Rate");
                              } else if (controller
                                          .selectedSecondaryUnit.value.id !=
                                      null &&
                                  selectedConversionRateOption != null) {
                                // Determine the selected conversion rate
                                String conversionRate;
                                if (selectedConversionRateOption ==
                                        'custom_conversion' &&
                                    controller.conversionRateController.text !=
                                        "" &&
                                    controller.conversionRateController.text
                                        .isNotEmpty) {
                                  conversionRate =
                                      controller.conversionRateController.text;
                                  controller.addNewConversion(
                                    baseUnit: controller
                                        .selectedPrimaryUnit.value.name!,
                                    secondaryUnit: controller
                                        .selectedSecondaryUnit.value.name!,
                                    conversionRate: conversionRate,
                                  );
                                } else {
                                  conversionRate =
                                      selectedConversionRateOption!;
                                }

                                // Print the selected conversion rate
                                log("Selected Conversion Rate: 1 ${controller.selectedPrimaryUnit.value.name} = $conversionRate ${controller.selectedSecondaryUnit.value.name}");

                                // Refresh and close the screen
                                controller.selectedSecondaryUnit.refresh();
                                controller.selectedPrimaryUnit.refresh();
                                Get.back();
                              } else {
                                controller.selectedSecondaryUnit.refresh();
                                controller.selectedPrimaryUnit.refresh();
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 6, 50, 115),
                              // minimumSize:
                              //     const Size(50, 50), // Ensures square shape
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ), // No rounded corners, making it a square
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
