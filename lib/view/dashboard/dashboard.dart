import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/dash_board_controller/dashboard_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/sale_inv_report_controller/sale_inv_report_controller.dart';
import 'package:newthijar/urls/base_url.dart';
import 'package:newthijar/view/business_profile/business_profile.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/db/db.dart';

final controller = Get.put(DashBoardController());
final salesController = Get.put(SaleInvoiceOrReportController());

class DashBoard extends StatelessWidget {
  final Repository repository = Repository();
  DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController =
        Get.put(HomeController(repository: repository));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  homeController.busiNessProfileModel.value.businessProfile ==
                          null
                      ? "Wait..."
                      : homeController.busiNessProfileModel.value
                          .businessProfile!.businessName
                          .toString(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.language, size: 28),
                    const SizedBox(width: 16),
                    const Icon(EneftyIcons.notification_outline, size: 28),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const BusinessProfileScreen());
                      },
                      child: Obx(
                        () => CircleAvatar(
                            backgroundImage: businessController
                                    .apiLogo.value.isNotEmpty
                                ? NetworkImage(ApiBaseUrl.fileBaseUrl +
                                    businessController.apiLogo.value)
                                : const AssetImage("assets/images/logo.jpg")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 20),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'search for a transaction',
            //     hintStyle: const TextStyle(color: Colors.grey),
            //     suffixIcon: const Icon(
            //       Icons.search,
            //       color: Color.fromARGB(255, 6, 50, 115),
            //     ),
            //     filled: true,
            //     fillColor: Colors.grey.shade100,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(40),
            //       borderSide: BorderSide.none,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  DashboardCard(
                    amount:
                        "${controller.dashBoardModel.value.data?.totalCashInHand}",
                    label: 'Cash In Hand',
                    icon: EneftyIcons.money_3_bold,
                    gradientColors: const [
                      Color.fromARGB(255, 6, 50, 115),
                      Color.fromARGB(255, 30, 111, 191)
                    ],
                    color: Colors.white,
                  ),
                  DashboardCard(
                    amount: controller
                            .dashBoardModel.value.data?.inventory?.stockValue
                            .toString() ??
                        "0",
                    label: 'Closing Stock',
                    icon: EneftyIcons.graph_outline,
                    gradientColors: const [
                      Color(0xFF96B8FF),
                      Color(0xFF96B8FF)
                    ],
                    color: const Color.fromARGB(255, 6, 50, 115),
                  ),
                  DashboardCard(
                    amount:
                        controller.dashBoardModel.value.data?.saleBalanceDue ??
                            "0",
                    label: "You'll Get",
                    icon: EneftyIcons.money_outline,
                    gradientColors: const [
                      Color(0xFF96B8FF),
                      Color(0xFF96B8FF)
                    ],
                    color: const Color.fromARGB(255, 6, 50, 115),
                  ),
                  DashboardCard(
                    amount: controller
                            .dashBoardModel.value.data?.purchaseBalanceDue ??
                        "0",
                    label: "You'll Give",
                    icon: EneftyIcons.money_change_outline,
                    gradientColors: const [
                      Color.fromARGB(255, 6, 50, 115),
                      Color.fromARGB(255, 30, 111, 191)
                    ],
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const OverviewCard(),
          ],
        ),
      ),
    );
  }
}

class OverviewCard extends StatefulWidget {
  const OverviewCard({super.key});

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  int selectedIndex = 1; // Default selection is "Weekly"

  final List<String> options = ['Today', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  top: 5,
                ), // Padding around the toggle buttons
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Shrink to fit content
                  children: List.generate(options.length, (index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ), // Space between buttons
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              16), // Slightly more rounded
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 7,
                            top: 7,
                          ),
                          child: Text(
                            options[index],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              'Total Sale:  ${controller.dashBoardModel.value.data != null ? controller.dashBoardModel.value.data!.saleBalanceDue : ""}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 6, 50, 115),
              ),
            ),
          ),
          const Text(
            '100% More Growth This Month',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.grey.shade200,
            child: const Center(
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String amount;
  final String label;
  final List<Color> gradientColors;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.amount,
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 26,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
