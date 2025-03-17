// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

import '../urls/base_url.dart';

class ApiServices {
  ApiServices() {
    _dio.interceptors.add(CustomInterceptor());
  }

  final ApiBaseUrl _baseUrls = ApiBaseUrl();

  final Dio _dio = Dio();
  void initDio() {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Response?> getRequest(
      {required String endurl, String? authToken}) async {
    try {
      // initDio();
      final options = Options(
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );
      printApiInfo(
          url: _baseUrls.apiBaseUrl() + endurl, payload: options.headers);

      final response = await _dio.get(
        _baseUrls.apiBaseUrl() + endurl,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      log("error while fetching data ==$e");
      SnackBars.showErrorSnackBar(text: e.message);

      return null;
    }
  }

  Future<Response?> deleteRequest(
      {required String endurl, String? authToken}) async {
    try {
      // initDio();
      final options = Options(
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );
      printApiInfo(
          url: _baseUrls.apiBaseUrl() + endurl, payload: options.headers);

      final response = await _dio.delete(
        _baseUrls.apiBaseUrl() + endurl,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      log("error while fetching data ==$e");
      SnackBars.showErrorSnackBar(text: e.toString());

      return null;
    }
  }

  Future<Response?> postMultiPartData(
      {required String endUrl,
      required FormData data,
      String? authToken,
      List<File?>? files,
      List<String?>? fileParameters}) async {
    printApiInfo(
      url: _baseUrls.apiBaseUrl() + endUrl,
      payload: data.toString(),
    );
    log(authToken.toString());
    try {
      // initDio();
      final options = Options(
        // contentType: 'application/x-www-form-urlencoded',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        contentType: "multipart/form-data",
      );

      printApiInfo(url: _baseUrls.apiBaseUrl() + endUrl, payload: data.fields);
      printApiInfo(url: _baseUrls.apiBaseUrl() + endUrl, payload: data.files);

      final response = await _dio.post(
        _baseUrls.apiBaseUrl() + endUrl,
        data: data,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      log("error==$e");
      SnackBars.showErrorSnackBar(text: e.toString());
      return null;
    }
  }

  Future<Response?> putMultiPartData(
      {required String endUrl,
      required FormData data,
      String? authToken,
      List<File?>? files,
      List<String?>? fileParameters}) async {
    printApiInfo(
        url: _baseUrls.apiBaseUrl() + endUrl, payload: data.toString());

    try {
      // initDio();
      final options = Options(
        // contentType: 'application/x-www-form-urlencoded',
        headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      printApiInfo(url: _baseUrls.apiBaseUrl() + endUrl, payload: data.fields);
      printApiInfo(url: _baseUrls.apiBaseUrl() + endUrl, payload: data.files);

      final response = await _dio.put(
        _baseUrls.apiBaseUrl() + endUrl,
        data: data,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      log("error==$e");
      SnackBars.showErrorSnackBar(text: e.toString());
      return null;
    }
  }

  Future<Response?> postJsonData(
      {required String endUrl,
      required Map<String, dynamic> data,
      Map<String, String>? headers,
      String? authToken}) async {
    // initDio();

    printApiInfo(
      url: _baseUrls.apiBaseUrl() + endUrl,
      payload: data,
    );
    final options = Options(
      // contentType: 'application/x-www-form-urlencoded',
      headers: {
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );
    try {
      final response = await _dio.post(_baseUrls.apiBaseUrl() + endUrl,
          data: data, options: authToken != null ? options : null);

      return response;
    } on DioException catch (e) {
      log("error response==$e");
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          SnackBars.showErrorSnackBar(text: "You are not registered yet.");
        } else {
          SnackBars.showErrorSnackBar(
            text: " ${e.response?.data['message']}",
          );
        }
      } else {
        SnackBars.showErrorSnackBar(text: " ${e.response?.data['message']}");
      }
      return null;
    }
  }

  Future<Response?> putJsonData(
      {required String endUrl,
      required Map<String, dynamic> data,
      Map<String, String>? headers,
      String? authToken}) async {
    // initDio();
    printApiInfo(
      url: _baseUrls.apiBaseUrl() + endUrl,
      payload: data,
    );
    final options = Options(
      // contentType: 'application/x-www-form-urlencoded',
      headers: {
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );
    try {
      final response = await _dio.put(_baseUrls.apiBaseUrl() + endUrl,
          data: data, options: authToken != null ? options : null);

      return response;
    } on DioException catch (e) {
      log("error response==$e");
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          SnackBars.showErrorSnackBar(text: "You are not registered yet.");
        } else {
          SnackBars.showErrorSnackBar(
            text: " ${e.response?.data['message']}",
          );
        }
      } else {
        SnackBars.showErrorSnackBar(text: " ${e.response?.data['message']}");
      }
      return null;
    }
  }
}

void printApiInfo({url, payload}) {
  log("api hitting----------------");
  log("api url----------------$url");
  log("api payload----------------$payload");
  log("finished api call----------------");
}

class CustomInterceptor extends Interceptor {
  Logger logger = Logger(printer: PrettyPrinter());

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String myErrorMsg = "";

    if (err.error is SocketException) {
      myErrorMsg = "NO INTERNET CONNECTION";
    } else {
      myErrorMsg = await MyDioException.myDioError(err);
    }
    DioException myErr =
        err.copyWith(message: myErrorMsg, response: err.response);

    logger.e(myErr);

    if (myErr.response != null) {
      logger.e(
          "API_Error => ${myErr.response?.statusCode}  ${myErr.requestOptions.uri.toString()}",
          error: myErr);
      if (myErr.response?.data != null) {
        logger.e("API_Error_data => ${jsonEncode(myErr.response?.data)}",
            error: myErr);
      }
    }

    // throw myErrorMsg;
    return super.onError(myErr, handler);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requestPath = options.baseUrl;
    final path = options.path;
    // Automatically assign cancelToken to each request

    if (options.data is FormData) {
      final data = options.data as FormData;
      logger.i(
        "'${options.method} onRequest => $requestPath$path' \nRequest Body=> {${data.fields.map(
              (e) => '"${e.key}":"${e.value}" ',
            ).join(',')}} \n ${data.files.toString()}",
      );
    } else {
      logger.i(
        "'${options.method} onRequest => $requestPath$path' \nRequest Body=> '${jsonEncode(options.data)}'",
      );
    }
    logger.i(
      "",
    );
    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   return super.onResponse(response, handler);
  // }
}

class MyDioException implements Exception {
  static late String errorMessage;

