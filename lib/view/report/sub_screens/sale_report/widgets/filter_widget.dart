import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDialogSales extends StatefulWidget {
  final String initialSelectedUser;
  final String initialSelectedTxnType;
  final String initialSelectedParty;

  const FilterDialogSales({
    super.key,
    required this.initialSelectedUser,
    required this.initialSelectedTxnType,
    required this.initialSelectedParty,
  });

  @override
  State<FilterDialogSales> createState() => _FilterDialogSalesState();
}

class _FilterDialogSalesState extends State<FilterDialogSales> {
  late String selectedFilter;
  late String selectedUser;
  late String selectedTxnType;
  late String selectedParty;

  final Map<String, List<String>> filters = {
    "By User": [
      "All Users", /* "Admin" */
    ],
    "By Txns Types": [
      "Sales and Cr. Note",
      "Sale",
      "Credit Note",
      "Sale [Cancelled]"
    ],
    "By Party": [
      "All Party", /* "Party A", "Party B", "Party C" */
    ],
  };

  @override
  void initState() {
    super.initState();
    selectedFilter = "By User";
    selectedUser = widget.initialSelectedUser;
    selectedTxnType = widget.initialSelectedTxnType;
    selectedParty = widget.initialSelectedParty;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 50, 115),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 6, 50, 115),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  // Left side filter list
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 6, 50, 115),
                            Color.fromARGB(255, 30, 111, 191)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ListView(
                        children: filters.keys
                            .map(
                              (filter) => ListTile(
                                title: Text(
                                  filter,
                                  style: TextStyle(
                                    fontWeight: selectedFilter == filter
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  // Right side options
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildOptions(selectedFilter),
                    ),
                  ),
                ],
              ),
            ),
            // Reset and Apply buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildBottomButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(String filter) {
    final options = filters[filter]!;

    return ListView(
      shrinkWrap: true,
      children: options
          .map(
            (option) => RadioListTile<String>(
              value: option,
              groupValue: filter == "By User"
                  ? selectedUser
                  : filter == "By Txns Types"
                      ? selectedTxnType
                      : selectedParty,
              onChanged: (value) {
                setState(() {
                  if (filter == "By User") {
                    selectedUser = value!;
                  } else if (filter == "By Txns Types") {
                    selectedTxnType = value!;
                  } else if (filter == "By Party") {
                    selectedParty = value!;
                  }
                });
              },
              title: Text(option),
              activeColor: const Color.fromARGB(255, 6, 50, 115),
              dense: true,
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              // Reset all selected filters
              selectedUser = "All Users";
              selectedTxnType = "Sales and Cr. Note";
              selectedParty = "All Party";
            });
            log(selectedUser);
            log(selectedFilter);
            log(selectedParty);
          },
          child: const Text(
            "Reset",
            style: TextStyle(color: Color.fromARGB(255, 6, 50, 115)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 50, 115),
                Color.fromARGB(255, 30, 111, 191)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10), // Keeps rounded edges
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Must be transparent to show gradient
              shadowColor:
                  Colors.transparent, // Avoids shadow blocking the gradient
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Keeps shape consistency
              ),
            ),
            onPressed: () {
              Navigator.pop(context, {
                "selectedUser": selectedUser,
                "selectedTxnType": selectedTxnType,
                "selectedParty": selectedParty,
              });
            },
            child: const Text(
              "Apply",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
