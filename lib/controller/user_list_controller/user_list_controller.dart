import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/user_list_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class UserListController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxList<UserListModel> allUsers = <UserListModel>[].obs;
  var isLoading = false.obs;
  RxString totalSaleAmount = ''.obs;
  List<List<String>> pdfDataList = [];
  final dateController = DateController();

  void getUserList() async {
    try {
      setLoadingValue(true);
      isLoading.value = true;
      allUsers.clear();
      var endpoint = 'sync-share/users';
      var response = await apiServices.getRequest(
        endurl: endpoint,
        authToken: await SharedPreLocalStorage.getToken(),
      );
      log("response of user list : $response");

      setLoadingValue(false);
      List jsonData = response!.data['data'];
      List<UserListModel> list =
          jsonData.map((x) => UserListModel.fromJson(x)).toList();

      log("${list.length}");
      allUsers.addAll(list);
    } catch (e) {
      log("error in user list controller $e");
    } finally {
      isLoading.value = false;
    }
  }
}
