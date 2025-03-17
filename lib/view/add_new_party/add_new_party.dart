import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/add_party_controller/add_party_controller.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class AddNewPartyPage extends StatelessWidget {
  // Create a GlobalKey for the Scaffold to control its drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _focusNode = FocusNode();

  final _controller = Get.put(AddPartyController());

  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.filteredCPlist.assignAll(_controller.customerPartyNmList);
      } else {
        _controller.filteredCPlist.assignAll([]);
      }
    });
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add New Party",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Use the GlobalKey to open the end drawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          )
        ],
      ),
      endDrawer: Drawer(
        elevation: 16.0,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Party Settings Section
              const ListTile(
                title: Text(
                  'Party Settings',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              ListTile(
                title: const Text(
                  "Tax Registration No",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Obx(() {
                  return Switch(
                    value: _controller.gstinToggle.value,
                    onChanged: (bool value) {
                      _controller.gstinToggle.value = value;
                      if (!value) {
                        // Show snackbar if the toggle is set to false
                        Get.snackbar(
                          "Notification",
                          "Tax Registration No is turned off",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                  );
                }),
              ),
              ListTile(
                title: const Text(
                  "Party Shipping Address",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Obx(() {
                  return Switch(
                    value: _controller.partyShipToggle.value,
                    onChanged: (bool value) {
                      _controller.partyShipToggle.value = value;
                      if (!value) {
                        // Show snackbar if the toggle is set to false
                        Get.snackbar(
                          "Notification",
                          "Party Shipping Address is turned off",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                  );
                }),
              ),

              const Divider(),

              // Others Section
              // const ListTile(
              //   title: Text(
              //     'OTHERS',
              //     style: TextStyle(color: Colors.grey, fontSize: 14),
              //   ),
              // ),
              // ListTile(
              //   title: const Text(
              //     "Party Grouping",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   trailing: Obx(() {
              //     return Switch(
              //       value: _controller.partyGroupingToggle.value,
              //       onChanged: (bool value) {
              //         _controller.partyGroupingToggle.value = value;
              //         // setState(() {
              //         //   partyGroupingToggle = value;
              //         // });
              //       },
              //     );
              //   }),
              // ),

              // Expansion Tile for Party Additional Fields
              // Obx(() {
              //   return ExpansionTile(
              //     title: const Text(
              //       "Party Additional Fields",
              //       style: TextStyle(color: Colors.black),
              //     ),
              //     trailing: Icon(_controller.isExpanded.value
              //         ? Icons.arrow_drop_up
              //         : Icons
              //             .arrow_drop_down), // Change icon based on expanded state
              //     onExpansionChanged: (bool expanded) {
              //       _controller.isExpanded.value = expanded;
              //       // setState(() {
              //       //   isExpanded = expanded; // Update expanded state
              //       // });
              //     },
              //     children: [
              //       Column(
              //         children:
              //             _controller.additionalFields.keys.map((String key) {
              //           return CheckboxListTile(
              //             title: Text(key),
              //             value: _controller.additionalFields[key],
              //             onChanged: (bool? value) {
              //               _controller.additionalFields[key] = value ?? false;
              //               // setState(() {
              //               //   additionalFields[key] = value ?? false;
              //               // });
              //             },
              //           );
              //         }).toList(),
              //       ),
              //       // Save Button
              //       Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: SizedBox(
              //           width: double.infinity, // Make button take full width
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               shape: const RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.zero),
              //               backgroundColor: Colors.blue, // Blue background
              //             ),
              //             onPressed: () {
              //               // Handle save logic here
              //             },
              //             child: const Text(
              //               "Save",
              //               style: TextStyle(color: Colors.white), // White text
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              // }),

              // ListTile(
              //   title: const Text(
              //     "Invite parties to add\nthemselves",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   trailing: Obx(() {
              //     return Switch(
              //       value: _controller.inviteToggle.value,
              //       onChanged: (bool value) {
              //         _controller.inviteToggle.value = value;
              //         // setState(() {
              //         //   inviteToggle = value;
              //         // });
              //       },
              //     );
              //   }),
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invite Parties Banner
              // Card(
              //   color: Colors.pink[50],
              //   child: ListTile(
              //     leading: const Icon(Icons.share, color: Colors.red),
              //     title: const Text("Invite Parties",
              //         style: TextStyle(color: Colors.black)),
              //     subtitle: const Text("to fill their details",
              //         style: TextStyle(color: Colors.black)),
              //     trailing: Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 8.0, vertical: 4.0),
              //       decoration: BoxDecoration(
              //         color: Colors.red,
              //         borderRadius: BorderRadius.circular(12.0),
              //       ),
              //       child: const Text("Premium",
              //           style: TextStyle(color: Colors.white, fontSize: 12)),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),

              // Party Name Input

              const SizedBox(height: 8),
              TextFormField(
                style: interFontBlack(context,
                    color: Colorconst.cBlack, fontsize: 17.sp),
                controller: _controller.pNameController,
                focusNode: _focusNode,
                // onChanged: (value) {
                //   _controller.filterCustomer(name: value);
                // },
                decoration: InputDecoration(
                  hintText: "e.g. Ram Prasad",
                  labelText: "Party Name*",
                  helperStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // GSTIN Input
              Obx(() {
                return _controller.gstinToggle.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _controller.pGstinController,
                            style: TextStyle(color: Colors.black, fontSize: 17),
                            decoration: InputDecoration(
                              labelText: "Tax Registration No",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox
                        .shrink(); // Empty widget if toggle is disabled
              }),

              SizedBox(
                height: 20.h,
              ),

              CustomTextFormField(
                hintText: "example@gmail.com",
                labelText: "Email Id",
                keyboardType: TextInputType.emailAddress,
                controller: _controller.emailController,
              ),
              SizedBox(
                height: 20.h,
              ),

              CustomTextFormField(
                hintText: "0123456789",
                labelText: "Contact Number",
                inputFormaters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: _controller.contactNumController,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      hintText: "Opening Balance",
                      inputFormaters: [FilteringTextInputFormatter.digitsOnly],
                      labelText: "Opening Balance",
                      // hintText: "Opening Balance",
                      keyboardType: TextInputType.number,
                      controller: _controller.openingBalanceController,
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String? date =
                            await ContextProvider().selectDate(context);
                        log("date++++++ ==$date");
                        if (date == null) {
                        } else {
                          _controller.asOfDateController.text = date;
                        }
                      },
                      child: CustomTextFormField(
                        isEditable: false,
                        labelText: "As of Date",
                        hintText: "As of Date",
                        controller: _controller.asOfDateController,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20.h,
              ),
              customTextFormFieldNew(
                  controller: _controller.billingAddressController,
                  maxLines: 3,
                  hintText: "Billing Address",
                  labelText: "Billing Address"),
              SizedBox(
                height: 20.h,
              ),

              Obx(() {
                return _controller.partyShipToggle.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTextFormFieldNew(
                            controller: _controller.shippingAddressController,
                            maxLines: 3,
                            hintText: "Shipping Address",
                            labelText: "Shipping Address",
                          ),
                        ],
                      )
                    : const SizedBox
                        .shrink(); // Empty widget if toggle is disabled
              }),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.isToPay.value = true;
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 14.w,
                            width: 14.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    width: _controller.isToPay.value == true
                                        ? 8.w
                                        : 1.w,
                                    color: Colors.blue)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "To Receive",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    InkWell(
                      onTap: () {
                        _controller.isToPay.value = false;
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 14.w,
                            width: 14.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    width: _controller.isToPay.value == false
                                        ? 8.w
                                        : 1.w,
                                    color: Colors.blue)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "To Pay",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(
                height: 90.h,
              ),
              // Spacer(),

              // Buttons at the bottom
              Obx(() {
                return isLoading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                printInfo(info: "is clicked save party");
                                bool isVal = _controller.validateParty();
                                if (isVal) {
                                  _controller.isEditingParty.value == true
                                      ? _controller.updateParty()
                                      : _controller.addParty();
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      Colors.blue[300], // Button color
                                ),
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  printInfo(info: "is clicked save party");
                                  bool isVal = _controller.validateParty();
                                  if (isVal) {
                                    _controller.isEditingParty.value == true
                                        ? _controller.updateParty()
                                        : _controller.addParty();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue, // Button color
                                ),
                                child: const Text("Save Party",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
