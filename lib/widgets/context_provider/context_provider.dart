import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/model/bank_model_list.dart';
// import 'package:vyapar_clone/core/common/widget/custom_text_field.dart';

// import '../../presentation/home_screen/pdf/pdf_screen.dart';
// import '../../presentation/home_screen/sub_screens/models/bank_model_list.dart';
// import '../constatnts/colors.dart';

class ContextProvider {
  Future<String?> _chooseDate(context) async {
    DateTime? selectedDate;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      printInfo(info: "selected data==${pickedDate.toLocal()}");
      //  DateFormat formatter = DateFormat('yyyy-MM-yy');
      //  log("Foramted date---- ===${formatter.format(pickedDate.toLocal())}");
      DateTime parsedDate = DateTime.parse(pickedDate.toLocal().toString());
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      // selectedDate = pickedDate;
      // return "${pickedDate.toLocal()}".split(' ')[0];
      return formattedDate;
    } else {
      return null;
    }
  }

  Future<String?> selectDate(context) async {
    String? date = await _chooseDate(context);
    printInfo(info: "Date ==$date");
    return date;
  }

  String _dateTimeNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  String getCurrentDate() {
    return _dateTimeNow();
  }

  Future<FileDetails?> _selectFile(allowedExtensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['pdf'],
      );
      if (result != null) {
        const int tenMB = 10 * 1024 * 1024;

        if (result.files[0].size <= tenMB) {
          printInfo(info: result.paths.toString());
          printInfo(info: result.files[0].xFile.name.toString());
          printInfo(info: result.files[0].size.toString());

          FileDetails fileDetails = FileDetails(
              fileName: result.files[0].xFile.name.toString(),
              filePath: result.files.single.path.toString(),
              fileSize: result.files[0].size.toString());

          return fileDetails;
        } else {
          Get.snackbar("File size is too large.", "Max file size is 10 mb",
              backgroundColor: Colors.amber);
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar(e.toString(), "", backgroundColor: Colors.red);
      printInfo(info: "Error====$e");
      return null;
    }
  }

  Future<FileDetails?> selectFile({List<String>? allowedExtensions}) async {
    return await _selectFile(allowedExtensions);
  }

  static String filteredDateFormate({String? date}) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(date ?? "2024-10-17"));
  }

//convert number into words

  String _numberToWords(int number) {
    if (number == 0) return "zero";

    final units = [
      "",
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ];
    final teens = [
      "ten",
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen"
    ];
    final tens = [
      "",
      "",
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety"
    ];
    final thousands = ["", "thousand", "million", "billion"];

    String convertChunk(int number) {
      String chunk = "";

      if (number >= 100) {
        chunk += "${units[number ~/ 100]} hundred ";
        number %= 100;
      }

      if (number >= 10 && number <= 19) {
        chunk += "${teens[number - 10]} ";
      } else if (number >= 20) {
        chunk += "${tens[number ~/ 10]} ";
        number %= 10;
      }

      if (number >= 1 && number <= 9) {
        chunk += "${units[number]} ";
      }

      return chunk.trim();
    }

    String result = "";
    int chunkCount = 0;

    while (number > 0) {
      final chunk = number % 1000;
      if (chunk > 0) {
        result =
            "${convertChunk(chunk)} ${thousands[chunkCount]} $result".trim();
      }
      number ~/= 1000;
      chunkCount++;
    }

    return result.trim();
  }

  String amountToWords(String amount) {
    try {
      final number = double.parse(amount);
      final wholePart = number.floor();
      final fractionalPart = ((number - wholePart) * 100).round();

      String result = "${_numberToWords(wholePart)} rupees";

      if (fractionalPart > 0) {
        result += " and ${_numberToWords(fractionalPart)} paise";
      }

      return result;
    } catch (e) {
      return "Invalid amount";
    }
  }
}

showDialogGlobal(
    {List<String>? itemList, required Function(String) onSelectItem}) {
  List<String> tempItem = [
    "10120",
    "10121",
    "10122",
    "10123",
  ];
  Get.dialog(Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: List.generate(
                      itemList == null
                          ? tempItem.length
                          : itemList.length.toInt(), (index) {
                    return InkWell(
                      onTap: () {
                        if (itemList == null) {
                          onSelectItem(tempItem[index]);
                        } else {
                          onSelectItem(itemList[index]);
                        }
                        Get.back();
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  itemList == null
                                      ? tempItem[index]
                                      : itemList[index],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.sp),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}

showInvoiceInputTypeDialog({required Function(String) onSelectItem}) {
  Get.dialog(Material(
    color: Colors.transparent,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      onSelectItem(value);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: "Enter",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 6, 50, 115),
                                Color.fromARGB(255, 30, 111, 191)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              onSelectItem("Fetch");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: const Text(
                              "Automatic",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 6, 50, 115),
                                Color.fromARGB(255, 30, 111, 191)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: const Text(
                              "Okay",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}

// showInvoicePdfDialog({required String filePath}) {
//   Get.dialog(Material(
//     color: Colors.transparent,
//     child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
//           child: PdfViewerScreen(
//             filePath: filePath,
//           )),
//     ),
//   ));
// }

showPaymentTypeBottom(
    {
    //   Function()? onClickCash,
    // Function()? onClickCheque,
    required List<BankModelList> bankList,
    Function(BankModelList)? onSelectItem,
    required Function(String) payableMethod,
    Function()? onClickAddBank,
    Function()? onClickClose}) {
  Get.bottomSheet(SizedBox(
    width: double.infinity,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13.r),
                    topRight: Radius.circular(13.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Type",
                        style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: onClickClose,
                        child: Icon(
                          Icons.close_outlined,
                          size: 23.sp,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    color: Colorconst.cSecondaryGrey,
                    height: 1.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      onSelectItem!(BankModelList(accountHolderName: "Cash"));
                      payableMethod("Cash");
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Cash",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    color: Colorconst.cSecondaryGrey,
                    height: 1.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      onSelectItem!(BankModelList(accountHolderName: "Cheque"));
                      payableMethod("Cheque");
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Cheque",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Column(
                    children: List.generate(
                      bankList.length,
                      (index) {
                        BankModelList obj = bankList[index];
                        return InkWell(
                          onTap: () {
                            onSelectItem!(obj);
                            payableMethod("Bank");
                            Get.back();
                          },
                          child: Column(
                            children: [
                              Divider(
                                color: Colorconst.cSecondaryGrey,
                                height: 1.w,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            obj.accountHolderName.toString(),
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    color: Colorconst.cSecondaryGrey,
                    height: 1.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: onClickAddBank,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add,
                                size: 23.sp,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Text(
                                "Add Bank A/c",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}

class FileDetails {
  String? fileName;
  String? filePath;
  String? fileSize;
  FileDetails({this.fileName, this.filePath, this.fileSize});
}
