import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/color/app_colors.dart';
import '../../viewModels/controllers/EmiCalculators/emi_calculators_controller.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import 'widgets/emi_pie_chart.dart';
import 'widgets/payment_summary_card.dart';

class EmiCalculatorScreen extends StatelessWidget {
  EmiCalculatorScreen({super.key});

  final EmiController controller = Get.put(EmiController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'EMI Calculator',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Loan Details Card
              _buildLoanDetailsCard(context, isTablet),

              const SizedBox(height: 20),

              // Monthly EMI Result Card
              _buildEmiResultCard(isTablet),

              const SizedBox(height: 20),

              // Payment Summary Card
              Obx(
                () => PaymentSummaryCards(
                  totalPayment: "₹${_formatNumber(controller.totalPayment)}",
                  tenureText: controller.isYear.value
                      ? "Over ${controller.tenure.value.toInt()} year${controller.tenure.value.toInt() > 1 ? 's' : ''}"
                      : "Over ${controller.tenure.value.toInt()} month${controller.tenure.value.toInt() > 1 ? 's' : ''}",
                  interestAmount: "₹${_formatNumber(controller.totalInterest)}",
                  interestPercent:
                      "${controller.interestPercent.toStringAsFixed(1)}% of total amount",
                ),
              ),

              const SizedBox(height: 20),

              // Payment Breakdown Section
              _buildPaymentBreakdown(isTablet),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanDetailsCard(BuildContext context, bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Details',
            style: TextStyle(
              fontFamily: AppFonts.opensansRegular,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 2),

          // Loan Amount Slider
          Obx(
            () => _buildSliderCard(
              icon: Icons.currency_rupee,
              iconColor: Colors.green,
              title: "Loan Amount",
              value: "₹${_formatNumber(controller.loanAmount.value)}",
              sliderValue: controller.loanAmount.value,
              min: 100000,
              max: 10000000,
              divisions: 99,
              minLabel: '₹1L',
              maxLabel: '₹1Cr',
              onChange: (v) => controller.loanAmount.value = v,
              isTablet: isTablet,
            ),
          ),

          const Divider(height: 2),

          // Interest Rate Slider
          Obx(
            () => _buildSliderCard(
              icon: Icons.percent,
              iconColor: Colors.blue,
              title: "Interest Rate (p.a.)",
              value: "${controller.interestRate.value.toStringAsFixed(1)}%",
              sliderValue: controller.interestRate.value,
              min: 5,
              max: 20,
              divisions: 150,
              minLabel: '5%',
              maxLabel: '20%',
              onChange: (v) => controller.interestRate.value = v,
              isTablet: isTablet,
            ),
          ),

          const Divider(height: 2),

          // Tenure Slider
          Obx(
            () => _buildSliderCard(
              icon: Icons.calendar_today,
              iconColor: Colors.orange,
              title: "Tenure",
              value: controller.isYear.value
                  ? "${controller.tenure.value.toInt()} ${controller.tenure.value.toInt() > 1 ? 'Years' : 'Year'}"
                  : "${controller.tenure.value.toInt()} ${controller.tenure.value.toInt() > 1 ? 'Months' : 'Month'}",
              sliderValue: controller.tenure.value,
              min: 1,
              max: controller.isYear.value ? 30 : 360,
              divisions: controller.isYear.value ? 29 : 359,
              minLabel: controller.isYear.value ? "1 Yr" : "1 Mo",
              maxLabel: controller.isYear.value ? "30 Yrs" : "360 Mo",
              onChange: (v) => controller.tenure.value = v,
              isTablet: isTablet,
            ),
          ),

          const SizedBox(height: 2),

          // Year/Month Toggle Buttons
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    "Years",
                    controller.isYear.value,
                    () => controller.toggleTenureType(true),
                    isTablet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggleButton(
                    "Months",
                    !controller.isYear.value,
                    () => controller.toggleTenureType(false),
                    isTablet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmiResultCard(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blueColor, AppColors.blueColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppColors.whiteColor,
                size: isTablet ? 28 : 24,
              ),
              const SizedBox(width: 8),
              Text(
                'MONTHLY EMI',
                style: TextStyle(
                  fontFamily: AppFonts.opensansRegular,
                  color: AppColors.whiteColor.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Obx(
            () => Text(
              "₹${_formatNumber(controller.emi)}",
              style: TextStyle(
                fontFamily: AppFonts.opensansRegular,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 36 : 28,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  'Principal Amount',
                  Obx(
                    () => Text(
                      "₹${_formatNumber(controller.loanAmount.value)}",
                      style: TextStyle(
                        fontFamily: AppFonts.opensansRegular,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                  isTablet,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInfoBox(
                  'Total Interest',
                  Obx(
                    () => Text(
                      "₹${_formatNumber(controller.totalInterest)}",
                      style: TextStyle(
                        fontFamily: AppFonts.opensansRegular,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                  isTablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, Widget valueWidget, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.whiteColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.opensansRegular,
              color: AppColors.whiteColor.withOpacity(0.9),
              fontSize: isTablet ? 13 : 11,
            ),
          ),
          const SizedBox(height: 4),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown(bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Breakdown',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(height: isTablet ? 280 : 240, child: EmiPieChart()),

          const SizedBox(height: 20),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                color: const Color(0xFF2196F3),
                label: 'Principal',
                isTablet: isTablet,
              ),
              SizedBox(width: isTablet ? 32 : 24),
              _buildLegendItem(
                color: const Color(0xFFFF9800),
                label: 'Interest',
                isTablet: isTablet,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          width: isTablet ? 20 : 16,
          height: isTablet ? 20 : 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.opensansRegular,
            fontSize: isTablet ? 15 : 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required double sliderValue,
    required double min,
    required double max,
    required int divisions,
    required String minLabel,
    required String maxLabel,
    required Function(double) onChange,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: isTablet ? 22 : 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.opensansRegular,
                      fontSize: isTablet ? 15 : 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.opensansRegular,
                      color: AppColors.greenColor,
                      fontSize: isTablet ? 20 : 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.blueColor,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: AppColors.blueColor,
            overlayColor: AppColors.blueColor.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: sliderValue,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChange,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: TextStyle(
                  fontFamily: AppFonts.opensansRegular,
                  fontSize: isTablet ? 13 : 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                maxLabel,
                style: TextStyle(
                  fontFamily: AppFonts.opensansRegular,
                  fontSize: isTablet ? 13 : 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isActive,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColors.blueColor,
                    AppColors.blueColor.withOpacity(0.8),
                  ],
                )
              : null,
          color: isActive ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.blueColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 10000000) {
      return "${(number / 10000000).toStringAsFixed(2)} Cr";
    } else if (number >= 100000) {
      return "${(number / 100000).toStringAsFixed(2)} L";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(2)} K";
    }
    return number.toStringAsFixed(0);
  }
}
