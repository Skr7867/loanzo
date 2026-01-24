import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../viewModels/controllers/EmiCalculators/emi_calculators_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class EmiPieChart extends StatelessWidget {
  final EmiController controller = Get.find();

  EmiPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Obx(() {
      final principal = controller.principalPercent;
      final interest = controller.interestPercent;

      return Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  value: principal,
                  color: const Color(0xFF2196F3),
                  radius: 65,
                  title: "${principal.toStringAsFixed(1)}%",
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                  ),
                  badgeWidget: null,
                ),
                PieChartSectionData(
                  value: interest,
                  color: const Color(0xFFFF9800),
                  radius: 65,
                  title: "${interest.toStringAsFixed(1)}%",
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                  ),
                  badgeWidget: null,
                ),
              ],
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Add touch interactions if needed
                },
                enabled: true,
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeInOutCubic,
          ),

          // Center text showing total amount
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? Colors.lightBlueAccent : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatAmount(controller.totalPayment),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return "₹${(amount / 10000000).toStringAsFixed(2)}Cr";
    } else if (amount >= 100000) {
      return "₹${(amount / 100000).toStringAsFixed(2)}L";
    } else if (amount >= 1000) {
      return "₹${(amount / 1000).toStringAsFixed(2)}K";
    }
    return "₹${amount.toStringAsFixed(0)}";
  }
}
