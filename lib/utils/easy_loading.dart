import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void loading({required bool show, String title = "Loading..."}) {
  if (show) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring

      /// custom style

      ///
      ..userInteractions = false
      ..animationStyle = EasyLoadingAnimationStyle.offset
      ..dismissOnTap = kDebugMode;
    EasyLoading.show(
      // maskType: EasyLoadingMaskType.custom,
      status: title,
    );
  } else {
    EasyLoading.dismiss();
  }
}
