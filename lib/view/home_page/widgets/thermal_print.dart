// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/pdf-controller/pdf_controller.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class ThermalPrint extends StatefulWidget {
  final Object? object;
  String? id;
  String? type;
  String? page;
  ThermalPrint({
    super.key,
    this.id,
    this.object,
    this.page,
    this.type,
  });

  @override
  State<ThermalPrint> createState() => _ThermalPrintState();
}

final PdfController controller = Get.put(PdfController());

class _ThermalPrintState extends State<ThermalPrint> {
  String? address;
  String? printerName;
  List<Map<String, dynamic>> items = []; // Initialize empty items list

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions(); // Request Bluetooth permissions
    _loadPrinterInfo(); // Load printer info from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
      await controller.getPdf(id: widget.id, type: widget.type);
      await controller.fetchBusinessLogo();
      await controller.fetchBusinessSignature();
      setState(() {
        // Assuming controller.allDetails will give you the necessary data.
        items = controller.allDetails.isNotEmpty
            ? controller.allDetails[0].items!
                .map<Map<String, dynamic>>(
                  (item) => {
                    'name': item.itemId!.itemName,
                    'amount': item.finalAmount,
                    'quantity': item.quantity,
                    'price': item.price,
                  },
                )
                .toList()
            : []; // Ensure the list is updated.
        isLoading = false.obs;
      });
    });
  }

  // Load saved printer info from SharedPreferences
  _loadPrinterInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('printerAddress');
      printerName = prefs.getString('printerName');
    });
  }

  // Save printer info to SharedPreferences
  _savePrinterInfo(String address, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('printerAddress', address);
    prefs.setString('printerName', name);
  }

  Future<void> selectPrinter() async {
    final selected = await FlutterBluetoothPrinter.selectDevice(context);
    if (selected != null) {
      setState(() {
        address = selected.address;
        printerName = selected.name;
        _savePrinterInfo(selected.address,
            selected.name.toString()); // Save selected printer
        debugPrint("Selected Printer Address: $address");
      });
    }
  }

  Future<void> printReceipt() async {
    if (address != null) {
      Uint8List data = generatePrintData(items);

      debugPrint("Attempting to print...");
      try {
        final isPrinted = await FlutterBluetoothPrinter.printBytes(
          address: address!,
          data: data,
          keepConnected: true,
        );

        if (isPrinted) {
          debugPrint("Print successful");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Print successful')),
          );
        } else {
          debugPrint("Print failed");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select printer')),
          );
        }
      } catch (e) {
        debugPrint("Error during printing: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      debugPrint("No printer selected");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No printer selected')),
      );
    }
  }

  Uint8List generatePrintData(List<Map<String, dynamic>> items) {
    List<int> bytes = [];

    // ESC/POS Initialization
    bytes += [0x1B, 0x40]; // Initialize printer
    bytes += [0x1B, 0x61, 0x01]; // Center align text
    bytes +=
        "${controller.allDetails.isNotEmpty ? controller.allDetails[0].businessProfile?.businessName ?? 'Business Name' : 'Business Name'}\n"
            .codeUnits;
    bytes += [0x1B, 0x2D, 0x01]; // Enable underline
    bytes += "------------------------------\n".codeUnits;
    bytes += [0x1B, 0x2D, 0x00]; // Disable underline
    bytes += "SL  Item     Price    Qty   Amt\n"
        .codeUnits; // Header with Serial Number
    bytes += "------------------------------\n".codeUnits;

    // Use ListView.builder to dynamically create item rows with serial numbers
    int serialNumber = 1; // Initialize serial number
    for (var item in items) {
      String itemLine =
          " ${serialNumber.toString().padLeft(2, '0')}  ${item['name']}  ${item['price']}     ${item['quantity']}  \$${item['amount']}\n";
      bytes += itemLine.codeUnits;
      serialNumber++; // Increment serial number for each item
    }

    bytes += "------------------------------\n".codeUnits;
    bytes += [0x1B, 0x45, 0x01]; // Enable bold
    bytes +=
        "Total Taxable:        \$${items.fold(0.0, (total, item) => total + item['price'])}\n"
            .codeUnits;
    bytes +=
        "Total Tax    :        \$${items.fold(0.0, (total, item) => total + item['price'])}\n"
            .codeUnits;
    bytes += "------------------------------\n".codeUnits;
    bytes +=
        "Grand Total  :        \$${items.fold(0.0, (total, item) => total + item['price'])}\n"
            .codeUnits;
    bytes += "==============================\n".codeUnits;
    bytes += [0x1B, 0x45, 0x00]; // Disable bold
    bytes += "Thank You For Purchasing With Us\n".codeUnits;
    bytes += "\n\n\n".codeUnits; // Extra line feeds

    debugPrint("Generated print data: $bytes");

    return Uint8List.fromList(bytes);
  }

  // Request Bluetooth and Location permissions for Android
  void requestBluetoothPermissions() async {
    var bluetoothStatus = await Permission.bluetooth.status;
    if (!bluetoothStatus.isGranted) {
      await Permission.bluetooth.request();
    }

    var locationStatus = await Permission.locationWhenInUse.status;
    if (!locationStatus.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thermal Printer"),
        actions: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: selectPrinter,
              child: Text(
                printerName != null
                    ? printerName! // Show selected printer name
                    : "Select Printer", // Show default text if no printer selected
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: controller.logoImageData != null
                  ? Image(image: MemoryImage(controller.logoImageData!))
                  : const Center(child: Text("No Image")),
            ),
            const SizedBox(height: 20), // Space between image and text

            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.print,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ready to Print?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Make sure your Bluetooth printer is turned on and paired.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: printReceipt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Print Receipt',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Note : Please Make Sure Your Bluetooth Is Turned On",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
