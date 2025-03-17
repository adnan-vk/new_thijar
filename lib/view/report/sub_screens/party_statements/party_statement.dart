import 'package:dropdown_search/dropdown_search.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/controller/party_statement_controller/party_statement_controller.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/view/report/sub_screens/party_statements/widgets/widget.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';

class PartStatementScreen extends StatefulWidget {
  const PartStatementScreen({super.key});

  @override
  State<PartStatementScreen> createState() => _PartStatementScreenState();
}

class _PartStatementScreenState extends State<PartStatementScreen> {
  final PartyStatementController controller =
      Get.put(PartyStatementController());
  DateController dateController = Get.put(DateController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        controller.selectedCustomer.value = null;
        await controller.fetchCustomerParty();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 210,
            child: TopBar(
              page: "Party Statement",
            ),
          ),
          Positioned(
            top: 160, // Adjust this to position the curved container correctly
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
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// **Modularized Date Filter Widget**
                    DateFilterWidget(
                      onCalendaerTap: () async {
                        DateFilterModel obj = await dateController
                            .selectDateRange(context, onSave: () {});
                        controller.getPartyStatement(date: obj);
                      },
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text("Filters Applied:",
                            style: TextStyle(fontSize: 14.sp)),
                        const Spacer(),
                        buildGradientButton(),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      return DropdownSearch<CustomerPartyModelList>(
                        items: (filter, loadProps) async {
                          if (controller.customerPartyNmList.isEmpty) {
                            await controller.fetchCustomerParty();
                          }
                          return controller.customerPartyNmList;
                        },
                        itemAsString: (item) => item.name ?? "",
                        selectedItem: controller.selectedCustomer.value,
                        onChanged: (value) {
                          controller.selectedCustomer.value = value;
                          if (value != null) {
                            controller.getPartyStatement(
                                date: DateFilterModel(
                                    startDate: dateController.startDateIs.value,
                                    endDate: dateController.endDateIs.value));
                          }
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: "Select Party",
                            constraints: BoxConstraints(maxHeight: 50.h),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colorconst
                                        .cGrey), // Scalable border width
                                borderRadius: BorderRadius.circular(5.r)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.w, color: Colors.blue),
                                borderRadius: BorderRadius.circular(5.r)),
                          ),
                        ),
                        suffixProps: const DropdownSuffixProps(
                            dropdownButtonProps:
                                DropdownButtonProps(isVisible: false)),
                        compareFn: (item1, item2) {
                          return item1.name?.trim().toLowerCase() ==
                              item2.name?.trim().toLowerCase();
                        },
                        dropdownBuilder: (context, selectedItem) {
                          return Text(selectedItem?.name ?? "",
                              style: const TextStyle(color: Colors.black));
                        },
                        popupProps: PopupProps.menu(
                          cacheItems: true,
                          showSearchBox: true,
                          containerBuilder: (context, popupWidget) => Container(
                            color: Colors.white,
                            child: popupWidget,
                          ),
                          searchFieldProps: TextFieldProps(
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: "Search",
                              constraints: BoxConstraints(maxHeight: 50.h),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w,
                                      color: Colorconst
                                          .cGrey), // Scalable border width
                                  borderRadius: BorderRadius.circular(5.r)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1.w, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5.r)),
                            ),
                          ),
                          itemBuilder: (context, obj, isDisabled, isSelected) {
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  title: Text(
                                    obj.name.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.sp),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            );
                          },
                          searchDelay: const Duration(milliseconds: 500),
                        ),
                      );
                    }),
                    SizedBox(height: 12.h),

                    /// **Summary Cards**
                    Row(
                      children: [
                        buildSummaryCard("Total Amount", "₹ 54879.5"),
                        SizedBox(width: 8.w),
                        buildSummaryCard("Closing Balance", "₹ 45121.5"),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    /// **Transaction Table**
                    buildTransactionTable(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
