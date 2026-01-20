import 'dart:convert' show jsonEncode;
import 'dart:developer';

import 'package:dio/dio.dart' show Dio, FormData, MultipartFile, Options;
import 'package:dsa/viewModels/controllers/Stage2Controller/stage_two_controller.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../models/PreviewResponseModel/preview_response_model.dart';
import '../../../res/routes/routes_name.dart';
import '../../services/user_session_service.dart';
import 'application_preview_controller.dart';

class StageTwoApiController extends GetxController {
  final Dio _dio = Dio();
  final UserSessionService _session = UserSessionService();

  RxBool isLoading = false.obs;

  /// ================= SAVE & PREVIEW =================
  Future<void> submitStageTwo({required String loanRequestId}) async {
    final stageTwoController = Get.find<CheckEligibilityController>();
    final previewController = Get.put(ApplicationPreviewController());
    final token = _session.token;

    if (token == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    /// 🔐 VALIDATION
    if (stageTwoController.f16Document.value == null) {
      Get.snackbar('Validation Error', 'F16 document is required');
      return;
    }

    // Improved validation
    for (int i = 0; i < stageTwoController.sources.length; i++) {
      final source = stageTwoController.sources[i];
      if (source.sourceType.value!.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select Source Type for Source ${i + 1}',
        );
        return;
      }
      if (source.amount.value.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter Amount for Source ${i + 1}',
        );
        return;
      }
    }

    try {
      isLoading.value = true; // Start loading

      final formData = FormData();

      /// Vehicle Info
      formData.fields.addAll([
        MapEntry('vehicleType', stageTwoController.vehicleType.value),
        MapEntry('vehicleBrand', stageTwoController.selectedBrand.value),
        MapEntry('vehicleModel', stageTwoController.vehicleModel.value),
        MapEntry(
          'estimatedPrice',
          stageTwoController.estimatedPrice.value
              .replaceAll(',', '')
              .replaceAll('₹', '')
              .trim(),
        ),
      ]);

      /// Bounce Explanations (REQUIRED)
      formData.fields.add(MapEntry('bounceExplanations', jsonEncode([])));

      /// Down Payment Sources (JSON ENCODE)
      final sourcesPayload = stageTwoController.sources.map((source) {
        return {
          "sourceType": source.sourceType.value,
          "customName": "",
          "amount": source.amount.value.replaceAll(',', ''),
          "frequency": source.frequency.value,
        };
      }).toList();

      formData.fields.add(
        MapEntry('downPaymentSources', jsonEncode(sourcesPayload)),
      );

      /// Down Payment Documents
      for (int i = 0; i < stageTwoController.sources.length; i++) {
        final source = stageTwoController.sources[i];
        final file = source.document.value;

        if (file != null && await file.exists()) {
          formData.files.add(
            MapEntry(
              'downPaymentDoc_$i',
              await MultipartFile.fromFile(file.path),
            ),
          );
        }
      }

      /// F16 Document
      formData.files.add(
        MapEntry(
          'f16Document',
          await MultipartFile.fromFile(
            stageTwoController.f16Document.value!.path,
          ),
        ),
      );

      /// API CALL
      final response = await _dio.put(
        'https://dsa-backend-7f4z.onrender.com/api/loanRequest/$loanRequestId/stage2',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final previewModel = PreViewResponseModel.fromJson(response.data);
          previewController.setPreviewData(previewModel);

          Get.toNamed(
            RouteName.applicationPreviewScreen,
            arguments: loanRequestId,
          );
        } catch (e) {
          log('Error parsing response: $e');
          Get.snackbar('Error', 'Failed to process response');
        }
      } else {
        log('Backend Error: ${response.data}');
        Get.snackbar('Error', response.data['message'] ?? 'Invalid request');
      }
    } catch (e) {
      log('Stage2 API Error: $e');
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false; // Stop loading whether success or error
    }
  }
}
