import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/custom_text_field/custom_text_field.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class AddBankScreen extends StatelessWidget {
  AddBankScreen({super.key});

  //  final _controller = Get.put(BankDataController());
  final _controller = Get.find<TransactionDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Bank Account',
          style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 22.sp,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 48.h,
                    child: customTextFormFieldNew(
                        labelText: "Bank Name/ Account Display Name",
                        controller: _controller.acountNameContr)),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 48.h,
                          child: customTextFormFieldNew(
                              keyboardType: TextInputType.number,
                              controller: _controller.openingBalanceContr,
                              inputFormate: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              labelText: "Opening Balance")),
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        var value = await ContextProvider().selectDate(context);

                        if (value != null) {
                          _controller.asOnContr.text = value.toString();
                        }
                      },
                      child: SizedBox(
                          height: 48.h,
                          child: customTextFormFieldNew(
                              isEditable: false,
                              controller: _controller.asOnContr,
                              labelText: "As On",
                              suffixIconWidget: Icon(
                                Icons.calendar_today,
                                size: 24.sp,
                              ))),
                    )),
                  ],
                ),
                SizedBox(height: 12.h),
                const Divider(),
                ListTile(
                  title: Text(
                    "Print bank details on invoices",
                    style:
                        GoogleFonts.inter(fontSize: 16.sp, color: Colors.black),
                  ),
                  trailing: Switch(
                    value: _controller.printBankDetails.value,
                    onChanged: (bool value) {
                      _controller.printBankDetails.value = value;
                    },
                  ),
                  leading: Icon(
                    Icons.info_outline,
                    size: 25.sp,
                  ),
                ),
                ListTile(
                  title: Text("Print UPI QR Code on invoices",
                      style: GoogleFonts.inter(
                          fontSize: 16.sp, color: Colors.black)),
                  trailing: Switch(
                    value: _controller.printUPIQR.value,
                    onChanged: (bool value) {
                      _controller.printUPIQR.value = value;
                    },
                  ),
                  leading: Icon(
                    Icons.info_outline,
                    size: 25.sp,
                  ),
                ),
                if (_controller.printBankDetails.value) ...[
                  SizedBox(height: 12.h),
                  SizedBox(
                      height: 48.h,
                      child: customTextFormFieldNew(
                          labelText: "Account Holder Name",
                          controller: _controller.accountHolderCont)),
                  SizedBox(height: 12.h),
                  SizedBox(
                      height: 48.h,
                      child: customTextFormFieldNew(
                          labelText: "Account Number",
                          keyboardType: TextInputType.number,
                          controller: _controller.accountNumCont,
                          inputFormate: [
                            FilteringTextInputFormatter.digitsOnly
                          ])),
                  SizedBox(height: 12.h),
                  SizedBox(
                      height: 48.h,
                      child: customTextFormFieldNew(
                          labelText: "IFSC Code",
                          controller: _controller.ifscCodeCont)),
                  SizedBox(height: 12.h),
                  SizedBox(
                      height: 48.h,
                      child: customTextFormFieldNew(
                          labelText: "Branch Name",
                          controller: _controller.branchNameCont)),
                ],
                if (_controller.printUPIQR.value) ...[
                  SizedBox(height: 12.h),
                  SizedBox(
                      height: 48.h,
                      child: customTextFormFieldNew(
                          labelText: "UPI ID for QR Code",
                          controller: _controller.upiIdCont)),
                ],
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return SizedBox(
            width: double.infinity,
            child: isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Handle save button press
                      _controller.checkIsFormValidate()
                          ? _controller.addBank()
                          : null;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
