import 'package:dsa/res/color/app_colors.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ApplicationLoanDetails/application_loan_details_model.dart';
import '../../../res/enum/enum.dart';
import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';
import 'document_widgets.dart';
import 'existing_loan_widgets.dart';
import 'financial_tab_widget.dart';
import 'payment_history_widgets.dart';

class LoanTabsSection extends StatefulWidget {
  const LoanTabsSection({super.key});

  @override
  State<LoanTabsSection> createState() => _LoanTabsSectionState();
}

class _LoanTabsSectionState extends State<LoanTabsSection> {
  LoanTab selectedTab = LoanTab.overview;
  final controller = Get.find<ApplicationDetailsController>();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 TABS CONTAINER
        Container(
          padding: const EdgeInsets.all(6),
          margin: EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blackColor : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _tabItem(
                  icon: Icons.remove_red_eye_outlined,
                  title: 'Overview',
                  tab: LoanTab.overview,
                ),
                _tabItem(
                  icon: Icons.currency_rupee,
                  title: 'Financials',
                  tab: LoanTab.financials,
                ),
                _tabItem(
                  icon: Icons.receipt_long,
                  title: 'Payment History',
                  tab: LoanTab.paymentHistory,
                ),
                _tabItem(
                  icon: Icons.bar_chart,
                  title: 'Existing Loans',
                  tab: LoanTab.existingLoans,
                ),
                _tabItem(
                  icon: Icons.description_outlined,
                  title: 'Documents',
                  tab: LoanTab.documents,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// 🔹 TAB CONTENT
        _buildTabContent(),
      ],
    );
  }

  /// 🔹 Single Tab Widget
  Widget _tabItem({
    required IconData icon,
    required String title,
    required LoanTab tab,
  }) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    final bool isSelected = selectedTab == tab;

    // 🎯 Background color logic
    final Color backgroundColor = isSelected
        ? const Color(0xff1677FF)
        : isDark
        ? Colors
              .black // Dark theme unselected
        : Colors.white; // Light theme unselected

    // 🎯 Text & icon color logic
    final Color contentColor = isSelected
        ? Colors.white
        : isDark
        ? Colors.white
        : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xff1677FF) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: contentColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: contentColor,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Content based on selected tab
  Widget _buildTabContent() {
    switch (selectedTab) {
      case LoanTab.overview:
        return _contentBox();

      case LoanTab.financials:
        return FinancialTabScreen();

      case LoanTab.paymentHistory:
        return PaymentHistoryWidget();

      case LoanTab.existingLoans:
        return ExistingLoanWidgets();

      case LoanTab.documents:
        return DocumentsWidgets();
    }
  }

  /// 🔹 Placeholder Content Box
  Widget _contentBox() {
    final app = controller.application!;
    final dti = app.dtiCalculation;
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Column(
      children: [
        /// 🔹 LOAN CALCULATION
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blackColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 20,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Loan Calculation Analysis',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// INFO NOTE
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.blackColor
                      : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Calculations based on Stage 1 data.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// METRICS
              _metricCard(
                title: 'Max Eligible Loan Amount',
                value: '₹${dti.maxEligibleLoanAmount}',
                valueColor: Colors.blue,
                icon: Icons.currency_rupee,
                iconBg: const Color(0xFFE3F2FD),
              ),

              _metricCard(
                title: 'Available EMI Capacity',
                value: '₹${dti.availableEMICapacity}',
                valueColor: Colors.green,
                icon: Icons.trending_up,
                iconBg: const Color(0xFFE8F5E9),
              ),

              _metricCard(
                title: 'Current EMI Commitments',
                value: '₹${dti.currentEMICommitments}',
                valueColor: Colors.red,
                icon: Icons.remove_circle_outline,
                iconBg: const Color(0xFFFFEBEE),
              ),

              _metricCard(
                title: 'Available for EMI',
                value: '₹${dti.availableForEMI}',
                valueColor: Colors.deepPurple,
                icon: Icons.calendar_month,
                iconBg: const Color(0xFFF3E5F5),
              ),
            ],
          ),
        ),

        /// 🔹 CUSTOMER INFO
        _customerInformationCard(app),

        /// 🔹 LOAN REQUEST + TIMELINE
        loanRequestAndTimelineCard(app),
      ],
    );
  }

  Widget loanRequestAndTimelineCard(LoanApplicationData app) {
    final status = app.applicationStatus;
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blackColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
            ],
          ),
          child: Column(
            children: [
              _loanRow(
                icon: Icons.currency_rupee,
                label: 'Requested Amount',
                value: '₹${app.loanAmount}',
                valueColor: Colors.blue,
              ),

              _loanRow(
                icon: Icons.calendar_today,
                label: 'Tenure',
                value: '${app.loanTenureMonths} months',
              ),

              _loanRow(
                icon: Icons.percent,
                label: 'DTI Ratio',
                value: '${app.dtiCalculation.debtToIncomeRatio}%',
                valueColor: Colors.green,
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 50,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blackColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
            ],
          ),
          child: Column(
            children: [
              _timelineItem(
                title: 'Stage 1',
                status: 'Completed',
                date: status.stage1CompletedAt
                    .toLocal()
                    .toString()
                    .split(' ')
                    .first,
                isCompleted: true,
              ),
              _timelineItem(
                title: 'Current Stage',
                status: status.currentStage,
                isCompleted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loanRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.red,
    String? subText,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
            if (subText != null)
              Text(
                subText,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _timelineItem({
    required String title,
    required String status,
    String? date,
    bool isCompleted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted ? Colors.green : Colors.grey,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ],
            ),
          ),
          if (date != null)
            Text(
              date,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
        ],
      ),
    );
  }

  Widget _customerInformationCard(LoanApplicationData app) {
    final user = app.userId;
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: isDark ? Colors.white : AppColors.blackColor,
              ),
              SizedBox(width: 8),
              Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// USER HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue,
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                  const Text(
                    'Applicant',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _infoTile(
                  icon: Icons.work_outline,
                  title: 'Occupation',
                  value: app.occupation,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoTile(
                  icon: Icons.currency_rupee,
                  title: 'Monthly Income',
                  value: '₹${app.monthlyIncome}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoTile(
                  icon: Icons.percent,
                  title: 'Credit Utilization',
                  value: '${app.creditUtilization}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoTile(
                  icon: Icons.badge_outlined,
                  title: 'PAN',
                  value: app.cibilScore.personalInfo.pan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _infoTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  value: user.phone.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: user.email ?? 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  Widget _metricCard({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
    required Color iconBg,
  }) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          /// Icon
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: valueColor),
          ),

          const SizedBox(width: 12),

          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
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
}
