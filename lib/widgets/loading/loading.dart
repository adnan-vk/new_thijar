import 'package:flutter/material.dart';
import 'package:get/get.dart';

var isLoading = false.obs;

// void setLoadingValue(value){
//   isLoading.value = value;
// }
void setLoadingValue(value) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    isLoading.value = value;
  });
}
