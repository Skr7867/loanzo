import 'package:dsa/res/component/round_button.dart';
import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:dsa/viewModels/controllers/Stage2Controller/stage_two_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/color/app_colors.dart';
import '../../viewModels/controllers/Stage2Controller/save_and_preview_controller.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import 'widgets/f16_and_summary_section.dart';

class StageTwoScreen extends StatelessWidget {
  StageTwoScreen({super.key});

  final CheckEligibilityController controller = Get.put(
    CheckEligibilityController(),
  );

  @override
  Widget build(BuildContext context) {
    final String? loanRequestId = Get.arguments;
    final StageTwoApiController apiController = Get.put(
      StageTwoApiController(),
    );

    // Responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Stage 2: Additional Details',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              children: [
                // Progress Indicator
                _buildProgressIndicator(isTablet),
                const SizedBox(height: 24),

                // Vehicle Information Section
                _buildVehicleInformationCard(isTablet),
                const SizedBox(height: 20),

                // Down Payment Sources Section
                _buildDownPaymentSourcesCard(context, isTablet),
                const SizedBox(height: 20),

                // F16 and Summary Section
                F16AndSummarySection(
                  onUploadTap: controller.pickF16Document,
                  onSavePreviewTap: () {
                    if (loanRequestId == null) return;
                    apiController.submitStageTwo(loanRequestId: loanRequestId);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Progress Indicator ====================
  Widget _buildProgressIndicator(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2563EB).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2563EB).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Application',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,

                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in the details below to proceed',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey[600],
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Vehicle Information Card ====================
  Widget _buildVehicleInformationCard(bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2563EB).withOpacity(0.08),
                  const Color(0xFF3B82F6).withOpacity(0.03),
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
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vehicle Information',
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
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Required',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Type
                _buildEnhancedLabel(
                  'Vehicle Type',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => _buildEnhancedDropdown(
                    value: controller.vehicleType.value,
                    hint: 'Select Vehicle Type',
                    items: controller.vehicleTypes,
                    icon: Icons.category_outlined,
                    onChanged: (v) {
                      if (v != null) controller.vehicleType.value = v;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Vehicle Brand
                _buildEnhancedLabel(
                  'Vehicle Brand',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => _buildEnhancedDropdown(
                    value: controller.selectedBrand.value.isEmpty
                        ? null
                        : controller.selectedBrand.value,
                    hint: 'Select Brand',
                    items: controller.vehicleBrands,
                    icon: Icons.branding_watermark_outlined,
                    onChanged: (v) => controller.selectedBrand.value = v!,
                  ),
                ),
                const SizedBox(height: 20),

                // Vehicle Model
                _buildEnhancedLabel(
                  'Vehicle Model',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                _buildEnhancedTextField(
                  hint: 'e.g. Swift, Verna',
                  icon: Icons.car_rental_outlined,
                  onChanged: (v) => controller.vehicleModel.value = v,
                ),
                const SizedBox(height: 20),

                // Estimated Price
                _buildEnhancedLabel(
                  'Estimated Price',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                _buildEnhancedTextField(
                  hint: '10,00,000',

                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.estimatedPrice.value = v,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Down Payment Sources Card ====================
  Widget _buildDownPaymentSourcesCard(BuildContext context, bool isTablet) {
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
              color: isDark ? AppColors.blackColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blackColor
                            : const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Down Payment Sources',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      ),
                    ),
                    RoundButton(
                      width: isTablet ? 120 : 100,
                      fontSize: isTablet ? 14 : 13,
                      height: isTablet ? 40 : 35,
                      buttonColor: const Color(0xFF8B5CF6),
                      title: 'Add Source',
                      onPress: controller.addSource,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Total Amount Display
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.blackColor
                          : const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 18,
                              color: const Color(0xFF8B5CF6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Down Payment',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 13,
                                fontWeight: FontWeight.w600,

                                fontFamily: AppFonts.opensansRegular,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${controller.totalDownPayment}',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B5CF6),
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sources List
          Padding(
            padding: EdgeInsets.all(isTablet ? 24 : 20),
            child: Obx(
              () => controller.sources.isEmpty
                  ? _buildEmptySourcesState()
                  : Column(
                      children: List.generate(controller.sources.length, (
                        index,
                      ) {
                        final source = controller.sources[index];
                        return _buildSourceCard(source, index, isTablet);
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Empty Sources State ====================
  Widget _buildEmptySourcesState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No payment sources added yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Click "Add Source" to get started',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Individual Source Card ====================
  Widget _buildSourceCard(dynamic source, int index, bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25))],
      ),
      child: Column(
        children: [
          // Source Header
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black
                  : const Color(0xFF8B5CF6).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),

              border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Payment Source ${index + 1}',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ),
                if (controller.sources.length > 1)
                  IconButton(
                    onPressed: () => controller.removeSource(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 22,
                    ),
                    tooltip: 'Remove Source',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),

          // Source Fields
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source Type
                _buildEnhancedLabel(
                  'Source Type',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => _buildEnhancedDropdown(
                    hint: 'Select Type',
                    value: source.sourceType.value,
                    items: controller.sourceTypes,
                    icon: Icons.source_outlined,
                    onChanged: (v) => source.sourceType.value = v,
                  ),
                ),

                const SizedBox(height: 16),

                // Amount
                _buildEnhancedLabel(
                  'Amount',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                _buildEnhancedTextField(
                  hint: '50,000',

                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => source.amount.value = v,
                ),
                const SizedBox(height: 16),

                // Frequency
                _buildEnhancedLabel(
                  'Frequency',
                  isRequired: true,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => _buildEnhancedDropdown(
                    value: source.frequency.value,
                    hint: 'Monthly',
                    items: controller.frequencies,
                    icon: Icons.schedule_outlined,
                    onChanged: (v) => source.frequency.value = v!,
                  ),
                ),
                const SizedBox(height: 16),

                // Documents Upload
                _buildEnhancedLabel(
                  'Documents',
                  isRequired: false,
                  isTablet: isTablet,
                ),
                const SizedBox(height: 8),
                _buildDocumentUploadButton(source, index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Document Upload Button ====================
  Widget _buildDocumentUploadButton(dynamic source, int index) {
    return Obx(() {
      final file = source.document.value;

      if (file == null) {
        return OutlinedButton.icon(
          onPressed: () => controller.pickSourceDocument(index),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            side: BorderSide(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(
            Icons.cloud_upload_outlined,
            size: 20,
            color: Color(0xFF8B5CF6),
          ),
          label: const Text(
            'Upload Documents',
            style: TextStyle(
              fontFamily: AppFonts.opensansRegular,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B5CF6),
            ),
          ),
        );
      }

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
                Icons.description,
                size: 16,
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
                    'Document uploaded',
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
              onPressed: () => controller.removeSourceDocument(index),
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xFFEF4444),
              ),
              tooltip: 'Remove Document',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    });
  }

  // ==================== Enhanced Label ====================
  Widget _buildEnhancedLabel(
    String text, {
    required bool isRequired,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.opensansRegular,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== Enhanced Dropdown ====================
  Widget _buildEnhancedDropdown({
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? value,
  }) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? AppColors.blackColor : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
        ],
      ),
      child: DropdownButtonFormField<String?>(
        dropdownColor: isDark ? AppColors.blackColor : Colors.white,
        value: value,
        style: TextStyle(
          fontFamily: AppFonts.opensansRegular,
          fontSize: 14,
          color: value != null
              ? (isDark ? Colors.white : Colors.black)
              : Colors.grey,
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<String?>(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: isDark ? Colors.white : const Color(0xFF64748B),
        ),
        decoration: InputDecoration(
          hintText: hint,
          // hintStyle: TextStyle(
          //   fontFamily: AppFonts.opensansRegular,
          //   color: AppColors.textColor,
          //   fontSize: 14,
          // ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF64748B),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ==================== Enhanced TextField ====================
  Widget _buildEnhancedTextField({
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    String? prefix,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(
          fontFamily: AppFonts.opensansRegular,
          fontSize: 14,
          // color: Color(0xFF1E293B),
        ),
        onChanged: onChanged,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefix,
          hintStyle: TextStyle(
            fontFamily: AppFonts.opensansRegular,
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixStyle: const TextStyle(
            fontFamily: AppFonts.opensansRegular,
            fontSize: 14,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.greyColor.withOpacity(0.4),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.greyColor.withOpacity(0.4),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
