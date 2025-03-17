import 'package:flutter/material.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class TrialBalanceScreen extends StatelessWidget {
  const TrialBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              page: "Trial Balance",
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
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text('Account Head',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Debit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Credit',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Assets Section
                      _buildSectionHeader("Assets"),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: assets.length + 1, // +1 for total row
                        itemBuilder: (context, index) {
                          if (index < assets.length) {
                            return _buildTableRow(
                              assets[index]['account']!,
                              assets[index]['debit']!,
                              assets[index]['credit']!,
                            );
                          } else {
                            return _buildTableRow(
                              "Total Assets",
                              _calculateTotal(assets, 'debit'),
                              _calculateTotal(assets, 'credit'),
                              isBold: true,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Liabilities Section
                      _buildSectionHeader("Liabilities"),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: liabilities.length + 1, // +1 for total row
                        itemBuilder: (context, index) {
                          if (index < liabilities.length) {
                            return _buildTableRow(
                              liabilities[index]['account']!,
                              liabilities[index]['debit']!,
                              liabilities[index]['credit']!,
                            );
                          } else {
                            return _buildTableRow(
                              "Total Liabilities",
                              _calculateTotal(liabilities, 'debit'),
                              _calculateTotal(liabilities, 'credit'),
                              isBold: true,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement Export functionality
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableRow(String account, String debit, String credit,
      {bool isBold = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(account,
                      style: TextStyle(
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal))),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    debit,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    credit,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // Function to calculate total debit and credit
  String _calculateTotal(List<Map<String, String>> items, String key) {
    double total = 0.0;
    for (var item in items) {
      total += double.tryParse(item[key]!) ?? 0.0;
    }
    return total.toStringAsFixed(2);
  }
}

// Sample Data
final List<Map<String, String>> assets = [
  {"account": "Cash", "debit": "1000.00", "credit": "0.00"},
  {"account": "Accounts Receivable", "debit": "1500.00", "credit": "0.00"},
  {"account": "Inventory", "debit": "800.00", "credit": "0.00"},
  {"account": "Prepaid Expenses", "debit": "300.00", "credit": "0.00"},
  {
    "account": "Property, Plant & Equipment",
    "debit": "5000.00",
    "credit": "0.00"
  },
  {"account": "Accumulated Depreciation", "debit": "0.00", "credit": "2000.00"},
];

final List<Map<String, String>> liabilities = [
  {"account": "Accounts Payable", "debit": "0.00", "credit": "1200.00"},
  {"account": "Notes Payable", "debit": "0.00", "credit": "2500.00"},
  {"account": "Salaries Payable", "debit": "0.00", "credit": "1800.00"},
];
