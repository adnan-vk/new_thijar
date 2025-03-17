import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:newthijar/model/business_model.dart';

class BusinessProfileService {
  final Dio _dio;

  BusinessProfileService(this._dio);

  // Base URL for the API
  static const String _baseUrl = 'https://api.thijar.com/api/';

  // Fetch business profile
  Future<AddBusinesskModel?> fetchBusinessProfile() async {
    try {
      final response = await _dio.get('$_baseUrl/business/profile');
      if (response.statusCode == 200) {
        return AddBusinesskModel.fromJson(response.data);
      }
    } catch (e) {
      log('Error fetching business profile: $e');
    }
    return null;
  }

  // Update business profile
  Future<bool> updateBusinessProfile(AddBusinesskModel businessProfile) async {
    try {
      final response = await _dio.put('$_baseUrl/business/profile',
          data: businessProfile.toJson());
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log('Error updating business profile: $e');
    }
    return false;
  }
}
