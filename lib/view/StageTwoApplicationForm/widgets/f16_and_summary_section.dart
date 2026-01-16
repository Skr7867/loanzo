import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:dsa/viewModels/controllers/Stage2Controller/stage_two_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ApplicationLoanDetails/application_loan_details_model.dart';
import '../../../res/color/app_colors.dart';
import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';
import '../../../viewModels/controllers/Stage2Controller/save_and_preview_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class F16AndSummarySection extends StatelessWidget {
  final VoidCallback onUploadTap;
  final VoidCallback onSavePreviewTap;

  const F16AndSummarySection({
    super.key,
    required this.onUploadTap,
    required this.onSavePreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final StageTwoApiController apiController =
        Get.find<StageTwoApiController>();

    final ApplicationDetailsController appController =
        Get.find<ApplicationDetailsController>();

    final LoanApplicationData app = appController.application!;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        // F16 Document Upload Section
        _buildF16DocumentCard(isTablet),
        const SizedBox(height: 20),

        // Save & Preview Button
        _buildSavePreviewButton(apiController, isTablet),
        const SizedBox(height: 20),

        // Basic Details Section
        _buildBasicDetailsCard(isTablet, app),
        const SizedBox(height: 20),

        // Quick Tips Section
        _buildQuickTipsCard(isTablet),
        const SizedBox(height: 30),
      ],
    );
  }

  // ==================== F16 Document Card ====================
  Widget _buildF16DocumentCard(bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEF4444).withOpacity(0.08),
                  const Color(0xFFF87171).withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'F16 Document',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, color: Color(0xFFEF4444), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Required',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Upload Area
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Column(
              children: [
                _buildUploadArea(isTablet),
                const SizedBox(height: 16),
                _buildInfoNotice(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Upload Area ====================
  Widget _buildUploadArea(bool isTablet) {
    final controller = Get.find<CheckEligibilityController>();

    return Obx(() {
      final file = controller.f16Document.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2563EB).withOpacity(0.03),
              const Color(0xFF3B82F6).withOpacity(0.01),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2563EB).withOpacity(0.2),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            // Icon with animation-ready container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Upload F16 Document',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              'PDF format only • Maximum 10MB',
              style: TextStyle(
                fontSize: isTablet ? 13 : 12,
                color: Colors.grey[600],
                fontFamily: AppFonts.opensansRegular,
              ),
            ),

            // File display if uploaded
            if (file != null) ...[
              const SizedBox(height: 16),
              _buildUploadedFile(file),
            ],

            const SizedBox(height: 20),

            // Upload Button
            ElevatedButton.icon(
              onPressed: onUploadTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.upload_file, size: 20),
              label: Text(
                file != null ? 'Change PDF File' : 'Choose PDF File',
                style: TextStyle(
                  fontSize: isTablet ? 15 : 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==================== Uploaded File Display ====================
  Widget _buildUploadedFile(dynamic file) {
    final controller = Get.find<CheckEligibilityController>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.path.split('/').last,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                    fontFamily: AppFonts.opensansRegular,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'PDF uploaded successfully',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF059669),
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.removeF16Document,
            icon: const Icon(
              Icons.close_rounded,
              size: 20,
              color: Color(0xFFEF4444),
            ),
            tooltip: 'Remove File',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ==================== Info Notice ====================
  Widget _buildInfoNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: const Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'All fields marked with * are required to proceed',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFD97706),
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Save & Preview Button ====================
  Widget _buildSavePreviewButton(
    StageTwoApiController apiController,
    bool isTablet,
  ) {
    return Obx(() {
      final isLoading = apiController.isLoading.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onSavePreviewTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.5),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Processing...',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.opensansRegular,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Save & Preview',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.opensansRegular,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  // ==================== Basic Details Card ====================
  Widget _buildBasicDetailsCard(bool isTablet, LoanApplicationData app) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF06B6D4).withOpacity(0.08),
                  const Color(0xFF22D3EE).withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Basic Details (Stage 1)',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0891B2),
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Content
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Column(
              children: [
                _buildDetailRow(
                  'Loan Amount',
                  '₹${app.loanAmount}',
                  Icons.currency_rupee,
                  const Color(0xFF06B6D4),
                  app,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Monthly Income',
                  '₹${app.monthlyIncome}',
                  Icons.account_balance_wallet_outlined,
                  const Color(0xFF10B981),
                  app,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Occupation',
                  '${app.occupation}',
                  Icons.work_outline,
                  const Color(0xFF8B5CF6),
                  app,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Bounces to explain',
                  '${app.businessProof}',
                  Icons.description_outlined,
                  const Color(0xFFF59E0B),
                  app,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Detail Row ====================
  Widget _buildDetailRow(
    String title,
    String value,
    IconData icon,
    Color color,
    LoanApplicationData app,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.opensansRegular,

                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.opensansRegular,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Divider ====================
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(color: AppColors.greyColor.withOpacity(0.4), height: 1),
    );
  }

  // ==================== Quick Tips Card ====================
  Widget _buildQuickTipsCard(bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.08),
                  const Color(0xFF34D399).withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Tips',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ],
            ),
          ),

          // Tips Content
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Column(
              children: [
                _buildTipItem(
                  'Provide detailed explanations (minimum 20 characters)',
                  Icons.description_outlined,
                ),
                const SizedBox(height: 14),
                _buildTipItem(
                  'Upload clear supporting documents for income sources',
                  Icons.upload_file_outlined,
                ),
                const SizedBox(height: 14),
                _buildTipItem(
                  'Ensure F16 document is valid and readable',
                  Icons.verified_outlined,
                ),
                const SizedBox(height: 14),
                _buildTipItem(
                  'All data is encrypted and secure',
                  Icons.security_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Tip Item ====================
  Widget _buildTipItem(String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF10B981)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFonts.opensansRegular,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
