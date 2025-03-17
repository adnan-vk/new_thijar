import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDialog extends StatefulWidget {
  final String initialTxnType;
  final String initialParty;

  const FilterDialog({
    super.key,
    required this.initialTxnType,
    required this.initialParty,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String selectedFilter;
  late String selectedTxnType;
  late String selectedParty;

  final Map<String, List<String>> filters = {
    "By Txns Types": [
      "Purchase and Dr. Note",
      "Purchase",
      "Debit Note",
    ],
    "By Party": ["All Parties", "Party A", "Party B", "Party C"],
  };

  @override
  void initState() {
    super.initState();
    selectedFilter = "By Txns Types";
    selectedTxnType = widget.initialTxnType;
    selectedParty = widget.initialParty;
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
      children: options.map(
        (option) {
          return RadioListTile<String>(
            value: option,
            groupValue:
                filter == "By Txns Types" ? selectedTxnType : selectedParty,
            onChanged: (value) {
              setState(() {
                if (filter == "By Txns Types") {
                  selectedTxnType = value!;
                } else if (filter == "By Party") {
                  selectedParty = value!;
                }
              });
            },
            title: Text(option),
            dense: true,
          );
        },
      ).toList(),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              // Reset logic for both selections
              selectedTxnType = "Purchase and Dr. Note";
              selectedParty = "All Parties";
              log("Filters reset");
            });
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
