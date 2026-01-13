import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/response/status.dart';
import '../../../models/ApplicationLoanDetails/application_loan_details_model.dart';
import '../../../repository/ApplicationDetails/application_details_repository.dart';
import '../../services/user_session_service.dart';

class ApplicationDetailsController extends GetxController {
  final ApplicationDetailsRepository _repository =
      ApplicationDetailsRepository();
  final UserSessionService _sessionService = UserSessionService();

  final status = Status.LOADING.obs;
  final errorMessage = ''.obs;

  final applicationResponse = Rxn<LoanApplicationResponse>();

  LoanApplicationData? get application => applicationResponse.value?.data;

  /// STATUS GETTERS
  bool get isLoading => status.value == Status.LOADING;
  bool get isError => status.value == Status.ERROR;
  bool get isSuccess => status.value == Status.COMPLETED;

  @override
  void onInit() {
    super.onInit();
    final applicationId = Get.arguments;

    debugPrint('📌 ApplicationDetailsController init');
    debugPrint('📌 Application ID: $applicationId');

    _loadApplicationDetails(applicationId);
  }

  Future<void> _loadApplicationDetails(String applicationId) async {
    try {
      status.value = Status.LOADING;
      debugPrint('⏳ Loading application details...');

      final token = _sessionService.token;
      debugPrint('🔐 Token: ${token != null ? "AVAILABLE" : "NULL"}');

      if (token == null || token.isEmpty) {
        throw Exception('User not logged in (token missing)');
      }

      debugPrint('🌐 Calling API...');
      final response = await _repository.loanList(token, applicationId);

      debugPrint('✅ API Response received');
      debugPrint('✅ Success: ${response.success}');
      debugPrint('✅ Application ID: ${response.data.id}');
      debugPrint('📄 Salary Slips Count: ${response.data.salarySlips.length}');
      debugPrint('📄 ITR URL: ${response.data.itr}');

      applicationResponse.value = response;
      status.value = Status.COMPLETED;

      debugPrint('🎉 Application details loaded successfully');
    } catch (e, stackTrace) {
      /// 🔴 LOG EVERYTHING
      errorMessage.value = e.toString();
      status.value = Status.ERROR;

      debugPrint('❌ ERROR while loading application details');
      debugPrint('❌ Error Message: $e');

      /// Stack trace (VERY IMPORTANT)
      debugPrint('❌ Stack Trace:\n$stackTrace');

      /// Also log using Dart developer (visible in DevTools)
      log(
        'ApplicationDetailsController Error',
        error: e,
        stackTrace: stackTrace,
        name: 'ApplicationDetailsController',
      );

      /// GetX log (optional)
      Get.log('❌ ApplicationDetailsController Error: $e');
    }
  }

  Future<void> retry() async {
    final applicationId = Get.arguments;
    debugPrint('🔄 Retry loading application details');
    await _loadApplicationDetails(applicationId);
  }
}
