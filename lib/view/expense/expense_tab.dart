// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({super.key});

  @override
  _ExpenseTabState createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // _controller.fetchUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

 
  Widget expenseCategoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(child: Text("Hi")),

          const SizedBox(height: 16),
 
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithText(String text, String trailingText) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(color: Colors.black)),
            Row(children: [
              SizedBox(
                width: 100,
                child: Text(
                  trailingText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Icon(Icons.arrow_drop_down)
            ]),
          ],
        ),
      ),
    );
  }

  Widget expenseItemsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
        
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    floatingActionButtonLocation:
    // log("business card logo:${_controller.businessProfile.value.businessProfile?.logo.toString()}");
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            backgroundColor: const Color.fromARGB(255, 6, 50, 115),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                EneftyIcons.add_outline,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              const Text(
                "Add Expenses",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              page: "Expense",
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
                ),
              ),
              child: Column(
                children: [
                  // Tab Bar inside the body
                  TabBar(
                    labelColor: const Color.fromARGB(255, 6, 50, 115),
                    unselectedLabelColor: Colors.grey,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Categories'),
                      Tab(text: 'Items'),
                    ],
                  ),
                  // Tab Bar View inside the body
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        expenseCategoriesTab(),
                        expenseItemsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
