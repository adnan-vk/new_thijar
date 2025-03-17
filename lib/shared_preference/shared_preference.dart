import 'package:logger/logger.dart';
import 'package:newthijar/constants/shared_preference_const.dart';
import 'package:newthijar/model/credential_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreLocalStorage {
  static const String _itemNameListKey = "itemListKey";
  static late SharedPreferences _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setCredential(CredentialModel model) async {
    await _preferences.setString(
        SharedPreferenceConst.accessToken, model.token);
    await _preferences.setString(
        SharedPreferenceConst.phonNumber, model.phoneNo);
    await _preferences.setString(SharedPreferenceConst.userId, model.userId);
  }

  static Future<CredentialModel> getCredential() async {
    String? token = _preferences.getString(SharedPreferenceConst.accessToken);
    String? phone = _preferences.getString(SharedPreferenceConst.phonNumber);
    String? userId = _preferences.getString(SharedPreferenceConst.userId);

    return CredentialModel(
        token: token ?? '', userId: userId ?? '', phoneNo: phone ?? '');
  }

  static Future<void> setToken(String token) async {
    await _preferences.setString(SharedPreferenceConst.accessToken, token);
  }

  static Future<String> getToken() async {
    CredentialModel model = await getCredential();
    Logger logger = Logger();
    logger.i(model.toString());
    return model.token.toString();
  }

  static Future<String> getPhoneNumber() async {
    CredentialModel model = await getCredential();
    return model.phoneNo.toString();
  }

  static clear() async {
    await _preferences.clear();
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('phoneNo');
  }

  static Future<void> setItemList(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_itemNameListKey, value);
  }

  static Future<List<String>> getItemList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_itemNameListKey) ?? [];
  }

  static Future<void> addStringToItemList(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_itemNameListKey) ?? [];
    // currentList.add(value);
    // await prefs.setStringList(_itemNameListKey, currentList);
    if (!currentList.contains(value)) {
      currentList.add(value);
      await prefs.setStringList(_itemNameListKey, currentList);
    }
  }
}
