import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildBottomButtons(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Container(
          height: 50, // Set height to match the image
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 50, // Set height to match the image
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 50, 115),
                Color.fromARGB(255, 30, 111, 191)
              ], // Gradient blue
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Save",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ],
  );
}
