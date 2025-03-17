// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:vyapar_clone/core/snackbar/my_snackbar.dart';
// import 'package:vyapar_clone/model/business_type_model.dart';
// import 'package:vyapar_clone/model/country_model.dart';
// import 'package:vyapar_clone/model/item_detail_model/business_category_model.dart';
// import 'package:vyapar_clone/model/state_model.dart';

// import 'package:vyapar_clone/repository/app_data/user_data/shared_preferences.dart';

// import '../../core/common/loading_var.dart';
// import '../../core/isResponseOk.dart';
// import '../../model/business_profile_model.dart';
// import '../../repository/api/api_services/api_services.dart';
// import '../../repository/api/end_urls/end_url.dart';

// import '../home_screen/controller/home_screen_controller.dart';

// class BusinessController extends GetxController {
//   final ApiServices _apiServices = ApiServices();
//   final TextEditingController businessNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController gstinController = TextEditingController();
//   final TextEditingController emailIdController = TextEditingController();
//   final TextEditingController businessAddressController =
//       TextEditingController();
//   final TextEditingController pinCodeController = TextEditingController();
//   final TextEditingController businessDescriptionController =
//       TextEditingController();
//   // RxString selectedCountry = "".obs;
//   RxList country = <CountryModel>[].obs;
//   var selectedCountry = CountryModel().obs;
//   RxList businessType = <BusinessTypeModel>[].obs;
//   var selectedBusinessType = BusinessTypeModel().obs;
//   RxList businessCategory = <BusinessCategoryModel>[].obs;
//   var selectedBusinessCategory = BusinessCategoryModel().obs;
//   RxString pickedLogoPath = "".obs;
//   RxString signaturePath = "".obs;
//   RxString apiLogo = "".obs;
//   RxString apiSignature = "".obs;
//   RxString userRole = "".obs;
//   Rx<BusinessProfileModel> businessProfile = BusinessProfileModel().obs;
//   // var logoFile = File.obs;
//   File? logoFile;
//   void postBusinessProfile(
//       {String? state,
//       String? businessType,
//       String? businessCategory,
//       File? signatureFile}) async {
//     // var
//     setLoadingValue(true);

//     dio.FormData formData = dio.FormData.fromMap({
//       "businessName": businessNameController.text,
//       "gstIn": gstinController.text,
//       "phoneNo": phoneController.text,
//       "email": emailIdController.text,
//       "businessAddress": businessAddressController.text,
//       "businessType": selectedBusinessType.value.id == null
//           ? ''
//           : selectedCountry.value.id.toString(),
//       "pincode": pinCodeController.text,
//       "businessCategory": selectedBusinessCategory.value.id == null
//           ? ''
//           : selectedCountry.value.id.toString(),
//       "state": selectedCountry.value.id == null
//           ? ''
//           : selectedCountry.value.id.toString(),
//       "businessDescription": businessDescriptionController.text,
//       "secondPhoneNo": "",
//     });

//     log("Logo url ==${pickedLogoPath.value},signature file ==${signatureFile}");
//     if (pickedLogoPath.value.toString() != "") {
//       String logoName = pickedLogoPath.value.split('/').last;
//       formData.files.add(MapEntry(
//           "logo",
//           await dio.MultipartFile.fromFile(pickedLogoPath.value.toString(),
//               contentType: dio.DioMediaType("image", "jpg"),
//               filename: logoName)));
//     }
//     if (signatureFile != null) {
//       String fileName = signatureFile.path.split('/').last;
//       formData.files.add(
//         MapEntry(
//           "signature",
//           await dio.MultipartFile.fromFile(signatureFile.path,
//               contentType: dio.DioMediaType("image", "jpg"),
//               filename: fileName),
//         ),
//       );
//     }

//     var response = await _apiServices.postMultiPartData(
//         data: formData,
//         // fileParameters: parameters,
//         // files: fileList,
//         endUrl: EndUrl.createBusinessProfile,
//         authToken: await SharedPreLocalStorage.getToken());

//     if (response != null) {
//       setLoadingValue(false);
//       printInfo(info: "response to save invoice==$response");
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         clearProfileControllerValue();
//         var homec = Get.find<HomeController>();
//         await homec.fetchUserProfile();
//         Get.back();
//         SnackBars.showSuccessSnackBar(text: "Successfully Saved Profile");
//       }
//     }
//     setLoadingValue(false);
//   }

