import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateController extends GetxController {
  // Observable for dropdown value
  var dropdownValue = 'This Month'.obs;
  RxString startDateIs = "2024-01-01".obs;
  RxString endDateIs = "2030-01-01".obs;

  // Observable for date range
  Rx<DateTimeRange> selectedDateRange = Rx<DateTimeRange>(DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(
      DateTime.now().year, DateTime.now().month + 1,
      0, // Last day of the current month
    ),
  ));

  // Method to update the dropdown value
  void updateDropdownValue(String newValue) {
    dropdownValue.value = newValue;
  }

  // Method to handle date range selection
  Future<DateFilterModel> selectDateRange(BuildContext context,
      {required Function() onSave}) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: selectedDateRange.value,
      // Customizing the appearance of the date range picker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Customize the primary color
            hintColor: Colors.blue, // Customize the accent color
            textTheme: const TextTheme(
              bodyMedium:
                  TextStyle(color: Colors.black), // Set text color to black
            ),
            colorScheme: const ColorScheme.light(
                primary: Colors.blue), // Set primary color for the calendar
            dialogBackgroundColor: Colors.white, // Set background color
          ),
          child: child ?? const SizedBox.shrink(), // Handle null child
        );
      },
    );

    if (picked != null) {
      selectedDateRange.value = picked;

      startDateIs.value = picked.start.toString().split(' ')[0].toString();
      endDateIs.value = picked.end.toString().split(' ')[0].toString();
      log("Selected Date Range ==${startDateIs.value},${endDateIs.value}");
      onSave();

      return DateFilterModel(
          startDate: startDateIs.value, endDate: endDateIs.value);
    } else {
      return DateFilterModel(
          startDate: startDateIs.value, endDate: endDateIs.value);
    }
  }

  // Getter for formatted start date
  String get startDate => DateFormat('yyyy-MM-dd')
      .format(selectedDateRange.value.start); // Default start date

  // Getter for formatted end date
  String get endDate => DateFormat('yyyy-MM-dd')
      .format(selectedDateRange.value.end); // Default end date

  // @override
  // void onInit() {
  //   super.onInit();
  //   String? date = ContextProvider().getCurrentDate();
  //   log("Date Now ==$date");
  //   endDateIs.value = date;
  // }
}

class DateFilterModel {
  String startDate;
  String endDate;

  DateFilterModel({required this.startDate, required this.endDate});
}
