// ignore_for_file: unused_element

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';

class DateFilterWidget extends StatelessWidget {
  final Function()? onCalendaerTap;
  DateFilterWidget({super.key, this.onCalendaerTap});
  final DateController controller = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: "This Month",
            icon: const Icon(EneftyIcons.arrow_down_outline,
                color: Color.fromARGB(255, 6, 50, 115)),
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 6, 50, 115),
            ),
            onChanged: (String? newValue) {
              // Handle dropdown selection
            },
            items: <String>["This Month", "Last Month", "Custom"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          height: 30.h,
          width: 1.w,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
        ),
        GestureDetector(
          onTap: onCalendaerTap,
          child: Row(
            children: [
              Text("Date:",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black)),
              SizedBox(width: 3.w),
              Obx(
                () => Text("${controller.startDate} To ${controller.endDate}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
