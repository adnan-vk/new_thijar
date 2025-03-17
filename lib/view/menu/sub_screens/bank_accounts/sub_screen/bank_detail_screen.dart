import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/add_edit_bank_controller.dart/add_edit_bank_controller.dart';
import 'package:newthijar/controller/bank_account_controller/bank_account_controller.dart';

class BankDetailsScreen extends StatelessWidget {
  final String bankId;
  BankDetailsScreen({required this.bankId, super.key});

  final controller = Get.put(
    BankAccountsController(),
  );
  @override
  Widget build(BuildContext context) {
    controller.getBankDetail(bankId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              var controller = Get.put(AddEditBankAccountController());
              controller.putBankDetail();
              // Get.to(() => EditBank(bankId: bankId));
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        final bankDetail = controller.bankDetail.value;
        if (bankDetail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${bankDetail.bankName}, ${bankDetail.branchName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Balance",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹ ${bankDetail.openingBalance}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Printing action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text("PRINTING"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transactions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Amount",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("Opening balance"),
                subtitle: Text(
                  "${bankDetail.asOfDate}".split(' ')[0],
                ),
                trailing: Text(
                  "₹ ${bankDetail.openingBalance}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Deposit/Withdraw action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Deposit / Withdraw",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
