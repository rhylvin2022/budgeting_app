import 'dart:async';

import 'package:base_code/global/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:swagger/api.dart';

///Created by: Rhylvin May 2023
class SampleRepository {
  String tag = "SampleRepository -> ";
  ApiClient apiClient = ApiClient();

  ///CTBC
  ///Get SampleRepository Request
  Future<SampleRepositoryResponse> getSampleRepositoryRequest() async {
    // String token = await StorageHelper().getSecureData(AppStrings.TOKEN);
    final getSampleRepository = GetSampleRepositoryAPI(apiClient);

    try {
      final response = await getSampleRepository.getSampleRepository(
          // request,
          // AppStrings.CLIENT_ID,
          // AppStrings.CLIENT_SECRET,
          // token,
          );
      return response;
    } on TimeoutException catch (_) {
      throw (AppStrings.timedOutResponse);
    } on Exception catch (error) {
      debugPrint(tag + "get SampleRepository  >> " + error.toString());
      rethrow;
    }
  }
}
