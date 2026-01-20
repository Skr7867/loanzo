import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/color/app_colors.dart';
import '../../res/fonts/app_fonts.dart';
import '../../viewModels/controllers/CamReport/cam_report_controller.dart';
import '../../viewModels/controllers/Theme/theme_controller.dart';
import '../SkeltonBox/cam_report_skelton.dart';

class CamReportScreen extends StatelessWidget {
  CamReportScreen({super.key});

  final CamReportController controller = Get.put(CamReportController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Obx(() {
      // LOADING
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'CAM Report',
            automaticallyImplyLeading: true,
          ),
          body: CamReportSkeleton(isTablet: isTablet),
        );
      }

      // ERROR
      if (controller.errorMessage.isNotEmpty) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'CAM Report',
            automaticallyImplyLeading: true,
          ),
          body: Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ),
        );
      }

      // ⚠️ NO DATA
      if (!controller.hasData) {
        return const Scaffold(
          body: Center(
            child: Text(
              'CAM report not available',
              style: TextStyle(
                fontFamily: AppFonts.opensansRegular,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      return _buildUI(context, isTablet);
    });
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return '-';
    }
  }

  Widget _buildUI(BuildContext context, bool isTablet) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'CAM Report',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 800 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context, isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  _executiveSummary(isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  _eligibilityAndScore(isTablet),
                  SizedBox(height: isTablet ? 24 : 16),
                  _riskAssessment(isTablet),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header(BuildContext context, bool isTablet) {
    final summary = controller.executiveSummary;
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isTablet ? 20 : 2),
          Text(
            'CAM Report - ${summary?.applicantName ?? '-'}',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 6),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: isTablet ? 16 : 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                'Generated: ${formatDate(controller.report?.reportGeneratedAt)}',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey.shade600,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(flex: 3, child: _generateButton(isTablet)),
                    SizedBox(width: isTablet ? 16 : 12),
                    Expanded(flex: 1, child: _pdfButton(isTablet)),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _generateButton(isTablet),
                    const SizedBox(height: 3),
                    _pdfButton(isTablet),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _generateButton(bool isTablet) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.toNamed(
          RouteName.camReportGeneratorScreen,
          arguments: controller.userId,
        );
      },
      icon: Icon(Icons.description_outlined, size: isTablet ? 22 : 20),
      label: Text(
        'Generate CAM Report',
        style: TextStyle(
          fontFamily: AppFonts.opensansRegular,
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 18 : 10,
          horizontal: isTablet ? 24 : 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }

  Widget _pdfButton(bool isTablet) {
    final String? pdfUrlString = controller.camReport.value?.data?.pdfUrl;

    return ElevatedButton.icon(
      onPressed: () async {
        if (pdfUrlString == null || pdfUrlString.isEmpty) {
          Get.snackbar(
            'PDF not available',
            'CAM report PDF is not generated yet',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        final Uri pdfUri = Uri.parse(pdfUrlString);

        if (await canLaunchUrl(pdfUri)) {
          await launchUrl(
            pdfUri,
            mode: LaunchMode.externalApplication, // opens browser / PDF app
          );
        } else {
          Get.snackbar(
            'Error',
            'Unable to open PDF',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      icon: Icon(Icons.picture_as_pdf, size: isTablet ? 22 : 20),
      label: Text(
        'PDF',
        style: TextStyle(
          fontFamily: AppFonts.opensansRegular,
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 18 : 10,
          horizontal: isTablet ? 24 : 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }

  // ================= EXECUTIVE SUMMARY =================

  Widget _executiveSummary(bool isTablet) {
    final summary = controller.executiveSummary;
    final applicant = controller.applicant;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoTile(
            'ID',
            controller.camReport.value?.data?.camInputId ?? '-',
            isTablet,
          ),
          _infoTile(
            'Applicant Name',
            summary?.applicantName ?? applicant?.name ?? '-',
            isTablet,
          ),
          _infoTile(
            'Monthly Income',
            '₹${controller.report?.incomeDetails?.monthlyIncome ?? '-'}',
            isTablet,
          ),
          _infoTile(
            'Credit History Age',
            applicant?.creditHistoryAge ?? '-',
            isTablet,
          ),
        ],
      ),
    );
  }

  // ================= ELIGIBILITY & SCORE =================

  Widget _eligibilityAndScore(bool isTablet) {
    return Column(
      children: [
        // Max Eligible Amount
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.3),
                blurRadius: 12,
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
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 10 : 8),
                  Text(
                    'Max Eligible Amount',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 13,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: AppFonts.opensansRegular,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 14 : 12),
              Text(
                '₹${controller.report?.eligibility?.eligibleLoanAmount ?? 0}',
                style: TextStyle(
                  fontSize: isTablet ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.opensansRegular,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: isTablet ? 10 : 8),
              Text(
                'Based on comprehensive financial assessment',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.white.withOpacity(0.8),
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Recommended Loan Amount
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: _card(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.recommend_outlined,
                          size: isTablet ? 20 : 18,
                          color: const Color(0xFF2563EB),
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                        Text(
                          'Recommended Loan Amount',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey.shade600,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 12 : 10),
                    Text(
                      '₹${controller.executiveSummary?.recommendedLoanAmount ?? 0}',
                      style: TextStyle(
                        fontSize: isTablet ? 26 : 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2563EB),
                        fontFamily: AppFonts.opensansRegular,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: const Color(0xFF2563EB),
                  size: isTablet ? 32 : 28,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Credit Score
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_score,
                    size: isTablet ? 20 : 18,
                    color: Colors.green,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Text(
                    'Credit Score',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.grey.shade600,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                children: [
                  Text(
                    '${controller.executiveSummary?.creditScore ?? 0}',
                    style: TextStyle(
                      fontSize: isTablet ? 36 : 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.opensansRegular,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 12,
                      vertical: isTablet ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFAF3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.applicant?.creditScoreCategory ?? 'NA',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontFamily: AppFonts.opensansRegular,
                        fontSize: isTablet ? 15 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 18 : 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value:
                      ((controller.executiveSummary?.creditScore ?? 0) / 900),
                  minHeight: isTablet ? 10 : 8,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '300',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: Colors.grey,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                  Text(
                    '900',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: Colors.grey,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 10,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.update,
                        size: isTablet ? 14 : 12,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: isTablet ? 6 : 4),
                      Text(
                        'Updated at: ${formatDate(controller.camReport.value?.data?.updatedAt)}',
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: Colors.grey.shade300,
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
      ],
    );
  }

  // ================= RISK ASSESSMENT =================

  Widget _riskAssessment(bool isTablet) {
    final risk = controller.riskAssessment;
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Column(
      children: [
        // Verdict
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: isTablet ? 20 : 18,
                    color: Colors.green,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Text(
                    'Verdict',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.grey.shade600,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFFEFFAF3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade700,
                      size: isTablet ? 22 : 18,
                    ),
                    SizedBox(width: isTablet ? 10 : 8),
                    Text(
                      '${controller.executiveSummary?.approvalConfidence ?? 0}',
                      style: TextStyle(
                        fontFamily: AppFonts.opensansRegular,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: isTablet ? 20 : 18,
                      color: Colors.amber.shade800,
                    ),
                    SizedBox(width: isTablet ? 10 : 8),
                    Expanded(
                      child: Text(
                        'Confidence Level: ${controller.executiveSummary?.riskLevel ?? '-'}',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          fontFamily: AppFonts.opensansRegular,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Risk Assessment
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: isTablet ? 24 : 20,
                    ),
                  ),
                  SizedBox(width: isTablet ? 14 : 10),
                  Text(
                    'Risk Assessment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.opensansRegular,
                      fontSize: isTablet ? 18 : 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 18 : 14),
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.orange,
                      size: isTablet ? 28 : 24,
                    ),
                    SizedBox(width: isTablet ? 14 : 10),
                    Text(
                      risk?.label?.toUpperCase() ?? 'NA',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.opensansRegular,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 18 : 14),
              _riskMetric(
                'FOIR Percentage',
                '${controller.report?.foirAnalysis?.currentFOIRPercentage ?? 0}%',
                isTablet,
              ),

              SizedBox(height: isTablet ? 10 : 8),
              _riskMetric(
                'Max Allowed',
                '${controller.report?.foirAnalysis?.maxAllowedFOIR ?? 0}%',
                isTablet,
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),

        // Critical Note
        Container(
          padding: EdgeInsets.all(isTablet ? 24 : 20),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.priority_high,
                      size: isTablet ? 22 : 18,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 10),
                  Text(
                    'CRITICAL NOTE',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontFamily: AppFonts.opensansRegular,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  // color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.greyColor.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  '"Good credit standing with ₹17,62,282 borrowing capacity"',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.opensansRegular,
                    height: 1.5,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 14 : 10),
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                    size: isTablet ? 18 : 16,
                  ),
                  SizedBox(width: isTablet ? 8 : 6),
                  Text(
                    'Important highlight',
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      fontFamily: AppFonts.opensansRegular,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  // ================= HELPERS =================

  Widget _riskMetric(String label, String value, bool isTablet) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 14 : 13,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              fontFamily: AppFonts.opensansRegular,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, bool isTablet) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isTablet ? 14 : 12),
      padding: EdgeInsets.all(isTablet ? 16 : 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,

              fontFamily: AppFonts.opensansRegular,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.opensansRegular,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _card() {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return BoxDecoration(
      color: isDark ? AppColors.blackColor : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
      ],
    );
  }
}
