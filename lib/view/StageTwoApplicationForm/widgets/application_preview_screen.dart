import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    // Responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff121212)
          : const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Application Preview',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.opensansRegular,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                Get.back(); // edit application
              },
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: const Color(0xff2563EB),
              ),
              label: Text(
                'Edit',
                style: TextStyle(
                  color: const Color(0xff2563EB),
                  fontFamily: AppFonts.opensansRegular,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff2563EB).withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        final data = previewController.previewResponse.value?.data;

        if (data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xff2563EB),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading preview...',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        final vehicle = data.vehicleInfo;
        final sources = data.downPaymentCapability?.sources ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          child: Column(
            children: [
              /// ================= Progress Indicator =================
              _buildProgressIndicator(),

              const SizedBox(height: 24),

              /// ================= Vehicle Information =================
              _buildCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      Icons.directions_car_outlined,
                      'Vehicle Information',
                      const Color(0xff2563EB),
                    ),
                    const SizedBox(height: 20),

                    _buildInfoGrid([
                      _InfoItem(
                        'Vehicle Type',
                        vehicle?.vehicleType ?? '-',
                        Icons.category_outlined,
                      ),
                      _InfoItem(
                        'Vehicle Brand',
                        vehicle?.vehicleBrand ?? '-',
                        Icons.branding_watermark_outlined,
                      ),
                      _InfoItem(
                        'Vehicle Model',
                        vehicle?.vehicleModel ?? '-',
                        Icons.model_training_outlined,
                      ),
                      _InfoItem(
                        'Estimated Price',
                        '₹ ${_formatAmount(vehicle?.estimatedPrice ?? 0)}',
                        Icons.currency_rupee,
                      ),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= Down Payment Sources =================
              _buildCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _sectionHeader(
                            Icons.account_balance_wallet_outlined,
                            'Down Payment Sources',
                            const Color(0xff10B981),
                          ),
                        ),
                        _badge(
                          '${sources.length} source(s)',
                          const Color(0xff10B981),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (sources.isEmpty)
                      _buildEmptyState('No payment sources added yet')
                    else
                      ...sources.asMap().entries.map((entry) {
                        final index = entry.key;
                        final source = entry.value;

                        return Container(
                          margin: EdgeInsets.only(
                            bottom: index == sources.length - 1 ? 0 : 16,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff10B981).withOpacity(0.05),
                                const Color(0xff10B981).withOpacity(0.02),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xff10B981).withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xff10B981,
                                      ).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppFonts.opensansRegular,
                                        color: const Color(0xff10B981),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Source ${index + 1}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppFonts.opensansRegular,
                                      ),
                                    ),
                                  ),
                                  _badge(
                                    '${source.documents?.length ?? 0} doc(s)',
                                    const Color(0xff8B5CF6),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              _infoRow(
                                'Source Type',
                                source.sourceType ?? '-',
                                Icons.source_outlined,
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                'Amount',
                                '₹ ${_formatAmount(source.amount ?? 0)}',
                                Icons.account_balance_outlined,
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                'Frequency',
                                source.frequency ?? '-',
                                Icons.schedule_outlined,
                              ),
                              const SizedBox(height: 12),
                              _infoRow(
                                'Documents',
                                source.documents?.join(', ') ?? '-',
                                Icons.insert_drive_file_outlined,
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
              _buildCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      Icons.description_outlined,
                      'F16 Document',
                      const Color(0xffF59E0B),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff16A34A).withOpacity(0.08),
                            const Color(0xff16A34A).withOpacity(0.03),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xff16A34A).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xff16A34A).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Color(0xff16A34A),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.f16Document?.split('/').last ??
                                      'No document',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.opensansRegular,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: const Color(0xff16A34A),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Uploaded Successfully',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: const Color(0xff16A34A),
                                        fontFamily: AppFonts.opensansRegular,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= Important Notice =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffFEF3C7).withOpacity(isDark ? 0.3 : 1),
                      const Color(0xffFDE68A).withOpacity(isDark ? 0.2 : 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xffF59E0B).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffF59E0B).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: const Color(0xffD97706),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important Notice',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.opensansRegular,
                              color: const Color(0xffD97706),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Review all information carefully before submitting. Once submitted, you cannot edit this application.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: AppFonts.opensansRegular,
                              color: isDark
                                  ? Colors.white.withOpacity(0.8)
                                  : const Color(0xff78716C),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ================= Action Button =================
              Obx(() {
                final isSubmitting = submitController.isLoading.value;
                final isSubmitted = submitController.isSubmitted.value;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSubmitting || isSubmitted
                        ? []
                        : [
                            BoxShadow(
                              color: const Color(0xff2563EB).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: isSubmitting || isSubmitted
                        ? null
                        : () {
                            _showConfirmationDialog(
                              context,
                              loanRequestId,
                              submitController,
                              isDark,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: isSubmitted
                          ? const Color(0xff16A34A)
                          : const Color(0xff2563EB),
                      disabledBackgroundColor: isSubmitted
                          ? const Color(0xff16A34A).withOpacity(0.7)
                          : const Color(0xff2563EB).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Submitting...',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.opensansRegular,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          )
                        : isSubmitted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, size: 22),
                              const SizedBox(width: 10),
                              Text(
                                'Submitted Successfully',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.opensansRegular,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Confirm & Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.opensansRegular,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                );
              }),

              /// Show error message if any
              Obx(() {
                final error = submitController.errorMessage?.value;
                if (error != null && error.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontFamily: AppFonts.opensansRegular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  /// ---------------- Helper Widgets ----------------

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xff2563EB).withOpacity(0.1),
            const Color(0xff3B82F6).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff2563EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.preview_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Stage',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.opensansRegular,
                    color: const Color(0xff2563EB),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Almost there! Review your application',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: AppFonts.opensansRegular,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.opensansRegular,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(List<_InfoItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;

        if (isWide) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) {
              return SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: _infoRow(item.label, item.value, item.icon),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: items.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: item == items.last ? 0 : 12),
                child: _infoRow(item.label, item.value, item.icon),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: AppFonts.opensansRegular,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String loanRequestId,
    FinalSubmitController submitController,
    bool isDark,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffEF4444).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: const Color(0xffEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Confirm Submission',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to submit this application? Once submitted, you cannot edit it.',
          style: TextStyle(
            fontFamily: AppFonts.opensansRegular,
            fontSize: 14,
            height: 1.5,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              submitController.submitApplication(loanRequestId: loanRequestId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.opensansRegular,
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final numAmount = amount is String ? double.tryParse(amount) ?? 0 : amount;
    if (numAmount >= 10000000) {
      return '${(numAmount / 10000000).toStringAsFixed(2)} Cr';
    } else if (numAmount >= 100000) {
      return '${(numAmount / 100000).toStringAsFixed(2)} L';
    } else if (numAmount >= 1000) {
      return '${(numAmount / 1000).toStringAsFixed(2)} K';
    }
    return numAmount.toStringAsFixed(0);
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;

  _InfoItem(this.label, this.value, this.icon);
}
