// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:vyapar_clone/core/common/context_provider.dart';
// import 'package:vyapar_clone/model/business_profile_model.dart';

// import 'package:vyapar_clone/model/invoice_model.dart';
// import 'package:vyapar_clone/model/party_model.dart';

// import 'package:vyapar_clone/repository/app_data/database/db.dart';

// import '../../../core/common/loading_var.dart';
// import '../../../core/isResponseOk.dart';
// import '../../../repository/api/api_services/api_services.dart';
// import '../../../repository/api/end_urls/end_url.dart';
// import '../../../repository/app_data/user_data/shared_preferences.dart';

// class HomeController extends GetxController with GetTickerProviderStateMixin {
//   final ContextProvider contextProvider = ContextProvider();
//   final ScrollController scrollController = ScrollController();
//   final ApiServices _apiServices = ApiServices();

//   final Repository? repository;

//   HomeController({this.repository});

//   RxInt screenIndex = 0.obs;
//   RxInt selectedHeaderBtnIndex = 0.obs;

//   RxBool isAddButnVisible = true.obs;
//   var busiNessProfileModel = BusinessProfileModel().obs;
//   // void onHeaderButtonTap(value) {
//   //   selectedHeaderBtnIndex.value = value;
//   // }
//   var allInvoice = <InvoiceModel>[].obs;
//   var allParties = <PartyModel>[].obs;
//   RxBool loading = false.obs;

//   late TabController tabController;
//   RxInt tabIndex = 0.obs;
//   void settabIndexValue(value) {
//     tabIndex.value = value;
//     tabController.index = value;
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     tabController = TabController(length: 2, vsync: this);
//     _tabListener();
//     scrollListener();
//     getAllInvoice();
//     getAllParty();
//     fetchUserProfile();
//   }

//   _tabListener() {
//     tabController.addListener(() {
//       tabIndex.value = tabController.index;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     scrollController.dispose();
//   }

//   void scrollListener() {
//     scrollController.addListener(() {
//       if (scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (isAddButnVisible.value) {
//           isAddButnVisible.value = false;
//         }
//       } else if (scrollController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (!isAddButnVisible.value) {
//           isAddButnVisible.value = true;
//         }
//       }
//     });
//   }

//   void setCurrenScreen(value) {
//     screenIndex.value = value;
//   }

//   Future<void> fetchUserProfile() async {
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.createBusinessProfile,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data;

//         BusinessProfileModel model =
//             BusinessProfileModel.fromJson(jsonResponse);

//         busiNessProfileModel.value = model;
//       }
//     }
//   }

//   Future<void> getAllInvoice() async {
//     setLoadingValue(true);
//     loading.value = true;
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.invoiceUrl,
//         authToken: await SharedPreLocalStorage.getToken());
//     if (response != null) {
//       setLoadingValue(false);
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data['data'];
//         if (jsonResponse != null) {
//           List<InvoiceModel> list = List<InvoiceModel>.from(
//               jsonResponse.map((x) => InvoiceModel.fromJson(x)));

//           allInvoice.assignAll(list);
//         } else {
//           allInvoice.assignAll([]);
//         }

//         // printInfo(info: "length of invoices ==${list.length}");
//       }
//       loading.value = false;
//       setLoadingValue(false);
//     }
//     setLoadingValue(false);
//   }

//   void searchSalesInvoice(String query) async {
//     if (query.isEmpty) {
//       await getAllInvoice();
//       return;
//     }
//     try {
//       isLoading.value = true;
//       var response = await _apiServices.getRequest(
//         endurl: 'invoice?search=$query',
//         authToken: await SharedPreLocalStorage.getToken(),
//       );
//       List jsonData = response!.data['data'];
//       List<InvoiceModel> list =
//           jsonData.map((x) => InvoiceModel.fromJson(x)).toList();
//       allInvoice.assignAll(list);
//     } catch (e) {
//       isLoading.value = false;
//       log("Error in searchSalesInvoice: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void getAllParty() async {
//     setLoadingValue(true);
//     var response = await _apiServices.getRequest(
//         endurl: EndUrl.addParty,
//         authToken: await SharedPreLocalStorage.getToken());

