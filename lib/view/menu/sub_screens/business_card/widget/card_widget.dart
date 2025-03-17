import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BusinessCard extends StatefulWidget {
  final String? businessName;
  final String? email;
  final String? address;
  final String? phone;
  final String? image;
  const BusinessCard({
    super.key,
    this.address,
    this.businessName,
    this.email,
    this.phone,
    this.image,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  final PageController _pageController = PageController();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  int _currentPage = 0; // Track the current page index

  Future<void> _captureAndShareCard() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Increase pixel ratio for higher-quality image
      ui.Image image =
          await boundary.toImage(pixelRatio: 5.0); // Higher pixel ratio
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/business_card.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      // Use Share.shareFiles to share the high-quality image file
      await Share.shareXFiles(
        [XFile(imagePath)],
      );
    } catch (e) {
      debugPrint('Error capturing and sharing card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        // Business card section with stacked layout for the button
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RepaintBoundary(
              key: _repaintBoundaryKey,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 200, // Adjust card height
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          _buildCard(
                              screenSize, 'assets/images/businss card 1.jpg'),
                          _buildCard(
                              screenSize, 'assets/images/business card 3.jpg'),
                          _buildCard(
                              screenSize, 'assets/images/business card 4.jpg'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned Share Button
            Positioned(
              top: 160, // Adjust position as needed
              child: ElevatedButton(
                onPressed: _captureAndShareCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  elevation: 6, // Shadow elevation
                  shadowColor: Colors.black.withOpacity(0.2), // Soft shadow
                  minimumSize: Size(
                      screenSize.width * 0.3, 40), // Reduced width and height
                ),
                child: Row(
                  children: [
                    const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold, // Font weight
                        letterSpacing: 1.2, // Spacing between letters
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Transform(
                      transform: Matrix4.diagonal3Values(-1, 1, 1),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.reply_outlined,
                        size: 23.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dots indicator to show current page
            Positioned(
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index ? Colors.red : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(Size screenSize, String assetImage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image:
            DecorationImage(image: AssetImage(assetImage), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                  widget.businessName.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: screenSize.width * .02),
              ],
            ),
            SizedBox(height: screenSize.height * .01),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 13),
                const SizedBox(width: 5),
                Text(
                  widget.phone.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.email_outlined, color: Colors.white, size: 13),
                const SizedBox(width: 5),
                Text(
                  widget.email.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.white, size: 13),
                const SizedBox(width: 5),
                Text(
                  widget.address.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