  static Future<String> myDioError(DioException dioError) async {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return errorMessage = 'Request to the server was cancelled.';

      case DioExceptionType.connectionTimeout:
        return errorMessage = 'Connection timed out.';

      case DioExceptionType.receiveTimeout:
        return errorMessage = 'Receiving timeout occurred.';

      case DioExceptionType.sendTimeout:
        return errorMessage = 'Request send timeout.';
      case DioExceptionType.connectionError:
        return errorMessage = 'no internet connection.';

      case DioExceptionType.badResponse:
        return errorMessage = await _handleStatusCode(dioError);

      case DioExceptionType.unknown:
        return errorMessage = 'Unexpected error occurred.';

      default:
        return errorMessage = "Something Went Wrong";
    }
  }

  static Future<String> _handleStatusCode(DioException dioError) async {
    ///Check if not login then logout....

    if (dioError.response != null && dioError.response!.statusCode == 401) {
      /// That means token is invalid or expired
      /// Call logout method
    }

    if (dioError.response!.data != null) {
      if (dioError.response!.data is Map) {
        if (dioError.response!.data['message'] != null) {
          final data = dioError.response!.data;
          return data['message'];
        } else {
          return "Something Went Wrong";
        }
      } else {
        return "Something Went Wrong";
      }
    } else {
      return "Something Went Wrong";
    }
  }

  @override
  String toString() => errorMessage;
}
