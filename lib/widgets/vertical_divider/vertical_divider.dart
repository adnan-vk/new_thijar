import 'package:flutter/material.dart';

class VerticleDivider extends StatelessWidget {
  const VerticleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.black12,
        width: double.infinity,
        height: screenHeight * .001);
  }
}