//     if (response != null) {
//       if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
//         var jsonResponse = response.data['data'];

//         List<PartyModel> list = List<PartyModel>.from(
//             jsonResponse.map((x) => PartyModel.fromJson(x)));

//         allParties.assignAll(list);

//         setLoadingValue(false);
//       }
//       setLoadingValue(false);
//     }
//     setLoadingValue(false);
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/business_profile_model.dart';
import 'package:newthijar/model/invoice_model.dart';
import 'package:newthijar/model/party_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/db/db.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final ContextProvider contextProvider = ContextProvider();
  final ScrollController scrollController = ScrollController();
  final ApiServices _apiServices = ApiServices();
  final Repository? repository;

  HomeController({this.repository});

  RxInt screenIndex = 0.obs;
  RxInt selectedHeaderBtnIndex = 0.obs;

  RxBool isAddButnVisible = true.obs;
  RxBool isFetchingMore = false.obs; // ✅ Added missing variable
  RxBool isLoading = false.obs; // ✅ Ensuring isLoading is defined

  var busiNessProfileModel = BusinessProfileModel().obs;
  var allInvoice = <InvoiceModel>[].obs;
  var allParties = <PartyModel>[].obs;

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  void settabIndexValue(int value) {
    tabIndex.value = value;
    tabController.index = value;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _tabListener();
    scrollListener();
    getAllInvoice();
    getAllParty();
    fetchUserProfile();
  }

  void _tabListener() {
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isAddButnVisible.value) {
          isAddButnVisible.value = false;
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isAddButnVisible.value) {
          isAddButnVisible.value = true;
        }
      }
    });
  }

  void setCurrenScreen(int value) {
    screenIndex.value = value;
  }

  Future<void> fetchUserProfile() async {
    var response = await _apiServices.getRequest(
      endurl: EndUrl.createBusinessProfile,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null &&
        CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
      var jsonResponse = response.data;
      busiNessProfileModel.value = BusinessProfileModel.fromJson(jsonResponse);
    }
  }

  Future<void> getAllInvoice() async {
    setLoadingValue(true);
    isLoading.value = true;
    var response = await _apiServices.getRequest(
      endurl: EndUrl.invoiceUrl,
      authToken: await SharedPreLocalStorage.getToken(),
    );

    if (response != null &&
        CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
      var jsonResponse = response.data['data'];
      if (jsonResponse != null) {
        allInvoice.assignAll(List<InvoiceModel>.from(
            jsonResponse.map((x) => InvoiceModel.fromJson(x))));
      } else {
        allInvoice.clear();
      }
    }
    isLoading.value = false;
    setLoadingValue(false);
  }

  Future<void> searchSalesInvoice(String query) async {
    if (query.isEmpty) {
      await getAllInvoice();
      return;
    }
    try {
      isLoading.value = true;
      var response = await _apiServices.getRequest(
        endurl: 'invoice?search=$query',
        authToken: await SharedPreLocalStorage.getToken(),
      );

      if (response != null &&
          CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonData = response.data['data'];
        allInvoice.assignAll(List<InvoiceModel>.from(
            jsonData.map((x) => InvoiceModel.fromJson(x))));
      } else {
        allInvoice.clear();
      }
    } catch (e) {
      log("Error in searchSalesInvoice: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getAllParty() async {
  //   setLoadingValue(true);
  //   var response = await _apiServices.getRequest(
  //     endurl: EndUrl.addParty,
  //     authToken: await SharedPreLocalStorage.getToken(),
  //   );

  //   if (response != null &&
  //       CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
  //     var jsonResponse = response.data['data'];
  //     allParties.assignAll(List<PartyModel>.from(
  //         jsonResponse.map((x) => PartyModel.fromJson(x))));
  //   }
  //   setLoadingValue(false);
  // }
  void getAllParty({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      setLoadingValue(true);
    }

    var response = await _apiServices.getRequest(
        endurl: EndUrl.addParty,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<PartyModel> list = List<PartyModel>.from(
            jsonResponse.map((x) => PartyModel.fromJson(x)));

        if (isLoadMore) {
          allParties.clear();
          allParties.addAll(list);
        } else {
          allParties.assignAll(list);
        }

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }
}
