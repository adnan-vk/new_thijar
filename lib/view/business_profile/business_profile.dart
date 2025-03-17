// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/pdf-controller/pdf_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/business_model.dart';
import 'package:newthijar/model/country_model.dart';
import 'package:newthijar/service/business_profile_service.dart';
import 'package:newthijar/urls/base_url.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen>
    with SingleTickerProviderStateMixin {
  final BusinessProfileService _service = BusinessProfileService(Dio());
  var controller = Get.put(TransactionDetailController());

  AddBusinesskModel? _businessProfile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? selectedState;
  String? selectedBusinessType;
  String? selectedBusinessCategory;
  File? signatureFile;
  Uint8List? _signatureImageBasic;
  Uint8List? _signatureImageBusiness;
  final picker = ImagePicker();
  XFile? _image;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  late TabController _tabController;
  final PdfController pdfcontroller = Get.put(PdfController());
  final _controller = Get.put(BusinessController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // _controller.fetchUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<File?> saveImage(Uint8List? imageBytes, String fileName) async {
    if (imageBytes == null) return null;

    // Get the temporary directory of the device
    final directory = await getTemporaryDirectory();

    // Create a file path for the image
    final filePath = '${directory.path}/$fileName';
    log("Signature path ==${filePath}");
    // Write the bytes to the file
    _controller.signaturePath.value = filePath;
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return file;
  }

  Future<void> _saveSignature(
      GlobalKey<SignatureState> key, bool isBasic) async {
    log("Signature---${key}---${isBasic}");
    final signatureState = key.currentState;
    if (signatureState == null) return;

    final signature = await signatureState.getData();
    final bytes = await signature.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      signatureFile =
          await saveImage(bytes.buffer.asUint8List(), "signature.jpg");

      setState(() {
        if (isBasic) {
          _signatureImageBasic = bytes.buffer.asUint8List();
        } else {
          _signatureImageBusiness = bytes.buffer.asUint8List();
        }
      });
    }
  }

  Widget buildSignaturePad(bool isBasic) {
    final key = GlobalKey<SignatureState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8.r),
          ),
          height: 150,
          child: Signature(
            key: key,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48, // Ensuring both buttons have the same height
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 6, 50, 115),
                      Color.fromARGB(255, 30, 111, 191)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    minimumSize:
                        const Size(double.infinity, 48), // Matching height
                  ),
                  onPressed: () => key.currentState?.clear(),
                  child: const Text('Clear'),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 6, 50, 115),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  minimumSize:
                      const Size(double.infinity, 48), // Matching height
                ),
                onPressed: () => _saveSignature(key, isBasic),
                child: const Text(
                  'Save Signature',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if ((isBasic ? _signatureImageBasic : _signatureImageBusiness) != null)
          Image.memory(
            isBasic ? _signatureImageBasic! : _signatureImageBusiness!,
            height: 100,
          ),
        SizedBox(height: 20.h),
        Obx(() {
          log("Signature url==${ApiBaseUrl.fileBaseUrl + _controller.apiSignature.value}");
          return _controller.apiSignature.value != ""
              ? Column(
                  children: [
                    Text(
                      "Uploaded Signature ",
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      child: Image.network(
                        ApiBaseUrl.fileBaseUrl + _controller.apiSignature.value,
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        })
      ],
    );
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        imageNotifier.value = File(pickedImage.path);
        _controller.pickedLogoPath.value = pickedImage.path;
      }
    } catch (e) {
      log("Error when picking image ==$e");
    }
    Get.back();
  }

  void showImageSourceDialog(BuildContext context) {
    _controller.apiLogo.value = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await pickImage(source: ImageSource.camera);
            },
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await pickImage(source: ImageSource.gallery);
            },
            child: const Text("Gallery"),
          ),
        ],
      ),
    );
  }

  Widget buildBasicDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showImageSourceDialog(
                context), // Corrected here by calling pickImage()
            child: Obx(() {
              return _controller.apiLogo.value != ""
                  ? CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(
                          ApiBaseUrl.fileBaseUrl + _controller.apiLogo.value),
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              size: 30, color: Colors.white)
                          : null,
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _controller.pickedLogoPath.toString() != ""
                              ? FileImage(
                                  File(_controller.pickedLogoPath.toString()))
                              : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              size: 30, color: Colors.white)
                          : null,
                    );
            }),
          ),
          const SizedBox(height: 16),
          buildTextField('Business Name',
              textController: _controller.businessNameController),
          const SizedBox(height: 16),
          buildTextField('Phone Number',
              textController: _controller.phoneController,
              inputFormate: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 16),
          buildTextField('TaxRegNo',
              textController: _controller.gstinController),
          const SizedBox(height: 16),
          buildTextField('Email ID',
              textController: _controller.emailIdController),
          const SizedBox(height: 16),
          buildTextField('Business Address',
              textController: _controller.businessAddressController),
          const SizedBox(height: 16),
          buildTextField('Pincode',
              isNumeric: true,
              textController: _controller.pinCodeController,
              inputFormate: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 16),
          buildTextField(
            'Business Description',
            textController: _controller.businessDescriptionController,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithText(String text, String trailingText) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(color: Colors.black)),
            Row(children: [
              SizedBox(
                width: 100,
                child: Text(
                  trailingText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.sp,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Icon(Icons.arrow_drop_down)
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildBusinessDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Obx(
            () => GestureDetector(
                onTap: () => _showCountrySelectionBottomSheet(context),
                child: _buildRowWithText(
                    "Country ",
                    _controller.selectedCountry.value.name ??
                        "Select Your Country")),
          ),
          const SizedBox(height: 16),
          Obx(
            () => GestureDetector(
                onTap: () => _showBusinessTypeBottomSheet(context),
                child: _buildRowWithText(
                    "Business Type ",
                    _controller.selectedBusinessType.value.name ??
                        "Select Business Type")),
          ),
          const SizedBox(height: 16),
          Obx(
            () => GestureDetector(
                onTap: () => _showBusinessCategoryBottomSheet(context),
                child: _buildRowWithText(
                    "Business Category ",
                    _controller.selectedBusinessCategory.value.name ??
                        "Select Category")),
          ),
          const SizedBox(height: 16),
          const Text('Upload Signature',
              style: TextStyle(fontSize: 16, color: Colors.black)),
          buildSignaturePad(false),
        ],
      ),
    );
  }

  Widget buildTextField(String label,
      {bool isNumeric = false,
      String? initialValue,
      TextEditingController? textController,
      List<TextInputFormatter>? inputFormate,
      Function(String)? onChanged}) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: textController,
          // controller: textController??TextEditingController(),
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
          initialValue: initialValue,
          onChanged: onChanged,
          inputFormatters: inputFormate,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  void _showCountrySelectionBottomSheet(context) {
    if (_controller.country.length.toInt() == 0) {
      _controller.fetchCountry();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7, // Adjust size as needed
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Column(
              children: [
                // Header of Bottom Sheet
                ListTile(
                  title: const Text("Select Country "),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const Divider(),
                Obx(() {
                  return Expanded(
                    child: isLoading.value == true
                        ? Center(
                            child: SizedBox(
                                height: 80.w,
                                width: 80.w,
                                child: const CircularProgressIndicator()),
                          )
                        : _controller.country.length.toInt() == 0
                            ? Center(
                                child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontSize: 20.sp, color: Colors.black),
                              ))
                            : ListView.builder(
                                controller: controller,
                                itemCount: _controller.country.length,
                                itemBuilder: (context, index) {
                                  CountryModel obj = _controller.country[index];
                                  return ListTile(
                                    title: Text(obj.name.toString()),
                                    onTap: () {
                                      _controller.selectedCountry.value = obj;

                                      Get.back();
                                    },
                                  );
                                },
                              ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  void _showBusinessTypeBottomSheet(context) {
    if (_controller.businessType.length.toInt() == 0) {
      _controller.fetchBusinessType();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7, // Adjust size as needed
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Column(
              children: [
                // Header of Bottom Sheet
                ListTile(
                  title: const Text("Business Type "),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const Divider(),
                Obx(() {
                  return Expanded(
                    child: isLoading.value == true
                        ? Center(
                            child: SizedBox(
                                height: 80.w,
                                width: 80.w,
                                child: const CircularProgressIndicator()),
                          )
                        : _controller.businessType.length.toInt() == 0
                            ? Center(
                                child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontSize: 20.sp, color: Colors.black),
                              ))
                            : ListView.builder(
                                controller: controller,
                                itemCount: _controller.businessType.length,
                                itemBuilder: (context, index) {
                                  final obj = _controller.businessType[index];
                                  return ListTile(
                                    title: Text(obj.name.toString()),
                                    onTap: () {
                                      _controller.selectedBusinessType.value =
                                          obj;

                                      Get.back();
                                    },
                                  );
                                },
                              ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  void _showBusinessCategoryBottomSheet(context) {
    if (_controller.businessCategory.length.toInt() == 0) {
      _controller.fetchBusinessCategory();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7, // Adjust size as needed
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Column(
              children: [
                // Header of Bottom Sheet
                ListTile(
                  title: const Text("Business Category "),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const Divider(),
                Obx(() {
                  return Expanded(
                    child: isLoading.value == true
                        ? Center(
                            child: SizedBox(
                                height: 80.w,
                                width: 80.w,
                                child: const CircularProgressIndicator()),
                          )
                        : _controller.businessCategory.length.toInt() == 0
                            ? Center(
                                child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontSize: 20.sp, color: Colors.black),
                              ))
                            : ListView.builder(
                                controller: controller,
                                itemCount: _controller.businessCategory.length,
                                itemBuilder: (context, index) {
                                  final obj =
                                      _controller.businessCategory[index];
                                  return ListTile(
                                    title: Text(obj.name.toString()),
                                    onTap: () {
                                      _controller
                                          .selectedBusinessCategory.value = obj;

                                      Get.back();
                                    },
                                  );
                                },
                              ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log("business card logo:${_controller.businessProfile.value.businessProfile?.logo.toString()}");
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: TopBar(
              page: "Business Profile",
            ),
          ),
          Positioned(
            top: 160, // Adjust this to position the curved container correctly
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
                  // Tab Bar inside the body
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Basic Details'),
                      Tab(text: 'Business Details'),
                    ],
                  ),
                  // Tab Bar View inside the body
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildBasicDetailsTab(),
                        buildBusinessDetailsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () => _controller.validateBusinessForm()
              ? _controller.postBusinessProfile(
                  businessCategory: selectedBusinessCategory,
                  businessType: selectedBusinessType,
                  signatureFile: signatureFile)
              : null,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191) // Lighter blue
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Add User',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
