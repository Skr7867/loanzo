import 'package:dsa/res/component/round_button.dart';
import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../res/color/app_colors.dart';
import '../../res/fonts/app_fonts.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import '../../viewModels/controllers/CamReport/cam_report_generate_controller.dart';

class CamReportGenerateScreen extends StatelessWidget {
  const CamReportGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.put(CamReportGenerateController());
    final bool isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Generate your CAM Report',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.blackColor : Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, -4), // 👆 top shadow
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6), // 👇 bottom shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      const SizedBox(height: 16),
                      _employmentType(controller),
                      const SizedBox(height: 16),
                      _incomeField(controller),
                      const SizedBox(height: 16),
                      _monthlyExpensesRow(controller),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Obx(() {
                final loading = controller.isLoading.value;

                return RoundButton(
                  loading: loading,
                  buttonColor: AppColors.blueColor,
                  width: 350,
                  title: loading
                      ? 'CAM Report is generating...'
                      : 'Generate CAM Report',
                  onPress: loading ? null : controller.generateCamReport,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.blueColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.description_outlined, color: AppColors.blueColor),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate CAM Report',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Fill customer details to generate comprehensive credit assessment',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= EMPLOYMENT =================

  Widget _employmentType(CamReportGenerateController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Employment Type *'),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: _employmentTile(
                  title: 'Salaried',
                  selected: controller.employmentType.value == 'Salaried',
                  onTap: () => controller.selectEmployment('Salaried'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _employmentTile(
                  title: 'Self-Employed',
                  selected: controller.employmentType.value == 'Self-Employed',
                  onTap: () => controller.selectEmployment('Self-Employed'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _employmentTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.blueColor : AppColors.greyColor,
            width: selected ? 1.5 : 1,
          ),
          color: selected
              ? AppColors.blueColor.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              title == 'Salaried'
                  ? Icons.business_center_outlined
                  : Icons.storefront_outlined,
              color: selected ? AppColors.blueColor : Colors.grey,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.blueColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INCOME =================

  Widget _incomeField(CamReportGenerateController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Monthly Income (₹) *'),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          controller: controller.monthlyIncomeController,
          decoration: InputDecoration(
            hintText: 'Enter monthly income',
            hintStyle: TextStyle(
              color: AppColors.textColor,
              fontFamily: AppFonts.opensansRegular,
            ),
            prefixIcon: const Icon(Icons.currency_rupee),
            helperText: 'Gross monthly income from all sources',
            helperStyle: TextStyle(
              color: AppColors.textColor,
              fontFamily: AppFonts.opensansRegular,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(fontFamily: AppFonts.opensansRegular),
        ),
      ],
    );
  }

  // ================= OBLIGATION =================

  Widget _monthlyExpensesRow(CamReportGenerateController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Monthly Expenses',
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElevatedButton.icon(
              onPressed: controller.addExpense,
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// Expense List
        Obx(() {
          if (controller.expenses.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.greyColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Text(
                    'No Monthly expenses added yet',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Click 'Add Expense' to add your monthly obligations",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              for (int i = 0; i < controller.expenses.length; i++)
                _expenseCard(controller, i),

              /// Total Box
              // Container(
              //   margin: const EdgeInsets.only(top: 16),
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(color: Colors.blue.shade200),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text(
              //         'Total Monthly Expenses',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           color: Colors.blue,
              //         ),
              //       ),
              //       Text(
              //         '₹${controller.expenses.}',

              //         style: const TextStyle(
              //           fontWeight: FontWeight.w600,
              //           color: Colors.blue,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        }),
      ],
    );
  }

  Widget _expenseCard(CamReportGenerateController controller, int index) {
    final expense = controller.expenses[index];

    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense #${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              IconButton(
                onPressed: () => controller.removeExpense(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Expense Type
          const Text('Expense Type', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            dropdownColor: isDark ? AppColors.blackColor : Colors.white,
            value: expense.type,
            decoration: _expenseDecoration(),
            items: const [
              DropdownMenuItem(
                value: 'Rent',
                child: Text(
                  'Rent',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Informal Loan',
                child: Text(
                  'Informal Loan',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Education Fees',
                child: Text(
                  'Education Fees',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Insurance Premium',
                child: Text(
                  'Insurance Premium',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Utilities',
                child: Text(
                  'Utilities',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Other',
                child: Text(
                  'Other',
                  style: TextStyle(
                    fontFamily: AppFonts.opensansRegular,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
            onChanged: (v) {
              expense.type = v!;
              controller.expenses.refresh();
            },
          ),

          /// SHOW ONLY WHEN TYPE == OTHER
          if (expense.type == 'Other') ...[
            const SizedBox(height: 12),
            const Text(
              'Specify Expense',
              style: TextStyle(fontFamily: AppFonts.opensansRegular),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: expense.otherTypeController,
              decoration: _expenseDecoration(hint: 'Enter expense name'),
            ),
          ],

          const SizedBox(height: 12),

          /// Amount
          const Text(
            'Amount (₹)',
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: expense.amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _expenseDecoration(
              hint: 'Enter amount',
              prefix: const Text('₹ '),
            ),
            onChanged: (_) => controller.expenses.refresh(),
          ),

          const SizedBox(height: 12),

          /// Notes
          const Text(
            'Additional Notes (Optional)',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: expense.noteController,
            maxLines: 2,
            decoration: _expenseDecoration(
              hint: 'Any additional details about this expense',
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _expenseDecoration({String? hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: AppFonts.opensansRegular,
        color: AppColors.textColor,
      ),
      prefixIcon: prefix != null
          ? Padding(padding: const EdgeInsets.all(12), child: prefix)
          : null,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  // ================= HELPERS =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.opensansRegular,
      ),
    );
  }
}
