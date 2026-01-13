import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dsa/res/routes/routes_name.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/api_urls/api_urls.dart';
import '../../services/user_session_service.dart';
import '../CibilScore/cibil_score_controller.dart';

class CheckEligibilityController extends GetxController {
  late final String userId;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null || args.toString().isEmpty) {
      Get.snackbar('Error', 'User ID not received');
      return;
    }

    userId = args.toString();

    debugPrint('✅ CheckEligibilityController userId: $userId');
  }

  /// Text Controllers
  final loanAmountController = TextEditingController();
  final tenureController = TextEditingController();
  final incomeController = TextEditingController();
  final gstController = TextEditingController();

  /// Dropdown
  final selectedOccupation = RxnString();
  final selectedTenureUnit = 'YEAR'.obs;
  final isSubmitting = false.obs;

  /// Occupation list
  final occupationList = ['Salaried', 'Self Employed'];

  /// Picked files
  final itrFile = Rx<File?>(null);
  final salarySlipFiles = <File>[].obs;
  final salarySlipProgress = <String, double>{}.obs;
  final isFormValidRx = false.obs;
  final businessProofFile = Rx<File?>(null);

  /// Helpers
  bool get isSalaried => selectedOccupation.value == 'Salaried';
  bool get isSelfEmployed => selectedOccupation.value == 'Self Employed';

  // final _repository = CheckEligibilityRepository();
  final _session = UserSessionService();

  Future<void> submitCheckEligibility() async {
    if (isSubmitting.value) return; // prevent double tap

    isSubmitting.value = true; // ✅ START LOADING

    try {
      final token = _session.token;
      if (token == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final cibilController = Get.find<UserCibilScoreController>();
      final clientUserId =
          cibilController.cibilScore.value?.report?.userId?.sId;

      if (clientUserId == null) {
        Get.snackbar('Error', 'Client user id not found');
        return;
      }

      final int tenureValue = int.parse(tenureController.text);
      final int tenureMonths = selectedTenureUnit.value == 'YEAR'
          ? tenureValue * 12
          : tenureValue;

      final formData = dio.FormData();

      formData.fields.addAll([
        MapEntry('clientUserId', clientUserId),
        MapEntry('loanAmount', loanAmountController.text),
        MapEntry('loanTenureMonths', tenureMonths.toString()),
        MapEntry('occupation', selectedOccupation.value!),
        MapEntry('monthlyIncome', incomeController.text),
      ]);

      if (itrFile.value != null) {
        formData.files.add(
          MapEntry(
            'itr',
            await dio.MultipartFile.fromFile(
              itrFile.value!.path,
              filename: itrFile.value!.path.split('/').last,
            ),
          ),
        );
      }

      for (final file in salarySlipFiles) {
        formData.files.add(
          MapEntry(
            'salarySlips',
            await dio.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      final dioClient = dio.Dio();
      dioClient.options.headers['Authorization'] = 'Bearer $token';

      final response = await dioClient.post(
        ApiUrls.checkLoanEligibilityStage1Api,
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = (sent / total * 100).toInt();
            log('📤 Upload progress: $progress%');
          }
        },
      );

      Get.snackbar(
        'Success',
        'Eligibility request submitted successfully',
        snackPosition: SnackPosition.TOP,
      );

      final applicationId = response.data?['data']?['loanRequestId'];
      Get.toNamed(RouteName.applicationDetailsScreen, arguments: applicationId);
      Get.delete<CheckEligibilityController>();

      log('✅ API RESPONSE: ${response.data}');
    } catch (e, st) {
      log('❌ Submit eligibility error', error: e, stackTrace: st);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
      log('this is error when i submit and ${e.toString()}');
    } finally {
      isSubmitting.value = false; // ✅ STOP LOADING
    }
  }

  void removeSalarySlip(File file) {
    salarySlipFiles.remove(file);
    salarySlipProgress.remove(file.path);
    validateForm();
  }

  void validateForm() {
    bool valid = true;

    if (loanAmountController.text.isEmpty ||
        tenureController.text.isEmpty ||
        incomeController.text.isEmpty ||
        selectedOccupation.value == null) {
      valid = false;
    } else if (isSalaried) {
      valid =
          itrFile.value != null &&
          salarySlipFiles.length >= 3 &&
          areAllSalarySlipsUploaded;
    } else if (isSelfEmployed) {
      valid =
          itrFile.value != null &&
          businessProofFile.value != null &&
          gstController.text.isNotEmpty;
    }

    isFormValidRx.value = valid;
  }

  bool get areAllSalarySlipsUploaded {
    if (salarySlipFiles.isEmpty) return false;

    return salarySlipFiles.every((file) {
      return salarySlipProgress[file.path] == 1.0;
    });
  }

  Future<void> pickSalarySlipsWithProgress() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.path == null) continue;

      final f = File(file.path!);
      salarySlipFiles.add(f);
      salarySlipProgress[f.path] = 0.0;
      validateForm();
      _simulateUpload(f);
    }
  }

  void _simulateUpload(File file) async {
    final path = file.path;

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      salarySlipProgress[path] = i / 10;
      salarySlipProgress.refresh();
      validateForm();
    }
  }

  Future<void> pickSalarySlips() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      salarySlipFiles.addAll(
        result.files.where((e) => e.path != null).map((e) => File(e.path!)),
      );

      Get.snackbar(
        'Uploaded',
        '${salarySlipFiles.length} salary slips uploaded',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// File Picker (PDF/JPG/PNG)
  Future<void> pickFile(Rx<File?> targetFile) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      targetFile.value = File(result.files.single.path!);
      validateForm();
      Get.snackbar(
        'Upload Successful',
        result.files.single.name,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Validation
  bool get isFormValid {
    if (loanAmountController.text.isEmpty ||
        tenureController.text.isEmpty ||
        incomeController.text.isEmpty ||
        selectedOccupation.value == null) {
      return false;
    }

    if (isSalaried) {
      return itrFile.value != null &&
          salarySlipFiles.length >= 3 &&
          areAllSalarySlipsUploaded;
    }

    if (isSelfEmployed) {
      return itrFile.value != null &&
          businessProofFile.value != null &&
          gstController.text.isNotEmpty;
    }

    return false;
  }

  @override
  void onClose() {
    loanAmountController.dispose();
    tenureController.dispose();
    incomeController.dispose();
    gstController.dispose();
    super.onClose();
  }
}
