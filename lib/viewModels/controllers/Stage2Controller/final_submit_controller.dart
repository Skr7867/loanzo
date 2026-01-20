import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dsa/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/user_session_service.dart';

class FinalSubmitController extends GetxController {
  final Dio _dio = Dio();
  final UserSessionService _session = UserSessionService();

  RxBool isLoading = false.obs;
  RxBool isSubmitted = false.obs;
  RxString? errorMessage = RxString('');

  /// ================= FINAL SUBMIT =================
  Future<void> submitApplication({required String loanRequestId}) async {
    final token = _session.token;

    if (token == null) {
      errorMessage?.value = 'User not authenticated';
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage?.value = '';

      log('Making final submit API call for loan request: $loanRequestId');

      final response = await _dio.post(
        'https://dsa-backend-7f4z.onrender.com/api/loanRequest/$loanRequestId/submit',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Final Submit Response Status: ${response.statusCode}');
      log('Final Submit Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSubmitted.value = true;

        // Check if submission was successful
        if (response.data['success'] == true) {
          Get.snackbar(
            'Success',
            response.data['message'] ?? 'Application submitted successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to success screen or next step
          Get.offAllNamed(
            RouteName.applicationDetailsScreen,
            arguments: loanRequestId,
          );
        } else {
          errorMessage?.value = response.data['message'] ?? 'Submission failed';
          Get.snackbar('Error', errorMessage!.value);
        }
      } else {
        errorMessage?.value = response.data['message'] ?? 'Submission failed';
        Get.snackbar('Error', errorMessage!.value);
      }
    } catch (e, stackTrace) {
      log('Final Submit API Error: $e');
      log('Stack Trace: $stackTrace');
      errorMessage!.value = 'Something went wrong. Please try again.';
      Get.snackbar('Error', errorMessage!.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset submission state
  void reset() {
    isSubmitted.value = false;
    errorMessage!.value = '';
  }
}
