// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/view/master_tab/party_detail/sub_screens/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class AddParty extends StatefulWidget {
  const AddParty({super.key});

  @override
  _AddPartyState createState() => _AddPartyState();
}

class _AddPartyState extends State<AddParty> {
  String paymentType = "To Receive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(context),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 185,
            child: TopBar(
              page: "Add New Party",
            ),
          ),
          Positioned(
            top: 160,
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
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Party Name"),
                      _buildTextField("Tax Registration No."),
                      _buildTextField("Email Id"),
                      _buildTextField("Contact Number"),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Opening Balance")),
                          SizedBox(width: 8.w),
                          Expanded(child: _buildTextField("As of Date")),
                        ],
                      ),
                      _buildLargeTextField("Billing Address"),
                      _buildLargeTextField("Shipping Address", showIcon: true),
                      Row(
                        children: [
                          _buildRadioButton("To Receive"),
                          SizedBox(width: 16.w),
                          _buildRadioButton("To Pay"),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeTextField(String hint, {bool showIcon = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300), // Light grey border
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 4, // Allows multiple lines
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none, // Removes default border
                ),
              ),
            ),
            if (showIcon)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String title) {
    return Row(
      children: [
        Radio(
          value: title,
          groupValue: paymentType,
          onChanged: (value) {
            setState(() {
              paymentType = value.toString();
            });
          },
        ),
        Text(title),
      ],
    );
  }
}
