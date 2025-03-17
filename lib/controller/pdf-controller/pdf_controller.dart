import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/pdf_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class PdfController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxList<PdfModel> allDetails = <PdfModel>[].obs;
  var isLoading = false.obs;
  Dio dio = Dio();
  Uint8List? logoImageData;
  Uint8List? signatureImageData;

  getPdf({id, type}) async {
    try {
      setLoadingValue(true);
      isLoading.value = true;
      var endpoint = 'generate-document?id=$id&documentType=$type';
      var response = await apiServices.getRequest(
        endurl: endpoint,
        authToken: await SharedPreLocalStorage.getToken(),
      );
      log("pdf details : $response");

      setLoadingValue(false);
      // Parse the response
      var jsonData = response!.data['data'];
      log(response.data['data']);
      if (jsonData != null) {
        PdfModel pdfModel = PdfModel.fromJson(jsonData);
        allDetails.clear();
        allDetails.add(pdfModel);
        log("Parsed PDF details successfully. Total: ${allDetails.length}");
      } else {
        log("No data found in the response.");
      }
    } catch (e) {
      log("Error in pdf controller: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBusinessLogo() async {
    try {
      if (allDetails.isNotEmpty &&
          allDetails[0].businessProfile?.logo != null) {
        final logoPath = allDetails[0].businessProfile!.logo!;
        final url = 'http://3.110.41.88:8081/uploads/images/$logoPath';
        log("image in controller : $logoPath");
        var response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        logoImageData = response.data;
      }
    } catch (e) {
      log("Error fetching business logo: $e");
    }
  }

  Future<void> fetchBusinessSignature() async {
    try {
      if (allDetails.isNotEmpty &&
          allDetails[0].businessProfile?.logo != null) {
        final signaturePath = allDetails[0].businessProfile!.signature!;
        final url = 'http://3.110.41.88:8081/uploads/images/$signaturePath';
        log("image in controller : $signaturePath");
        var response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        signatureImageData = response.data;
      }
    } catch (e) {
      log("Error fetching business logo: $e");
    }
  }
}
