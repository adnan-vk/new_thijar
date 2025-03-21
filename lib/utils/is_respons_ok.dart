import 'package:newthijar/widgets/snackbar/snackbar.dart';

class CheckRStatus {
  static bool _checkIsResponse({required int? statusCode}) {
    if (statusCode == null) {
      return false;
    } else if (statusCode == 201 || statusCode == 200) {
      return true;
    } else if (statusCode >= 300 && statusCode < 400) {
      String message = 'Redirection: $statusCode';
      SnackBars.showErrorSnackBar(text: message);
      return false;
    } else if (statusCode >= 400 && statusCode < 500) {
      String message = 'Client Error: $statusCode';
      SnackBars.showErrorSnackBar(text: message);
      return false;
    } else if (statusCode >= 500 && statusCode < 600) {
      String message = 'Server Error: $statusCode';
      SnackBars.showErrorSnackBar(text: message);
      return false;
    } else {
      String message = 'Unknown Status: $statusCode';
      SnackBars.showErrorSnackBar(text: message);
      return false;
    }
  }

  static checkResStatus({required int? statusCode}) =>
      _checkIsResponse(statusCode: statusCode);
}
