import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/add_godown_controller/add_godown_controller.dart';

class AddGodown extends StatefulWidget {
  const AddGodown({super.key});

  @override
  State<AddGodown> createState() => _AddGodownState();
}

class _AddGodownState extends State<AddGodown> {
  final _formKey = GlobalKey<FormState>();
  final AddGodownController controller = Get.put(AddGodownController());

  @override
  Widget build(BuildContext context) {
    controller.fetchAllGodownsType();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Godown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                final items = controller.allGodownsTypes
                    .map((godown) => godown.value ?? '')
                    .where((name) => name.isNotEmpty)
                    .toSet()
                    .toList();

                return _buildBottomSheetSelector(
                  title: 'Select Godown Type',
                  value: controller.godownType,
                  items: items,
                  onItemSelected: (value) {
                    setState(() {
                      controller.godownType = value;
                    });
                  },
                );
              }),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    // Godown Name
                    TextFormField(
                      controller: controller.godownNameController,
                      decoration: const InputDecoration(
                        labelText: 'Godown Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a godown name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email ID
                    TextFormField(
                      controller: controller.emailIdController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email ID';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'More Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Tax Registration Number
                    TextFormField(
                      controller: controller.taxRegNumController,
                      decoration: const InputDecoration(
                        labelText: 'Tax Registration Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Pincode
                    TextFormField(
                      controller: controller.pinCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Godown Address
                    TextFormField(
                      controller: controller.godownAddressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Godown Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        controller.submitGodownDetails();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetSelector({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onItemSelected,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // List of items
                ...items.map((item) {
                  return ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected(item);
                    },
                  );
                }),
                const Divider(),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? title,
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
