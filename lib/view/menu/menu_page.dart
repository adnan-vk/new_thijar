import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:newthijar/view/menu/sub_screens/add_user/add_user_screen.dart';
import 'package:newthijar/view/menu/sub_screens/bank_accounts/bank_accounts.dart';
import 'package:newthijar/view/menu/sub_screens/business_card/business_card.dart';
import 'package:newthijar/view/menu/sub_screens/cash_in_hand/cahs_in_hand.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/manage_companies.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/manage_godowns.dart';
import 'package:newthijar/view/menu/widgets/widgets.dart';
import 'package:newthijar/view/menu/sub_screens/settings/settings.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class MenuPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {"title": "E-Way Bill", "icon": Iconsax.document_text},
    {"title": "E-Invoice", "icon": Iconsax.receipt},
    {"title": "Insights", "icon": Iconsax.chart},
    {"title": "Payment Timeline", "icon": Iconsax.clock},
    {"title": "Business Card", "icon": Iconsax.profile_2user},
    {"title": "Greetings", "icon": Icons.handshake},
    {"title": "Invoice Templates", "icon": Iconsax.document},
    {"title": "Document Settings", "icon": Iconsax.setting},
    {"title": "My Online Store", "icon": Iconsax.shop},
    {"title": "Bank Accounts", "icon": Iconsax.bank},
    {"title": "Cash in Hand", "icon": Iconsax.wallet},
    {"title": "Cheques", "icon": Iconsax.money_recive},
    {"title": "Loan Account", "icon": Iconsax.money_send},
    {"title": "Add User", "icon": Iconsax.user_add},
    {"title": "Manage Companies", "icon": Iconsax.buildings},
    {"title": "Backup / Restore", "icon": Iconsax.cloud_change},
    {"title": "Utilities", "icon": Iconsax.setting_21},
    {"title": "Manage Godown", "icon": Iconsax.box},
    {"title": "Thijar Premium", "icon": Iconsax.crown},
    {"title": "Get Desktop Billing Software", "icon": Iconsax.monitor},
    {"title": "Other Products", "icon": Iconsax.box},
    {"title": "Greetings & Offers", "icon": Iconsax.gift},
    {"title": "Settings", "icon": Iconsax.setting_2},
    {"title": "Refer & Earn", "icon": Icons.card_giftcard_outlined},
    {"title": "Help & Support", "icon": Iconsax.message_question},
    {"title": "Rate This App", "icon": Iconsax.star},
    {"title": "Log Out", "icon": Iconsax.logout}
  ];

  MenuPage({super.key});

  void handleItemClick(BuildContext context, String title) {
    switch (title) {
      // case "E-Way Bill":
      //   // Navigate to E-Way Bill Page
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => EWayBillPage()));
      //   break;
      // case "E-Invoice":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => EInvoicePage()));
      //   break;
      // case "Payment Timeline":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentTimelinePage()));
      //   break;
      // case "Insights":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => InsightsPage()));
      //   break;
      case "Business Card":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BusinessCardScreen()));
        break;
      // case "Greetings":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => GreetingsPage()));
      //   break;
      // case "Invoice Templates":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceTemplatesPage()));
      //   break;
      // case "Document Settings":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentSettingsPage()));
      //   break;
      // case "My Online Store":
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineStorePage()));
      case "Cash in Hand":
        Get.to(() => CashInHand());
        break;
      case "Manage Godown":
        Get.to(() => ManageGodownsScreen());
        break;
      case "Bank Accounts":
        Get.to(() => const BankAccountsListPage());
        break;
      case "Add User":
        Get.to(() => AddUserScreen());
        break;
      case "Manage Companies":
        Get.to(() => const ManageCompanies());
        break;
      case "Settings":
        Get.to(() => const SettingScreen());
        break;
      case "Log Out":
        logOutBottomSheet();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feature not implemented")));
    }
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
            height: 300,
            child: TopBar(
              page: "Menu",
            ),
          ),
          Positioned(
            top: 260,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Quick Access",
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              (constraints.maxWidth ~/ 120).clamp(3, 5);

                          return GridView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: items.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              return QuickAccessItem(
                                title: items[index]['title'],
                                icon: items[index]['icon'],
                                onTap: () => handleItemClick(
                                    context, items[index]['title']),
                              );
                            },
                          );
                        },
                      ),
                    ),
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

class QuickAccessItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAccessItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue.shade900),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
