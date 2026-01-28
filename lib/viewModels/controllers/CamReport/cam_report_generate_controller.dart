import 'dart:developer';
import 'package:dsa/utils/utils.dart';
import 'package:dsa/viewModels/controllers/CamReport/monthly_expenses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/CamReport/cam_report_generate_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../services/user_session_service.dart';
import 'cam_report_controller.dart';

class CamReportGenerateController extends GetxController {
  final CamReportGenerateRepository _repository = CamReportGenerateRepository();
  final UserSessionService _sessionService = UserSessionService();

  /// ================= FORM CONTROLLERS =================

  final TextEditingController monthlyIncomeController = TextEditingController();
  final TextEditingController obligationAmountController =
      TextEditingController();

  /// ================= STATE =================

  RxString employmentType = 'Salaried'.obs;
  RxBool hasObligations = false.obs;
  RxBool isLoading = false.obs;
  late final String userId;
  RxList<MonthlyExpense> expenses = <MonthlyExpense>[].obs;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments;
    log('CAM Generate for userId: $userId');
  }

  @override
  void onClose() {
    monthlyIncomeController.dispose();
    obligationAmountController.dispose();
    super.onClose();
  }

  void addExpense() {
    expenses.add(
      MonthlyExpense(
        amountController: TextEditingController(),
        noteController: TextEditingController(),
      ),
    );
  }

  void removeExpense(int index) {
    expenses[index].dispose();
    expenses.removeAt(index);
  }

  /// ================= UI ACTIONS =================

  void selectEmployment(String type) {
    employmentType.value = type;
  }

  void toggleObligations(bool value) {
    hasObligations.value = value;
    if (!value) {
      obligationAmountController.clear();
    }
  }

  /// ================= API CALL =================

  Future<void> generateCamReport() async {
    if (!_validate()) return;

    final token = _sessionService.token;
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please login again');
      return;
    }

    final payload = {
      'userId': userId,
      'employmentType': employmentType.value,
      'monthlyIncome': monthlyIncomeController.text.trim(),
      'otherObligations': {
        'hasOther': hasObligations.value,
        'amount': hasObligations.value
            ? int.tryParse(obligationAmountController.text.trim()) ?? 0
            : 0,
      },
    };

    log('CAM Generate Payload: $payload');

    try {
      isLoading.value = true;

      final response = await _repository.camReportGenerate(payload, token);

      log('CAM Generate Response: $response');

      if (response != null && response['success'] == true) {
        // Get.snackbar(
        //   'Success',
        //   'CAM Report generated successfully',
        //   snackPosition: SnackPosition.BOTTOM,
        // );

        Utils.snackBar('CAM Report generated successfully', 'Success');
        Get.delete<CamReportController>(force: true);
        Get.offNamed(RouteName.camReportScreen, arguments: userId);
      } else {
        Utils.snackBar(response?['message'], 'Failed');
      }
    } catch (e, s) {
      log('CAM Generate Error', error: e, stackTrace: s);
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= VALIDATION =================

  bool _validate() {
    final income = monthlyIncomeController.text.trim();
    final obligation = obligationAmountController.text.trim();

    // 🔴 Monthly income is mandatory
    if (income.isEmpty) {
      Utils.snackBar('Please enter monthly income', 'Validation');
      return false;
    }

    // 🔵 Obligation amount ONLY if checkbox selected
    if (hasObligations.value) {
      if (obligation.isEmpty) {
        Utils.snackBar('Please enter monthly obligation amount', 'Validation');
        return false;
      }

      if (int.tryParse(obligation) == null) {
        Utils.snackBar(
          'Obligation amount must be a valid number',
          'Validation',
        );
        return false;
      }
    }

    return true;
  }
}
