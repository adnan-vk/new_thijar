import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/model/company_model.dart';
import 'package:newthijar/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/manage_companies.dart';
import 'package:restart_app/restart_app.dart';

class CompanyCard extends StatefulWidget {
  final CompanyModel company;

  const CompanyCard({Key? key, required this.company}) : super(key: key);

  @override
  _CompanyCardState createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: const Color.fromARGB(255, 6, 50, 115))),
                child: Icon(
                  EneftyIcons.building_outline,
                  size: 20.sp,
                  color: const Color.fromARGB(255, 6, 50, 115),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.company.companyName ?? "Company Name",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 6, 50, 115),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.company.phoneNo ?? "N/A",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.company.isSelected == true
                        ? Icons.check_circle
                        : Icons.sync_problem,
                    color: widget.company.isSelected == true
                        ? Colors.green
                        : Colors.red,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    widget.company.isSelected == true ? 'Synced' : 'Not Synced',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.company.isSelected == true
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await addCompanyController
                      .syncOrUnsyncCompany(widget.company.id.toString());
                  Restart.restartApp();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  backgroundColor: widget.company.isSelected == true
                      ? Colors.redAccent
                      : const Color.fromARGB(255, 6, 50, 115),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.company.isSelected == true
                          ? Icons.close
                          : Icons.sync,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.company.isSelected == true ? 'UnSync' : 'Sync',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
