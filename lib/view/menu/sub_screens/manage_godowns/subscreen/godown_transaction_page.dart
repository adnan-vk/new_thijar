import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/view/menu/sub_screens/manage_godowns/subscreen/stock_transfer.dart';

class GodownTransactionsPage extends StatelessWidget {
  const GodownTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Godown Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.table_chart, color: Colors.green),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Expanded(
                //   child: DropdownButtonFormField<String>(
                //     value: 'This Month',
                //     decoration: InputDecoration(
                //       contentPadding: const EdgeInsets.symmetric(
                //           horizontal: 16, vertical: 8),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     items: ['This Month', 'Last Month', 'Custom']
                //         .map((e) => DropdownMenuItem<String>(
                //               value: e,
                //               child: Text(e),
                //             ))
                //         .toList(),
                //     onChanged: (value) {},
                //   ),
                // ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: TextField(
                //           readOnly: true,
                //           decoration: InputDecoration(
                //             prefixIcon: const Icon(Icons.calendar_today),
                //             hintText: '01/01/2025',
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       const Text('TO',
                //           style: TextStyle(fontWeight: FontWeight.bold)),
                //       const SizedBox(width: 8),
                //       Expanded(
                //         child: TextField(
                //           readOnly: true,
                //           decoration: InputDecoration(
                //             prefixIcon: const Icon(Icons.calendar_today),
                //             hintText: '31/01/2025',
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       prefixIcon: const Icon(Icons.search),
          //       hintText: 'Search',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Main Godown\n(Main Godown)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                            SizedBox(width: 8),
                            Text(
                              'gg',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Items',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('#1'),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('25.0'),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('16 Jan, 25'),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share,
                                      color: Colors.blue),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(StockTransferPage());
        },
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Transfer Stock'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
