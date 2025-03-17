import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/bank_account_controller/bank_account_controller.dart';
import 'package:newthijar/view/menu/sub_screens/bank_accounts/sub_screen/add_bank_account.dart';
import 'package:newthijar/view/menu/sub_screens/bank_accounts/sub_screen/bank_detail_screen.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class BankAccountsListPage extends StatelessWidget {
  const BankAccountsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      BankAccountsController(),
    );
    controller.getBankList();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Bank Accounts List',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   leading: const Icon(Icons.arrow_back, color: Colors.black),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Bank Accounts List",
            ),
          ),
          Positioned(
            top: 150,
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
              child: Column(
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        return controller.bankList.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.bankList.length,
                                itemBuilder: (context, index) {
                                  final item = controller.bankList[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: InkWell(
                                      onTap: () =>
                                          Get.to(() => BankDetailsScreen(
                                                bankId: item.id.toString(),
                                              )),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  item.accountHolderName,
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '₹ ${item.openingBalance}',
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: Color.fromARGB(
                                                        255, 6, 50, 115),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              item.accountNumber,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 6, 50, 115),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: const Text(
                                                    'PRINTING',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(Icons.share,
                                                    color: Colors.black54),
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 6, 50, 115),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 6, 50, 115)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Get.to(const AddBankAccount());
                        },
                        child: const Text(
                          'Add Bank',
                          style:
                              TextStyle(color: Color.fromARGB(255, 6, 50, 115)),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 6, 50, 115),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          _showTransferOptions(context);
                        },
                        child: const Text(
                          'Deposit / Withdraw',
                          style: TextStyle(color: Colors.white),
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
      backgroundColor: const Color(0xFFE8F1FA),
    );
  }

  void _showTransferOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.account_balance_wallet,
                    color: Colors.blue),
                title: const Text('Bank to Cash Transfer'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.blue),
                title: const Text('Cash to Bank Transfer'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sync_alt, color: Colors.blue),
                title: const Text('Bank to Bank Transfer'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.adjust, color: Colors.blue),
                title: const Text('Adjust Bank Balance'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
