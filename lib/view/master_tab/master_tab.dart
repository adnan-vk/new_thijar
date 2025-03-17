import 'package:flutter/material.dart';
import 'package:newthijar/view/master_tab/items_screen/item_screen.dart';
import 'package:newthijar/view/master_tab/party_detail/party_details.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class MasterTab extends StatelessWidget {
  MasterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 145,
              child: TopBar(
                page: "Items",
              ),
            ),
            Positioned(
              top:
                  120, // Adjust this to position the curved container correctly
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double tabWidth = (constraints.maxWidth / 2) -
                              10; // Dynamic tab width

                          return TabBar(
                            dividerHeight: 0,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.blue.shade900,
                            indicator: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.transparent,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            unselectedLabelStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            tabs: [
                              Container(
                                width: tabWidth,
                                height: 40,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue.shade900),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: const Text('Items'),
                              ),
                              Container(
                                width: tabWidth,
                                height: 40,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue.shade900),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: const Text('Party Details'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ItemScreen(),
                          PartyDetailsPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
