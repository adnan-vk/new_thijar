// import 'dart:developer';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:newthijar/constants/colors.dart';
// import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
// import 'package:newthijar/model/customer_party_model.dart';
// import 'package:newthijar/model/invoice_model.dart';
// import 'package:newthijar/model/invoive_no_model.dart';
// import 'package:newthijar/model/item_model.dart';
// import 'package:newthijar/model/state_model.dart';
// import 'package:newthijar/view/add_bank_screen/add_bank_screen.dart';
// import 'package:newthijar/view/add_new_party/add_new_party.dart';
// import 'package:newthijar/view/home_page/widgets/widgets.dart';
// import 'package:newthijar/view/menu/sub_screens/settings/settings.dart';
// import 'package:newthijar/widgets/bottom_button/bottom_button.dart';
// import 'package:newthijar/widgets/context_provider/context_provider.dart';
// import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
// import 'package:newthijar/widgets/date_inv_widget/date_inv_widget.dart';
// import 'package:newthijar/widgets/loading/loading.dart';
// import 'package:newthijar/widgets/text_style/text_style.dart';
// import 'package:newthijar/widgets/zigzag_clipper/zigzag_clipper.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class AddSaleInvoiceScreen extends StatefulWidget {
//   final InvoiceModel? object;

//   const AddSaleInvoiceScreen({super.key, this.object});

//   @override
//   State<AddSaleInvoiceScreen> createState() => _AddSaleInvoiceScreenState();
// }

// class _AddSaleInvoiceScreenState extends State<AddSaleInvoiceScreen> {
//   final _controller = Get.put(TransactionDetailController());

//   void _showStateSelectionBottomSheet(context) {
//     if (_controller.stateList.length.toInt() == 0) {
//       _controller.fetchStates();
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.7,
//           // Adjust size as needed
//           maxChildSize: 0.9,
//           minChildSize: 0.3,
//           builder: (_, controller) {
//             return Column(
//               children: [
//                 // Header of Bottom Sheet
//                 ListTile(
//                   title: const Text("Select State of Supply"),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () {
//                       Get.back();
//                     },
//                   ),
//                 ),
//                 const Divider(),
//                 Obx(() {
//                   return Expanded(
//                     child: isLoading.value == true
//                         ? Center(
//                             child: SizedBox(
//                                 height: 80.w,
//                                 width: 80.w,
//                                 child: const CircularProgressIndicator()),
//                           )
//                         : _controller.stateList.length.toInt() == 0
//                             ? Center(
//                                 child: Text(
//                                 "No Data Found",
//                                 style: TextStyle(
//                                     fontSize: 20.sp, color: Colors.black),
//                               ))
//                             : ListView.builder(
//                                 controller: controller,
//                                 itemCount: _controller.stateList.length,
//                                 itemBuilder: (context, index) {
//                                   StateModel obj = _controller.stateList[index];
//                                   return ListTile(
//                                     title: Text(obj.name.toString()),
//                                     onTap: () {
//                                       // _controller.selectedState!.value =
//                                       // states[index].toString();
//                                       _controller.selectedState.value = obj;

//                                       Get.back();
//                                       // setState(() {
//                                       //   selectedState =
//                                       //       states[index]; // Update selected state
//                                       // });
//                                       // Navigator.pop(
//                                       //     context); // Close the bottom sheet after selecting
//                                     },
//                                   );
//                                 },
//                               ),
//                   );
//                 }),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void onReceivedChange() {
//     if (_controller.isChecked.value) {
//       _controller.youRedting.value
//           ? _controller.recivedAmountController.text =
//               (_controller.currentRecivedAmountController.text).toString()
//           : _controller.recivedAmountController.text =
//               _controller.grandSubTotal.value.toString();
//       _controller.balanceDue.value = _controller.grandSubTotal.value -
//           double.parse(_controller.recivedAmountController.text);
//       // _controller.recivedAmountController.text =
//       //     _controller.grandSubTotal.value.toString();
//       // _controller.balanceDue.value = _controller.grandSubTotal.value -
//       //     double.parse(_controller.recivedAmountController.text);
//     } else {
//       _controller.recivedAmountController.text = '0.0';
//       _controller.balanceDue.value =
//           double.parse(_controller.totalAmountContr.text);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     onReceivedChange();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size using MediaQuery
//     // final screenHeight = MediaQuery.of(context).size.height;
//     // final screenWidth = MediaQuery.of(context).size.width;