//   void setBusinessControllerValue({required BusinessProfileModel model}) {
//     pickedLogoPath.value = "";
//     BusinessProfile object = model.businessProfile ?? BusinessProfile();
//     businessNameController.text = object.businessName.toString();
//     phoneController.text = object.phoneNo.toString();
//     gstinController.text = object.gstIn.toString();
//     emailIdController.text = object.email.toString();
//     businessAddressController.text = object.businessAddress.toString();
//     pinCodeController.text = object.pincode.toString();
//     businessDescriptionController.text = object.businessDescription.toString();
//     apiLogo.value = object.logo != null && object.logo != "null"
//         ? object.logo.toString()
//         : "";
//     apiSignature.value = object.signature != null && object.signature != "null"
//         ? object.signature.toString()
//         : "";
//   }

//   void clearProfileControllerValue() {
//     businessNameController.text = '';
//     phoneController.text = '';
//     gstinController.text = '';
//     emailIdController.text = '';
//     businessAddressController.text = '';
//     pinCodeController.text = '';
//     businessDescriptionController.text = '';
//     pickedLogoPath.value = "";
//   }

//   bool validateBusinessForm() {
//     // log("Business Name controller ==${businessNameController.text}");
//     if (businessNameController.text.isEmpty) {
//       SnackBars.showErrorSnackBar(text: "Please Enter Business Name");
//       return false;
//     } else {
//       return true;
//     }
//   }

//   Future<void> fetchUserProfile() async {
//     setLoadingValue(true);
//     log("This is fetch User Profile");
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.createBusinessProfile,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       setLoadingValue(false);
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data;
//         userRole.value = jsonResponse['userRole'];
//         log("Profile response ==$jsonResponse");
//         log("Profile response user role ==${userRole.value}");
//         BusinessProfileModel model =
//             BusinessProfileModel.fromJson(jsonResponse);
//         businessProfile.value = model;
//         setBusinessControllerValue(model: model);
//       }
//     }

//     setLoadingValue(false);
//   }

//   void fetchCountry() async {
//     setLoadingValue(true);
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.country,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data['data'];

//         List<StateModel> list = List<StateModel>.from(
//             jsonResponse.map((x) => StateModel.fromJson(x)));

//         country.assignAll(list);

//         setLoadingValue(false);
//       }
//       setLoadingValue(false);
//     }
//     setLoadingValue(false);
//   }

//   void fetchBusinessType() async {
//     setLoadingValue(true);
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.businessTypeUrl,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data;

//         List<BusinessTypeModel> list = List<BusinessTypeModel>.from(
//             jsonResponse.map((x) => BusinessTypeModel.fromJson(x)));

//         businessType.assignAll(list);

//         setLoadingValue(false);
//       }
//       setLoadingValue(false);
//     }
//     setLoadingValue(false);
//   }

//   void fetchBusinessCategory() async {
//     setLoadingValue(true);
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.businessCategoryUrl,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data;

//         List<BusinessCategoryModel> list = List<BusinessCategoryModel>.from(
//             jsonResponse.map((x) => BusinessCategoryModel.fromJson(x)));

//         businessCategory.assignAll(list);

//         setLoadingValue(false);
//       }
//       setLoadingValue(false);
//     }
//     setLoadingValue(false);
//   }

//   @override
//   void onInit() async {
//     // TODO: implement onInit
//     super.onInit();
//     await fetchUserProfile();
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/model/business_category_model.dart';
import 'package:newthijar/model/business_profile_model.dart';
import 'package:newthijar/model/business_type_model.dart';
import 'package:newthijar/model/country_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';
// import 'package:vyapar_clone/core/snackbar/my_snackbar.dart';
// import 'package:vyapar_clone/model/business_type_model.dart';
// import 'package:vyapar_clone/model/country_model.dart';
// import 'package:vyapar_clone/model/item_detail_model/business_category_model.dart';
// import 'package:vyapar_clone/model/state_model.dart';
// import 'package:vyapar_clone/repository/app_data/user_data/shared_preferences.dart';

// import '../../core/common/loading_var.dart';
// import '../../core/isResponseOk.dart';
// import '../../model/business_profile_model.dart';
// import '../../repository/api/api_services/api_services.dart';
// import '../../repository/api/end_urls/end_url.dart';

// import '../home_screen/controller/home_screen_controller.dart';

