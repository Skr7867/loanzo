import 'dart:io';
import 'package:dsa/res/color/app_colors.dart';
import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../viewModels/controllers/CheckLoanEligibility/check_loan_eligibility_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class CheckEligibilityScreen extends StatelessWidget {
  const CheckEligibilityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckEligibilityController());
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Check Loan Eligibility here ',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 360,
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.blackColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🔵 Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xff1677FF),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Check Customer Loan Eligibility',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fill in details stage - 1 for a real-time eligibility check.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🧾 Form
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      return Column(
                        children: [
                          _label('Loan Amount (₹)'),
                          _textField(
                            controller: controller.loanAmountController,
                            onChanged: (_) => controller.validateForm(),
                            hint: 'e.g. 500000',
                          ),

                          const SizedBox(height: 14),

                          _label('Loan Tenure'),
                          Row(
                            children: [
                              Expanded(
                                child: _textField(
                                  controller: controller.tenureController,
                                  hint: 'Value',
                                ),
                              ),
                              const SizedBox(width: 8),
                              _dropdownBox(
                                child: DropdownButton<String>(
                                  style: TextStyle(
                                    fontFamily: AppFonts.opensansRegular,
                                    color: AppColors.greyColor,
                                  ),
                                  value: controller.selectedTenureUnit.value,
                                  items: ['YEAR', 'MONTH']
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    controller.selectedTenureUnit.value = val!;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          _label('Monthly Income (₹)'),
                          _textField(
                            onChanged: (_) => controller.validateForm(),
                            controller: controller.incomeController,
                            hint: 'Enter monthly income',
                          ),

                          const SizedBox(height: 14),

                          _label('Occupation Type *'),
                          _dropdownBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              style: TextStyle(
                                fontFamily: AppFonts.opensansRegular,
                                color: AppColors.greyColor,
                              ),
                              hint: const Text(
                                'Select Option',
                                style: TextStyle(
                                  fontFamily: AppFonts.opensansRegular,
                                  color: AppColors.greyColor,
                                ),
                              ),
                              value: controller.selectedOccupation.value,
                              items: controller.occupationList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                controller.selectedOccupation.value = val;
                              },
                            ),
                          ),

                          /// 📂 Conditional Documents
                          /// 📂 Conditional Documents
                          /// 📂 Conditional Documents
                          if (controller.isSalaried) ...[
                            const SizedBox(height: 16),
                            _uploadLabel('ITR Document'),

                            Obx(() {
                              final itr = controller.itrFile.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _uploadBox(
                                    file: controller.itrFile,
                                    onTap: () =>
                                        controller.pickFile(controller.itrFile),
                                  ),

                                  if (itr != null) ...[
                                    const SizedBox(height: 10),

                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.green),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.insert_drive_file,
                                            size: 16,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              itr.path.split('/').last,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontFamily:
                                                    AppFonts.opensansRegular,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: controller.removeItrFile,
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }),

                            const SizedBox(height: 12),
                            _uploadLabel('Salary Slips (Min 3 & Max 6)'),
                            _uploadBoxMulti(
                              count: controller.salarySlipFiles.length,
                              onTap: controller.pickSalarySlipsWithProgress,
                            ),

                            const SizedBox(height: 8),

                            /// 📄 Uploaded salary slips list
                            Obx(() {
                              return Column(
                                children: controller.salarySlipFiles.map((
                                  file,
                                ) {
                                  final progress =
                                      controller.salarySlipProgress[file
                                          .path] ??
                                      0.0;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// File name + remove
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.insert_drive_file,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                file.path.split('/').last,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.green,
                                                  fontFamily:
                                                      AppFonts.opensansRegular,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => controller
                                                  .removeSalarySlip(file),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 6),

                                        /// Progress bar
                                        LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 6,
                                          backgroundColor: Colors.grey.shade300,
                                          color: progress == 1.0
                                              ? Colors.green
                                              : Colors.blue,
                                        ),

                                        const SizedBox(height: 4),

                                        /// Status text
                                        Text(
                                          progress == 1.0
                                              ? 'Upload complete'
                                              : 'Uploading ${(progress * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: progress == 1.0
                                                ? Colors.green
                                                : Colors.blue,
                                            fontFamily:
                                                AppFonts.opensansRegular,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ],

                          if (controller.isSelfEmployed) ...[
                            const SizedBox(height: 16),
                            _label('GST Number'),
                            _textField(
                              controller: controller.gstController,
                              hint: 'ENTER GSTIN',
                            ),

                            const SizedBox(height: 14),
                            _uploadLabel('ITR Document'),
                            _uploadBox(
                              file: controller.itrFile,
                              onTap: () =>
                                  controller.pickFile(controller.itrFile),
                            ),

                            const SizedBox(height: 12),
                            _uploadLabel('Business Proof Document'),
                            _uploadBox(
                              file: controller.businessProofFile,
                              onTap: () => controller.pickFile(
                                controller.businessProofFile,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          /// 🔘 Submit Button
                          Obx(() {
                            final enabled = controller.isFormValidRx.value;
                            final isLoading = controller.isSubmitting.value;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: enabled && !isLoading
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xff1677FF),
                                          Color(0xff00B4DB),
                                        ],
                                      )
                                    : null,
                                color: enabled && !isLoading
                                    ? null
                                    : const Color(0xffD9D9D9),
                                boxShadow: enabled && !isLoading
                                    ? [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: enabled && !isLoading
                                      ? controller.submitCheckEligibility
                                      : null,
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 22,

                                            child: Text(
                                              'Eligibility is checking..',
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFonts.opensansRegular,
                                                color: AppColors.greyColor,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'SUBMIT & CHECK ELIGIBILITY',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                  fontFamily:
                                                      AppFonts.opensansRegular,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),

                          const Text(
                            'Complete required fields and document uploads to proceed.',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadBoxMulti({required int count, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: count >= 3 ? Colors.green : AppColors.greyColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              count >= 3 ? Icons.check_circle : Icons.add,
              color: count >= 3 ? Colors.green : AppColors.greyColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                count == 0
                    ? 'Upload Salary Slips (PDF / JPG)'
                    : '$count file(s) uploaded',
                style: TextStyle(
                  color: count >= 3 ? Colors.green : AppColors.greyColor,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.greyColor,
            fontFamily: AppFonts.opensansRegular,
          ),
        ),
      ),
    );
  }

  Widget _uploadBox({required Rx<File?> file, required VoidCallback onTap}) {
    return Obx(() {
      final hasFile = file.value != null;
      return InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasFile ? Colors.green : AppColors.greyColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                hasFile ? Icons.check_circle : Icons.add,
                color: hasFile ? Colors.green : AppColors.greyColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasFile
                      ? file.value!.path.split('/').last
                      : 'Click to upload (PDF / JPG)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: hasFile ? Colors.green : AppColors.greyColor,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 🔹 Helpers
  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.greyColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.opensansRegular,
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: AppFonts.opensansRegular,
          color: AppColors.textColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _dropdownBox({double? width, required Widget child}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }
}
