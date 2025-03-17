import 'package:get/get.dart';
import 'package:newthijar/model/dashboard_mode.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';

class DashBoardController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  RxBool dashBoardLoading = false.obs;
  void setDashLoading({required bool value}) {
    dashBoardLoading.value = value;
  }

  var dashBoardModel = DashBoardModel().obs;

  Future<void> fetchDashBoardData() async {
    setDashLoading(value: true);
    var response = await _apiServices.getRequest(
        endurl: EndUrl.dashboardEnd,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      setDashLoading(value: false);

      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data;

        DashBoardModel model = DashBoardModel.fromJson(jsonResponse);
        dashBoardModel.value = model;
      }
    }
    setDashLoading(value: false);
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchDashBoardData();
  }
}
