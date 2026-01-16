import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/color/app_colors.dart';
import '../../../viewModels/controllers/Stage2Controller/application_preview_controller.dart';
import '../../../viewModels/controllers/Stage2Controller/final_submit_controller.dart'
    show FinalSubmitController;
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class ApplicationPreviewScreen extends StatelessWidget {
  const ApplicationPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String loanRequestId = Get.arguments as String;
    final ApplicationPreviewController previewController = Get.put(
      ApplicationPreviewController(),
    );

    final FinalSubmitController submitController = Get.put(
      FinalSubmitController(),
    );
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: BackButton(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        title: Text(
          'Application Preview',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.back(); // edit application
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
          ),
        ],
      ),

      body: Obx(() {
        final data = previewController.previewResponse.value?.data;

        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final vehicle = data.vehicleInfo;
        final sources = data.downPaymentCapability?.sources ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// ================= Vehicle Information =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.blackColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(Icons.directions_car, 'Vehicle Information'),
                    const SizedBox(height: 12),

                    _infoRow('Vehicle Type', vehicle?.vehicleType ?? '-'),
                    _infoRow('Vehicle Brand', vehicle?.vehicleBrand ?? '-'),
                    _infoRow('Vehicle Model', vehicle?.vehicleModel ?? '-'),
                    _infoRow(
                      'Estimated Price',
                      '₹ ${vehicle?.estimatedPrice ?? 0}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= Down Payment Sources =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.blackColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _sectionHeader(
                          Icons.account_balance_wallet,
                          'Down Payment Sources',
                        ),
                        const Spacer(),
                        _badge('${sources.length} source(s)'),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ...sources.asMap().entries.map((entry) {
                      final index = entry.key;
                      final source = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Source ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                _badge(
                                  '${source.documents?.length ?? 0} doc(s)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _infoRow('Source Type', source.sourceType ?? '-'),
                            _infoRow('Amount', '₹ ${source.amount ?? 0}'),
                            _infoRow('Frequency', source.frequency ?? '-'),
                            _infoRow(
                              'Documents',
                              source.documents?.join(', ') ?? '-',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= F16 Document =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.blackColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(Icons.description, 'F16 Document'),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blackColor
                            : const Color(0xffECFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Color(0xff16A34A),
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              data.f16Document?.split('/').last ?? '-',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xff16A34A),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Uploaded',
                      style: TextStyle(fontSize: 11, color: Color(0xff16A34A)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= Important Notice =================
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.blackColor
                      : const Color(0xffFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffFDE68A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xffD97706)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Important Notice\n'
                        'Review all information carefully before submitting. '
                        'Once submitted, you cannot edit this application.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= Action Button =================
              Obx(() {
                final isSubmitting = submitController.isLoading.value;
                final isSubmitted = submitController.isSubmitted.value;

                return ElevatedButton(
                  onPressed: isSubmitting || isSubmitted
                      ? null
                      : () {
                          // Show confirmation dialog
                          _showConfirmationDialog(
                            context,
                            loanRequestId,
                            submitController,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: isSubmitted
                        ? Colors.green
                        : const Color(0xff2563EB),
                    disabledBackgroundColor: isSubmitted
                        ? Colors.green.withOpacity(0.7)
                        : const Color(0xff2563EB).withOpacity(0.5),
                  ),
                  child: isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Submitting...',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : isSubmitted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Submitted Successfully',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : const Text(
                          'Confirm & Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                );
              }),

              /// Show error message if any
              Obx(() {
                final error = submitController.errorMessage?.value;
                if (error != null && error.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  /// ---------------- Helpers ----------------

  // BoxDecoration _cardDecoration() => BoxDecoration(
  //   color: Colors.white,
  //   borderRadius: BorderRadius.circular(12),
  //   border: Border.all(color: const Color(0xffE6EAF0)),
  // );

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff2563EB), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String loanRequestId,
    FinalSubmitController submitController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Confirm Submission'),
        content: const Text(
          'Are you sure you want to submit this application? '
          'Once submitted, you cannot edit it.',
          style: TextStyle(fontFamily: AppFonts.opensansRegular),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              submitController.submitApplication(loanRequestId: loanRequestId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffEEF2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff2563EB),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