//     log("${_controller.selectedSaleDate}");
//     return Scaffold(
//       backgroundColor: Colorconst.cSecondaryGrey,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//             onPressed: () {
//               // Navigator.pop(context);
//               Get.back();
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             )),
//         title: const Text(
//           "Sale",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Obx(() {
//             return ToggleSwitch(
//               minHeight: 28.h,
//               minWidth: 58.w,
//               cornerRadius: 20.r,
//               activeBgColors: [
//                 [Colors.red[800]!],
//                 [Colors.green[800]!],
//               ],
//               activeFgColor: Colors.white,
//               inactiveBgColor: Colors.grey,
//               inactiveFgColor: Colors.white,
//               initialLabelIndex: _controller.selectedIndex.value,
//               totalSwitches: 2,
//               labels: const ['Credit', 'Cash'],
//               customTextStyles: [
//                 TextStyle(color: Colors.white, fontSize: 13.sp)
//               ],
//               radiusStyle: true,
//               onToggle: (index) {
//                 _controller.selectedIndex.value = index!;
//                 _controller.setSaleFormType(index);
//                 // setState(() {
//                 //   selectedIndex = index!; // Update the selected index
//                 // });
//                 // print('switched to: $index');
//               },
//             );
//           }),
//           SizedBox(width: 10.w),
//           IconButton(
//             onPressed: () {
//               Get.to(const SettingScreen());
//             },
//             icon: const Icon(
//               Icons.settings_outlined,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(width: 10.w),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 500.h),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Obx(() {
//                         return DateInvoiceWidget(
//                           invoiceNumber:
//                               _controller.invoiceNo.value.invoiceNo == null
//                                   ? "1"
//                                   : _controller.invoiceNo.value.invoiceNo
//                                       .toString(),
//                           ontapInvoice: () {
//                             showInvoiceInputTypeDialog(
//                               onSelectItem: (p0) {
//                                 log("p0==$p0");
//                                 if (p0 == 'Fetch') {
//                                   _controller.fetchInvoicNo();
//                                   Get.back();
//                                 } else if (p0 == '' || p0.isEmpty) {
//                                   _controller.fetchInvoicNo();
//                                   Get.back();
//                                 } else {
//                                   InvoiceNoModel model = InvoiceNoModel(
//                                     invoiceNo: p0,
//                                   );
//                                   _controller.invoiceNo.value = model;
//                                 }
//                               },
//                             );
//                           },
//                           onTapDate: () async {
//                             String? date =
//                                 await ContextProvider().selectDate(context);
//                             log("date++++++ ==$date");
//                             if (date == null) {
//                             } else {
//                               _controller.selectedSaleDate.value = date;
//                             }
//                           },
//                           date: _controller.selectedSaleDate.value.isEmpty
//                               ? _controller.defaultDate
//                               : _controller.selectedSaleDate.value,
//                         );
//                       }),
//                       SizedBox(height: 10.h),
//                       _buildFormContainer(context),
//                     ],
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildTextLabel("Total Amount"),
//                         _buildAmountInputField(),
//                       ],
//                     ),
//                   ),
//                   Obx(() {
//                     return _controller.grandSubTotal.value == 0.0
//                         ? const SizedBox()
//                         : Column(
//                             children: [
//                               _controller.selectedIndex.value == 0
//                                   ? Column(
//                                       children: [
//                                         _buildReceivedAmountSection(),
//                                         SizedBox(height: 12.h),
//                                         _buildBalanceDueSection(),
//                                       ],
//                                     )
//                                   : const SizedBox(),
//                               _buildZigzagSeparator(),
//                               SizedBox(height: 12.h),
//                               _buildPaymentSection(context),
//                               SizedBox(height: 12.h),
//                               // _buildDescriptionAndPhotoSection(),
//                               // _buildAddDocumentButton(),
//                             ],
//                           );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//           // Positioned(
//           //   bottom: 45,
//           //   left: 0,
//           //   right: 0,
//           //   child: Container(
//           //     color: Colorconst.cLightPink,
//           //     padding:
//           //         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           //     child: Row(
//           //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //       children: [
//           //         Text(
//           //           "Your Current Plan May not support some features",
//           //           style:
//           //               GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
//           //           // textAlign: TextAlign.center,
//           //         ),
//           //         Icon(
//           //           Icons.arrow_forward_ios_outlined,
//           //           size: screenWidth * 0.020,
//           //           color: Colorconst.cGrey,
//           //         )
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           // Bottom button fixed at the bottom
//           Obx(() {
//             return Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: isLoading.value == true
//                   ? const SizedBox(
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : BottomButton(
//                       onClickCancel: () => Get.back(),
//                       //     : null,
//                       // onClickSave: () => _controller.saleValidator() == "ok"
//                       //     ? _controller.youRedting.value
//                       //         ? _controller.updateSale()
//                       //         : _controller.addSale()
//                       //     : null,
//                       onClickSave: () async {
//                         _controller.saleValidator() == "ok"
//                             ? _controller.youRedting.value
//                                 ? await _controller.updateSale()
//                                 : await _controller.addSale()
//                             : null;
//                         await _controller.clearController();
//                         log("balance amount : ${_controller.balanceDue}");
//                         // await Get.to(() => PdfPreviewPage(
//                         //       type: "Sale",
//                         //       id: widget.object!.id,
//                         //       page: "Sale",
//                         //     ));
//                         _controller.selectedSaleDate.value =
//                             ContextProvider().getCurrentDate();
//                       },
//                     ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextLabel(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Colorconst.cBlack,
//         fontSize: 15.sp,
//       ),
//     );
//   }

//   Widget _buildReceivedAmountSection() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10), // Fixed padding
//       child: GestureDetector(
//         onTap: () {
//           printInfo(info: "clicked");

//           _controller.isChecked.value = !_controller.isChecked.value;

//           if (_controller.isChecked.value) {
//             _controller.recivedAmountController.text =
//                 _controller.grandSubTotal.value.toString();
//             _controller.balanceDue.value = _controller.grandSubTotal.value -
//                 double.parse(_controller.recivedAmountController.text);
//           } else {
//             _controller.recivedAmountController.text = '0.0';
//             _controller.balanceDue.value =
//                 double.parse(_controller.totalAmountContr.text);
//           }
//           // isReceivedChecked.value = !isReceivedChecked.value;
//           // _controller.receivedAmountNotifier.value =
//           //     isReceivedChecked.value ? totalAmount : 0.0;
//           // if (_controller.isReceivedChecked.value) {
//           //   _controller.recivedAmountController.text = totalAmount.toString();
//           // } else {
//           //   _controller.recivedAmountController.text = "";
//           // }
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildCheckBoxWithLabel(),
//             // _buildReceivedAmountInput(totalAmount),
//             SizedBox(
//               width: 110.w,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 0,
//                     right: 10,
//                     bottom: 1, // Fixed bottom position
//                     child: CustomPaint(
//                       painter: DottedLinePainter(),
//                     ),
//                   ),
//                   TextFormField(
//                     keyboardType: TextInputType.number,
//                     controller: _controller.recivedAmountController,
//                     decoration: const InputDecoration(
//                       hintText: "₹",
//                       border: InputBorder.none,
//                       contentPadding:
//                           EdgeInsets.only(left: 10), // Fixed padding
//                     ),
//                     onChanged: (value) {
//                       //   receivedAmountNotifier.value = double.tryParse(value) ?? 0.0;
//                       // if (_controller.isChecked.value) {
//                       //   _controller.balanceDue.value = double.parse(
//                       //           _controller.totalAmountContr.text == ''
//                       //               ? '0.0'
//                       //               : _controller.totalAmountContr.text) -
//                       //       double.parse(
//                       //           _controller.recivedAmountController.text == ""
//                       //               ? "0.0"
//                       //               : _controller.recivedAmountController.text);
//                       // }
//                       if (_controller.isChecked.value) {
//                         final totalAmount = double.tryParse(
//                                 _controller.totalAmountContr.text) ??
//                             0.0;
//                         final receivedAmount = double.tryParse(
//                                 _controller.recivedAmountController.text) ??
//                             0.0;

//                         _controller.balanceDue.value =
//                             totalAmount - receivedAmount;
//                       }
//                     },
//                     style: TextStyle(
//                         fontSize: 16.sp,
//                         color: Colors.black), // Fixed font size
//                     // initialValue:
//                     //     isReceivedChecked.value ? totalAmount.toString() : '',
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCheckBoxWithLabel() {
//     return Row(
//       children: [
//         Container(
//           width: 18.w, // Fixed width
//           height: 18.w, // Fixed height
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue, width: 2.w),
//             borderRadius: BorderRadius.circular(2.r),
//             color:
//                 _controller.isChecked.value ? Colors.blue : Colors.transparent,
//           ),
//           child: _controller.isChecked.value
//               ? Center(
//                   child: Icon(Icons.check, color: Colors.white, size: 15.sp),
//                 )
//               : null,
//         ),
//         const SizedBox(width: 8), // Fixed spacing
//         const Text(
//           "Received",
//           style: TextStyle(fontSize: 14, color: Colors.black),
//         ),
//       ],
//     );
//   }

//   // Widget _buildReceivedAmountInput(double totalAmount) {
//   Widget _buildBalanceDueSection() {
//     return Padding(
//         padding: EdgeInsets.only(left: 10.w, right: 10.w), // Fixed padding
//         child:
//             // double balanceDue = totalAmount - receivedAmount;
//             Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Balance Due",
//                 style: TextStyle(color: Colors.green, fontSize: 14)),
//             Text(
//                 _controller.isChecked.value
//                     ? "₹ ${_controller.balanceDue.toStringAsFixed(2)}"
//                     : "₹ ${_controller.totalAmountContr.text}",
//                 style: const TextStyle(color: Colors.green, fontSize: 14)),
//           ],
//         ));
//   }

//   Widget _buildZigzagSeparator() {
//     return ClipPath(
//       clipper: ZigzagClipper(),
//       child: Container(
//           color: Colors.white,
//           height: 10,
//           width: double.infinity), // Fixed height for the zigzag separator
//     );
//   }

//   Widget _buildPaymentSection(context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       color: Colors.white,
//       child: Column(
//         children: [
//           _buildRowWithIcon(
//               "Payment Type",
//               Icons.money,
//               _controller.selectedPaymentType.value.accountHolderName
//                   .toString()),
//           const SizedBox(height: 10),
//           _controller.selectedPaymentType.value.accountHolderName == 'Cheque'
//               ? _checkReferenceWidget()
//               : const SizedBox(),
//           const SizedBox(height: 10),
//           InkWell(
//             onTap: () {
//               showPaymentTypeBottom(
//                   onClickClose: () => Get.back(),
//                   payableMethod: (p0) {
//                     _controller.selectedPayableMethod.value = p0;
//                   },
//                   bankList: _controller.bankList,
//                   onSelectItem: (p0) {
//                     _controller.selectedPaymentType.value = p0;
//                     // log("selected payment method ==${p0!.toJson()}");
//                   },
//                   onClickAddBank: () {
//                     Get.back();
//                     Get.to(() => AddBankScreen());
//                   });
//             },
//             child: const Row(children: [
//               Icon(Icons.add, color: Colors.blue),
//               Text("Add Payment Type", style: TextStyle(color: Colors.blue))
//             ]),
//           ),
//           // const Divider(),
//           // GestureDetector(
//           //     onTap: () => _showStateSelectionBottomSheet(context),
//           //     child: _buildRowWithText("State of Supply",
//           //         _controller.selectedState.value.name ?? "Select State")),
//         ],
//       ),
//     );
//   }

//   // Widget _buildDescriptionAndPhotoSection() {
//   //   return Row(
//   //     children: [
//   //       _buildDescriptionField(),
//   //       _buildAddPhotoContainer(),
//   //     ],
//   //   );
//   // }

//   // Widget _buildDescriptionField() {
//   //   return Expanded(
//   //     flex: 2,
//   //     child: Container(
//   //       padding: const EdgeInsets.all(10),
//   //       color: Colors.white,
//   //       child: TextFormField(
//   //         controller: _controller.descriptionContr,
//   //         style: TextStyle(color: Colors.black, fontSize: 14.sp),
//   //         decoration: const InputDecoration(
//   //             labelText: 'Description',
//   //             hintText: 'Add Note',
//   //             border: OutlineInputBorder()),
//   //         maxLines: 3,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildAddPhotoContainer() {
//   //   return Expanded(
//   //     child: Container(
//   //       padding: const EdgeInsets.all(10),
//   //       height: 110.h,
//   //       color: Colors.white,
//   //       child: InkWell(
//   //         onTap: () => _controller.chooseImage(),
//   //         child: Container(
//   //           decoration: BoxDecoration(
//   //               color: Colors.white,
//   //               borderRadius: BorderRadius.circular(8.0),
//   //               border: Border.all(color: Colors.grey.shade700)),
//   //           child: _controller.imgPath.value != ''
//   //               ? ClipRRect(
//   //                   child: Image.file(
//   //                   File(_controller.imgPath.value),
//   //                   fit: BoxFit.cover,
//   //                 ))
//   //               : const Center(
//   //                   child:
//   //                       Icon(Icons.add_a_photo, color: Colors.blue, size: 30)),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildAddDocumentButton() {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(10.0),
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           child: SizedBox(
//   //             height: 110.h,
//   //             child: OutlinedButton(
//   //               onPressed: () {
//   //                 _controller.chooseDocument();
//   //               },
//   //               style: ButtonStyle(
//   //                 side: WidgetStateProperty.all(
//   //                     const BorderSide(color: Colors.black, width: 2)),
//   //                 shape: WidgetStateProperty.all(RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(8))),
//   //               ),
//   //               child: Padding(
//   //                 padding: EdgeInsets.only(left: 50.w),
//   //                 child: Row(
//   //                   children: [
//   //                     const Icon(Icons.document_scanner_outlined,
//   //                         color: Colors.grey),
//   //                     Text(
//   //                         _controller.documentName.value != ''
//   //                             ? _controller.documentName.value
//   //                             : 'Add Your Documents',
//   //                         style: const TextStyle(color: Colors.grey))
//   //                   ],
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildRowWithIcon(String text, IconData icon, String trailingText) {
//     return Obx(() {
//       _controller.selectedPaymentType.value;
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(text, style: const TextStyle(color: Colors.grey)),
//           InkWell(
//             onTap: () {
//               showPaymentTypeBottom(
//                   onClickClose: () => Get.back(),
//                   payableMethod: (p0) {
//                     _controller.selectedPayableMethod.value = p0;
//                   },
//                   bankList: _controller.bankList,
//                   onSelectItem: (p0) {
//                     _controller.selectedPaymentType.value = p0;
//                     // log("selected payment method ==${p0!.toJson()}");
//                   },
//                   onClickAddBank: () {
//                     Get.back();
//                     Get.to(() => AddBankScreen());
//                   });
//             },
//             child: Row(children: [
//               Icon(icon, color: Colors.green),
//               SizedBox(
//                 width: 7.w,
//               ),
//               Obx(() {
//                 return Text(
//                   _controller.selectedPaymentType.value.accountHolderName
//                       .toString(),
//                   style: TextStyle(color: Colors.black, fontSize: 14.sp),
//                 );
//               }),
//               SizedBox(
//                 width: 7.w,
//               ),
//               const Icon(Icons.arrow_drop_down)
//             ]),
//           ),
//         ],
//       );
//     });
//   }

//   // Widget _buildRowWithText(String text, String trailingText) {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //     children: [
//   //       Text(text, style: const TextStyle(color: Colors.grey)),
//   //       Row(children: [
//   //         Text(
//   //           trailingText,
//   //           style: TextStyle(color: Colors.black, fontSize: 13.sp),
//   //         ),
//   //         const Icon(Icons.arrow_drop_down)
//   //       ]),
//   //     ],
//   //   );
//   // }

//   Widget _checkReferenceWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Payment Ref No.",
//           style: GoogleFonts.inter(
//               fontSize: 13.sp,
//               color: Colors.black45,
//               fontWeight: FontWeight.w400),
//         ),
//         SizedBox(
//           width: 120.w,
//           child: Stack(
//             children: [
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 10.h,
//                 child: CustomPaint(
//                   painter: DottedLinePainter(),
//                 ),
//               ),
//               TextFormField(
//                 keyboardType: TextInputType.number,
//                 controller: _controller.referenceNoContr,
//                 decoration: InputDecoration(
//                   hintStyle: TextStyle(fontSize: 12.sp, color: Colors.black45),
//                   hintText: "Referenc No.",
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.only(left: 20.w),
//                 ),
//                 onChanged: (value) {},
//                 style: TextStyle(fontSize: 14.sp, color: Colorconst.cBlack),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildAmountInputField() {
//     return SizedBox(
//       width: 100.w,
//       child: Stack(
//         children: [
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 10.h,
//             child: CustomPaint(
//               painter: DottedLinePainter(),
//             ),
//           ),
//           TextFormField(
//             keyboardType: TextInputType.number,
//             controller: _controller.totalAmountContr,
//             decoration: InputDecoration(
//               hintText: "₹",
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(left: 20.w),
//             ),
//             onChanged: (value) {
//               _controller.grandSubTotal.value = double.tryParse(value) ?? 0.0;
//               _controller.balanceDue.value = _controller.grandSubTotal.value;
//               // double parsedValue = double.tryParse(value) ?? 0.0;
//               // totalAmountNotifier.value = parsedValue;
//               // if (isReceivedChecked.value) {
//               //   receivedAmountNotifier.value = parsedValue;

//               // }
//             },
//             style: TextStyle(fontSize: 15.sp, color: Colorconst.cBlack),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFormContainer(context) {
//     return Obx(() {
//       return Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),
//             Obx(() {
//               return DropdownSearch<CustomerPartyModelList>(
//                 items: (filter, loadProps) async {
//                   if (_controller.customerPartyNmList.isEmpty) {
//                     await _controller.fetchCustomerParty();
//                   }
//                   return _controller.customerPartyNmList;
//                 },
//                 itemAsString: (item) => item.name ?? "",
//                 selectedItem: _controller.selectedCustomer.value,
//                 onChanged: (value) {
//                   _controller.selectedCustomer.value = value;
//                   if (value != null) {
//                     _controller.customerTxtCont.text = value.name ?? "";
//                     _controller.phoneNumberController.text =
//                         value.phoneNo ?? "";
//                   }
//                 },
//                 decoratorProps: DropDownDecoratorProps(
//                   decoration: InputDecoration(
//                     hintText: _controller.youRedting.value
//                         ? _controller.customerTxtCont.text
//                         : _controller.selectedIndex.value == 0
//                             ? "Customer *"
//                             : "Billing Name *",
//                     constraints: BoxConstraints(maxHeight: 50.h),
//                     border: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(width: 1.w, color: Colorconst.cGrey),
//                         borderRadius: BorderRadius.circular(5.r)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.w, color: Colors.blue),
//                         borderRadius: BorderRadius.circular(5.r)),
//                     suffixIcon: InkWell(
//                       onTap: () {
//                         _controller.customerTxtCont.text = '';
//                         Get.to(() => AddNewPartyPage());
//                       },
//                       child: Icon(
//                         Icons.add,
//                         size: 25.sp,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ),
//                 suffixProps: const DropdownSuffixProps(
//                     dropdownButtonProps: DropdownButtonProps(isVisible: false)),
//                 compareFn: (item1, item2) {
//                   return item1.name?.trim().toLowerCase() ==
//                       item2.name?.trim().toLowerCase();
//                 },
//                 dropdownBuilder: (context, selectedItem) {
//                   return Text(selectedItem?.name ?? "",
//                       style: const TextStyle(color: Colors.black));
//                 },
//                 popupProps: PopupProps.menu(
//                   cacheItems: true,
//                   showSearchBox: true,
//                   containerBuilder: (context, popupWidget) => Container(
//                     color: Colors.white,
//                     child: popupWidget,
//                   ),
//                   searchFieldProps: TextFieldProps(
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       labelText: "Search",
//                       constraints: BoxConstraints(maxHeight: 50.h),
//                       border: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.w, color: Colorconst.cGrey),
//                           borderRadius: BorderRadius.circular(5.r)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.w, color: Colors.blue),
//                           borderRadius: BorderRadius.circular(5.r)),
//                     ),
//                   ),
//                   itemBuilder: (context, obj, isDisabled, isSelected) {
//                     return Container(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ListTile(
//                                 title: Text(
//                                   obj.name.toString(),
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 15.sp),
//                                 ),
//                                 trailing: Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 6.h),
//                                   child: Column(
//                                     children: [
//                                       double.parse(obj.balance.toString()) > 0
//                                           ? Icon(Icons.arrow_outward_outlined,
//                                               color: Colors.green, size: 22.sp)
//                                           : Icon(Icons.arrow_downward_outlined,
//                                               color: Colors.red, size: 22.sp),
//                                       Text(obj.balance.toString())
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
//                             SizedBox(width: 10.w)
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   searchDelay: const Duration(milliseconds: 500),
//                 ),
//               );
//             }),
//             SizedBox(height: 25.h),
//             Obx(() {
//               return DropdownSearch<CustomerPartyModelList>(
//                 items: (filter, loadProps) async {
//                   if (_controller.customerPartyNmList.isEmpty) {
//                     await _controller.fetchCustomerParty();
//                   }
//                   return _controller.customerPartyNmList;
//                 },
//                 itemAsString: (item) => item.phoneNo ?? "",
//                 selectedItem: _controller.selectedCustomer.value,
//                 onChanged: (value) {
//                   _controller.selectedCustomer.value = value;
//                   if (value != null) {
//                     _controller.phoneNumberController.text =
//                         value.phoneNo ?? "";
//                     _controller.customerTxtCont.text = value.name ?? "";
//                   }
//                 },
//                 decoratorProps: DropDownDecoratorProps(
//                   decoration: InputDecoration(
//                     hintText: _controller.youRedting.value
//                         ? _controller.phoneNumberController.text
//                         : "Phone Number",
//                     constraints: BoxConstraints(maxHeight: 50.h),
//                     border: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(width: 1.w, color: Colorconst.cGrey),
//                         borderRadius: BorderRadius.circular(5.r)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.w, color: Colors.blue),
//                         borderRadius: BorderRadius.circular(5.r)),
//                   ),
//                 ),
//                 suffixProps: const DropdownSuffixProps(
//                     dropdownButtonProps: DropdownButtonProps(isVisible: false)),
//                 compareFn: (item1, item2) {
//                   return item1.phoneNo?.trim().toLowerCase() ==
//                       item2.phoneNo?.trim().toLowerCase();
//                 },
//                 dropdownBuilder: (context, selectedItem) {
//                   return Text(selectedItem?.phoneNo ?? "",
//                       style: const TextStyle(color: Colors.black));
//                 },
//                 popupProps: PopupProps.menu(
//                   cacheItems: true,
//                   showSearchBox: true,
//                   containerBuilder: (context, popupWidget) => Container(
//                     color: Colors.white,
//                     child: popupWidget,
//                   ),
//                   searchFieldProps: TextFieldProps(
//                     style: const TextStyle(color: Colors.black),
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: "Search",
//                       constraints: BoxConstraints(maxHeight: 50.h),
//                       border: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.w, color: Colorconst.cGrey),
//                           borderRadius: BorderRadius.circular(5.r)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 1.w, color: Colors.blue),
//                           borderRadius: BorderRadius.circular(5.r)),
//                     ),
//                   ),
//                   itemBuilder: (context, obj, isDisabled, isSelected) {
//                     return Container(
//                       color: Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ListTile(
//                                 title: Text(
//                                   obj.phoneNo.toString(),
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 15.sp),
//                                 ),
//                                 trailing: Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 6.h),
//                                   child: Column(
//                                     children: [
//                                       double.parse(obj.balance.toString()) > 0
//                                           ? Icon(Icons.arrow_outward_outlined,
//                                               color: Colors.green, size: 22.sp)
//                                           : Icon(Icons.arrow_downward_outlined,
//                                               color: Colors.red, size: 22.sp),
//                                       Text(obj.balance.toString())
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Icon(Icons.arrow_forward_ios_outlined, size: 18.sp),
//                             SizedBox(width: 10.w)
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   searchDelay: const Duration(milliseconds: 500),
//                 ),
//               );
//             }),
//             SizedBox(height: 20.h),
//             _controller.itemList.isNotEmpty
//                 ? Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colorconst.cBlue,
//                         borderRadius: BorderRadius.circular(5.r)),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 5.h),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 12.w,
//                           ),
//                           CircleAvatar(
//                             radius: 8.r,
//                             backgroundColor: Colors.white,
//                             child: Transform.rotate(
//                                 angle: 4.7,
//                                 child: Icon(
//                                   Icons.arrow_back_ios_new_outlined,
//                                   size: 10.sp,
//                                   color: Colors.black45,
//                                 )),
//                           ),
//                           SizedBox(
//                             width: 7.w,
//                           ),
//                           Text(
//                             "Billed Items",
//                             style: interFontGrey1(
//                                 fontsize: 12.sp, color: Colors.white),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 : const SizedBox(),
//             SizedBox(
//               height: 6.h,
//             ),
//             Column(
//                 children: List.generate(
//               _controller.itemList.length,
//               (index) {
//                 ItemModel obj = _controller.itemList[index];
//                 return InkWell(
//                   onTap: () {
//                     _controller.isEditingItem.value = true;
//                     _controller.updateItemValues(object: obj, index: index);
//                   },
//                   child: TransactionCard(
//                       // discount: obj.discount,
//                       // itemName: obj.itemName,
//                       // itemNum: (index + 1).toString(),
//                       // price: obj.price.toString(),
//                       // quantity: obj.quantity,
//                       // tax: obj.taxAmt,
//                       // total: obj.total,
//                       // discountP: obj.discountP,
//                       // subtotal: obj.subtotalP,
//                       // taxRate: obj.taxRate,
//                       // onDelete: () => _controller.deleteItem(index),
//                       ),
//                 );
//               },
//             )),
//             _controller.itemList.length.toInt() == 0
//                 ? const SizedBox()
//                 : Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Tatal Disc: ${_controller.grandDiscount}",
//                               style: interFontBlack1(
//                                 fontsize: 11.sp,
//                                 color: Colors.black45,
//                               ),
//                             ),
//                             Text(
//                               "Total Tax Amt: ${_controller.grandTax.toStringAsFixed(2)}",
//                               style: interFontBlack1(
//                                   fontsize: 11.sp, color: Colors.black45),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 15.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Tatal Qty: ${_controller.grandQty}",
//                               style: interFontBlack1(
//                                 fontsize: 11.sp,
//                                 color: Colors.black45,
//                               ),
//                             ),
//                             Text(
//                               "Subtotal: ${_controller.grandSubTotal}",
//                               style: interFontBlack1(
//                                   fontsize: 11.sp, color: Colors.black45),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//             SizedBox(
//               height: 20.h,
//             ),
//             Row(
//               children: [
//                 // Expanded(
//                 //   child: AddItemButton(onTap: () {
//                 //     _controller.conversionRate.value = 1.0;
//                 //     _controller.priceForBaseUnit.value = 0.0;
//                 //     _controller.isSecondaryChoosed.value = false;
//                 //     _controller.unitNames.clear();
//                 //     _controller.secondaryUnitName.value = '';
//                 //     _controller.primaryUnitName.value = '';
//                 //     _controller.discountContr.text = "0.00";
//                 //     // _controller.discountAmountContr.text = "0.00";
//                 //     _controller.isEditingItem.value = false;
//                 //     _controller.clearItemController();
//                 //     // Get.to(() => AddItemToSale());
//                 //   }),
//                 // ),
//                 const SizedBox(width: 8), // Spacing between elements
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.qr_code_scanner,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildCustomTextFormField(
//       {required String labelText,
//       required String hintText,
//       required TextInputType keyboardType,
//       final TextEditingController? controller,
//       final Widget? suffixIconWidget,
//       final FocusNode? focusNode,
//       Function(String)? onChange}) {
//     return CustomTextFormField(
//       controller: controller,
//       labelText: labelText,
//       hintText: hintText,
//       keyboardType: keyboardType,
//       onChanged: onChange,
//       suffixIconWidget: suffixIconWidget,
//       focusNode: focusNode,
//     );
//   }
// }

// class DottedLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;

//     double dashWidth = 5, dashSpace = 3, startX = 0;
//     while (startX < size.width) {
//       canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
//       startX += dashWidth + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
