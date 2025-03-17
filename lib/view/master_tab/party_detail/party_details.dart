import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newthijar/controller/add_party_controller/add_party_controller.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/model/party_model.dart';
import 'package:newthijar/view/master_tab/party_detail/sub_screens/add_part.dart';
import 'package:newthijar/view/master_tab/party_detail/widgets/widgets.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class PartyDetailsPage extends StatelessWidget {
  PartyDetailsPage({super.key});

  final controller = Get.find<HomeController>();
  final businessController = Get.put(BusinessController());

  @override
  Widget build(BuildContext context) {
    controller.getAllParty();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add New Party",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          var c = Get.put(AddPartyController());
          c.isEditingParty.value = false;
          c.clearPartyController();
          Get.to(
            () => const AddParty(),
          );
        },
        backgroundColor:
            const Color.fromARGB(255, 6, 50, 115), // Dark blue color
        icon: const Icon(
          EneftyIcons.add_outline,
          color: Colors.white, // White icon color
          size: 28,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a transaction',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 202, 201, 201),
                ),
                suffixIcon: const Icon(
                  EneftyIcons.search_normal_2_outline,
                  color: Color.fromARGB(255, 6, 50, 115),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(
                      255,
                      225,
                      224,
                      224,
                    ),
                  ), // Border color when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 6, 50, 115),
                    width: 2,
                  ), // Border color when focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                      icon: EneftyIcons.shopping_bag_outline,
                      label: 'Online Store',
                      isSelected: true),
                  ActionButton(
                      icon: EneftyIcons.box_3_outline, label: 'Stock Summary'),
                  ActionButton(
                      icon: EneftyIcons.setting_2_outline,
                      label: 'Item Settings'),
                  ActionButton(
                      icon: EneftyIcons.more_outline, label: 'Show More'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Color.fromARGB(255, 224, 223, 223),
          ),
          Obx(
            () {
              return isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.allParties.isEmpty
                      ? Center(
                          child: Text(
                            "Empty list",
                            style: interFontBlack(context),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              itemCount: controller.allParties.length,
                              itemBuilder: (context, index) {
                                PartyModel data = controller.allParties[index];
                                return TransactionCard(
                                  title: data.name.toString(),
                                  total: "11500",
                                  balance: '11500.0',
                                  date: DateFormat('dd MMM yyyy')
                                      .format(data.updatedAt!),
                                );
                              },
                            ),
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