class BusinessController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController businessAddressController =
      TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();

  RxList country = <CountryModel>[].obs;
  var selectedCountry = CountryModel().obs;
  RxList businessType = <BusinessTypeModel>[].obs;
  var selectedBusinessType = BusinessTypeModel().obs;
  RxList businessCategory = <BusinessCategoryModel>[].obs;
  var selectedBusinessCategory = BusinessCategoryModel().obs;
  RxString pickedLogoPath = "".obs;
  RxString signaturePath = "".obs;
  RxString apiLogo = "".obs;
  RxString apiSignature = "".obs;
  RxString userRole = "".obs;
  Rx<BusinessProfileModel> businessProfile = BusinessProfileModel().obs;
  File? logoFile;

  void postBusinessProfile({
    String? state,
    String? businessType,
    String? businessCategory,
    File? signatureFile,
  }) async {
    setLoadingValue(true);

    dio.FormData formData = dio.FormData.fromMap({
      "businessName": businessNameController.text,
      "gstIn": gstinController.text,
      "phoneNo": phoneController.text,
      "email": emailIdController.text,
      "businessAddress": businessAddressController.text,
      "businessType": selectedBusinessType.value.id == null
          ? ''
          : selectedCountry.value.id.toString(),
      "pincode": pinCodeController.text,
      "businessCategory": selectedBusinessCategory.value.id == null
          ? ''
          : selectedCountry.value.id.toString(),
      "state": selectedCountry.value.id == null
          ? ''
          : selectedCountry.value.id.toString(),
      "businessDescription": businessDescriptionController.text,
      "secondPhoneNo": "",
    });

    log("Logo url ==${pickedLogoPath.value}, signature file ==${signatureFile}");

    if (pickedLogoPath.value.isNotEmpty) {
      String logoName = pickedLogoPath.value.split('/').last;
      formData.files.add(MapEntry(
        "logo",
        await dio.MultipartFile.fromFile(
          pickedLogoPath.value,
          contentType: dio.DioMediaType("image", "jpg"),
          filename: logoName,
        ),
      ));
    }

    if (signatureFile != null) {
      String fileName = signatureFile.path.split('/').last;
      formData.files.add(MapEntry(
        "signature",
        await dio.MultipartFile.fromFile(
          signatureFile.path,
          contentType: dio.DioMediaType("image", "jpg"),
          filename: fileName,
        ),
      ));
    }

    var response = await _apiServices.postMultiPartData(
      data: formData,
      endUrl: EndUrl.createBusinessProfile,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        clearProfileControllerValue();
        var homec = Get.find<HomeController>();
        await homec.fetchUserProfile();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully Saved Profile");
      }
    }
    setLoadingValue(false);
  }

  void setBusinessControllerValue({required BusinessProfileModel model}) {
    pickedLogoPath.value = "";
    BusinessProfile object = model.businessProfile ?? BusinessProfile();
    businessNameController.text = object.businessName ?? '';
    phoneController.text = object.phoneNo ?? '';
    gstinController.text = object.gstIn ?? '';
    emailIdController.text = object.email ?? '';
    businessAddressController.text = object.businessAddress ?? '';
    pinCodeController.text = object.pincode ?? '';
    businessDescriptionController.text = object.businessDescription ?? '';
    apiLogo.value = object.logo ?? '';
    apiSignature.value = object.signature ?? '';
  }

  void clearProfileControllerValue() {
    businessNameController.clear();
    phoneController.clear();
    gstinController.clear();
    emailIdController.clear();
    businessAddressController.clear();
    pinCodeController.clear();
    businessDescriptionController.clear();
    pickedLogoPath.value = "";
  }

  bool validateBusinessForm() {
    if (businessNameController.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please Enter Business Name");
      return false;
    } else {
      return true;
    }
  }

  Future<void> fetchUserProfile() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
      endurl: EndUrl.createBusinessProfile,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data;
        userRole.value = jsonResponse['userRole'];
        log("Profile response user role ==${userRole.value}");

        BusinessProfileModel model =
            BusinessProfileModel.fromJson(jsonResponse);
        businessProfile.value = model;
        setBusinessControllerValue(model: model);

        // Trigger UI update for role change
        update();
      }
    }
    setLoadingValue(false);
  }

  void fetchCountry() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
      endurl: EndUrl.country,
      authToken: await SharedPreLocalStorage.getToken(),
    );
    log("response : $response");

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data;
        List<CountryModel> list = List<CountryModel>.from(
          jsonResponse.map((x) => CountryModel.fromJson(x)),
        );
        country.assignAll(list);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void fetchBusinessType() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
      endurl: EndUrl.businessTypeUrl,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data;
        List<BusinessTypeModel> list = List<BusinessTypeModel>.from(
          jsonResponse.map((x) => BusinessTypeModel.fromJson(x)),
        );
        businessType.assignAll(list);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void fetchBusinessCategory() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
      endurl: EndUrl.businessCategoryUrl,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data;
        List<BusinessCategoryModel> list = List<BusinessCategoryModel>.from(
          jsonResponse.map((x) => BusinessCategoryModel.fromJson(x)),
        );
        businessCategory.assignAll(list);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchUserProfile();
  }
}
