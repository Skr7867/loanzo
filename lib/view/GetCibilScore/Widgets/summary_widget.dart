import 'package:dsa/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/color/app_colors.dart';
import '../../../res/fonts/app_fonts.dart';
import '../../../viewModels/controllers/CibilScore/cibil_score_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserCibilScoreController controller =
        Get.find<UserCibilScoreController>();
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Get your all summary',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.summarize_outlined,
                  size: 16,
                  color: AppColors.blueColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DOWNLOAD REPORT
          /// DOWNLOAD REPORT
          _actionTile(
            color: Colors.redAccent,
            icon: Icons.summarize_outlined,
            title: 'Summary',
            subtitle: 'Get your Summary',
            onTap: () {
              Get.toNamed(RouteName.summaryReport);
            },
          ),

          const SizedBox(height: 12),

          /// CHECK LOAN ELIGIBILITY
          _actionTile(
            color: AppColors.greyColor,
            icon: Icons.trending_up,
            title: 'Loan Accounts',
            subtitle: 'Get your loan accounts',
            onTap: () {
              Get.toNamed(RouteName.loanAccountScreen);
            },
          ),

          const SizedBox(height: 14),

          _actionTile(
            color: AppColors.blueColor,
            icon: Icons.trending_up,
            title: 'Loan Application ',
            subtitle: 'Verify Approval Chances',
            onTap: () {
              Get.toNamed(
                RouteName.loanEligibiity,
                arguments: controller.userId,
              );
            },
          ),
          const SizedBox(height: 14),

          /// FOOTER
          Row(
            children: const [
              Icon(Icons.flash_on, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Instant processing',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Spacer(),
              Icon(Icons.lock, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                '100% secure',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 ACTION TILE
  Widget _actionTile({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: textColor, size: 20),
            ),

            const SizedBox(width: 12),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.9),
                      fontSize: 11,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: textColor.withOpacity(0.9),
            ),
          ],
        ),
      ),
    );
  }
}
