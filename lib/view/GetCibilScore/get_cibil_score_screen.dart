import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/color/app_colors.dart';
import '../../res/fonts/app_fonts.dart';
import '../../viewModels/controllers/CibilScore/cibil_score_controller.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import 'Widgets/cibil_score_overview.dart';
import 'Widgets/quick_action_widget.dart';
import 'Widgets/summary_widget.dart';

class GetCivilScoreScreen extends StatelessWidget {
  GetCivilScoreScreen({super.key});

  final UserCibilScoreController controller = Get.put(
    UserCibilScoreController(),
  );

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'CIBIL Result',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final cibil = controller.cibilScore.value;
          if (cibil == null || cibil.report == null) {
            return const Center(child: Text('No CIBIL data available'));
          }

          final personal = cibil.report!.personalInfo;
          final scoreValue = cibil.report?.score?.value ?? 0;

          return SingleChildScrollView(
            child: Column(
              children: [
                // HEADER CARD
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.blackColor : AppColors.blueColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          personal?.name?.toUpperCase() ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.opensansRegular,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${cibil.report!.userId?.sId ?? '-'}',
                          style: TextStyle(
                            fontFamily: AppFonts.opensansRegular,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),

                      /// 🔹 INFO GRID
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2.6,
                            ),
                        children: [
                          _infoBox('Date of Birth', personal?.birthDate ?? '-'),
                          _infoBox('Gender', personal?.gender ?? '-'),
                          _infoBox(
                            'Mobile',
                            personal?.mobiles?.isNotEmpty == true
                                ? personal!.mobiles!.first
                                : '-',
                          ),
                          _infoBox(
                            'Email',
                            personal?.emails?.isNotEmpty == true
                                ? personal!.emails!.first.toString()
                                : '-',
                          ),
                          _infoBox('PAN Number', personal?.pan ?? '-'),
                        ],
                      ),
                    ],
                  ),
                ),

                CibilScoreOverview(score: scoreValue, percentile: 77),

                QuickActionsCard(),
                SummaryWidget(),
                SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 🔹 SMALL INFO CARD
  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.opensansRegular,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
