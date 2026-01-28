import 'dart:math';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/color/app_colors.dart';
import '../../../viewModels/controllers/CibilScore/cibil_score_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class CibilScoreOverview extends StatelessWidget {
  final int score;
  final int percentile;

  const CibilScoreOverview({
    super.key,
    required this.score,
    required this.percentile,
  });

  Color get scoreColor {
    if (score >= 750) return Colors.green;
    if (score >= 650) return Colors.blue;
    if (score >= 550) return Colors.orange;
    return Colors.red;
  }

  String get scoreLabel {
    if (score >= 750) return 'Excellent Score';
    if (score >= 650) return 'Good Score';
    if (score >= 550) return 'Average Score';
    return 'Poor Score';
  }

  double get needleAngle {
    // Score range 300–900 → angle -135° to +135°
    final percent = ((score - 300) / 600).clamp(0.0, 1.0);
    return -135 + (270 * percent);
  }

  @override
  Widget build(BuildContext context) {
    final UserCibilScoreController controller =
        Get.find<UserCibilScoreController>();

    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 2),
        ],
      ),
      child: Column(
        children: [
          /// TITLE
          const Text(
            'CIBIL Score Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),

          const SizedBox(height: 20),

          /// GAUGE
          SizedBox(
            height: 150,
            width: 260,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(290, 140),
                  painter: _GaugePainter(),
                ),

                /// NEEDLE
                Transform.rotate(
                  angle: needleAngle * pi / 5050,
                  child: Container(
                    height: 300,
                    width: 7,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                /// CENTER DOT
                Container(
                  height: 14,
                  width: 19,
                  decoration: BoxDecoration(
                    color: AppColors.blueColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          /// SCORE
          Text(
            '$score Score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),

          const SizedBox(height: 6),

          /// LAST UPDATE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Last update: ${controller.cibilScore.value!.report!.score!.date.toString()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// SCORE LABEL
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: scoreColor),
                const SizedBox(width: 6),
                Text(
                  scoreLabel,
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// RANGE
          const Text('Score Range 300 - 900', style: TextStyle(fontSize: 12)),

          const SizedBox(height: 10),

          /// YOUR SCORE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Score'),
              Text(
                score.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// PERCENTILE BAR
          LinearProgressIndicator(
            value: percentile / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '300',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              Text(
                '600',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              Text(
                '900',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// LEGEND
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Legend(color: Colors.red, label: '<550'),
              _Legend(color: Colors.orange, label: '550-649'),
              _Legend(color: Colors.blue, label: '650-749'),
              _Legend(color: Colors.green, label: '750+'),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🔹 GAUGE ARC PAINTER
class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.butt;

    // Poor
    paint.color = Colors.red;
    canvas.drawArc(rect, pi, pi / 4, false, paint);

    // Average
    paint.color = Colors.orange;
    canvas.drawArc(rect, pi + pi / 4, pi / 4, false, paint);

    // Good
    paint.color = Colors.blue;
    canvas.drawArc(rect, pi + pi / 2, pi / 4, false, paint);

    // Excellent
    paint.color = Colors.green;
    canvas.drawArc(rect, pi + 3 * pi / 4, pi / 4, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 🔹 LEGEND DOT
class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
