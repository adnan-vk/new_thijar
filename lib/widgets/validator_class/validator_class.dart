import 'dart:developer';

import 'package:newthijar/widgets/snackbar/snackbar.dart';

class ValidatorClass {
  bool _validateFormKey(formKey) {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    } else {
      return false;
    }
  }

  bool formValidator(formkey) {
    return _validateFormKey(formkey);
  }

  bool validatedUnitForm({String? uName, String? uShortName}) {
    if (uName == null || uName == '') {
      SnackBars.showErrorSnackBar(text: "Please Enter Unit Name");
      return false;
    } else if (uShortName == null || uShortName == '') {
      SnackBars.showErrorSnackBar(text: "Please Enter Unit Short Name");
      return false;
    } else {
      return true;
    }
  }

  bool validatedItemForm(
      {String? iName, String? unit, String? price, String? taxPrecent}) {
    log("Form validator,unit ${unit},price${price}");
    if (iName == null || iName == '') {
      SnackBars.showErrorSnackBar(text: "Please Enter Item Name");
      return false;
    } else if (unit == null || unit == '') {
      SnackBars.showErrorSnackBar(text: "Please select unit");
      return false;
    }
    // else if(taxPrecent == null || taxPrecent==''){
    //        SnackBars.showErrorSnackBar(text: "Please Select Tax Precent");
    //  return false;
    // }
    else if (price == null || price == '') {
      SnackBars.showErrorSnackBar(text: "Please enter price");
      return false;
    } else {
      return true;
    }
  }
}
