import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:dsa/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewModels/controllers/LoanList/loan_list_controller.dart';
import 'widgets/loan_list_screen.dart';

class CustomerLoanOverviewScreen extends StatelessWidget {
  CustomerLoanOverviewScreen({super.key});

  /// ✅ Create controller ONCE here
  final LoanListController controller = Get.put(LoanListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Loan Eligibility',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              _newApplicationButton(),
              const SizedBox(height: 24),
              _statusCards(),
              const SizedBox(height: 24),
              LoanListScreen(),
              const SizedBox(height: 54),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff3B82F6), Color(0xff2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3B82F6).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Loan Application Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.opensansRegular,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage and track all vehicle loan requests for this user.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
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

  // ---------------- NEW APPLICATION BUTTON ----------------
  Widget _newApplicationButton() {
    final LoanListController controller = Get.find<LoanListController>();
    final userId = controller.userId;
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff10B981), Color(0xff059669)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff10B981).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.toNamed(
            RouteName.checkCustomerLoanEligibility,
            arguments: userId,
          );
        },
        icon: const Icon(Icons.add_circle_outline, size: 22),
        label: Text(
          "New Application",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.opensansRegular,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ---------------- STATUS CARDS ----------------
  Widget _statusCards() {
    return Obx(() {
      final total = controller.loanList.length;
      final inProgress = controller.loanList
          .where(
            (e) =>
                e.applicationStatus?.currentStage?.contains('Stage') ?? false,
          )
          .length;
      final submitted = controller.loanList
          .where((e) => e.applicationStatus?.currentStage == 'Submitted')
          .length;

      return LayoutBuilder(
        builder: (context, constraints) {
          // Determine number of columns based on width
          int crossAxisCount = 2;
          if (constraints.maxWidth > 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 2;
          }

          return GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth > 600 ? 1.6 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatusCard(
                title: "TOTAL APPLICATIONS",
                count: total.toString(),
                icon: Icons.description_rounded,
                gradientColors: const [Color(0xff3B82F6), Color(0xff2563EB)],
                trend: "+12% this month",
                trendUp: true,
              ),
              StatusCard(
                title: "SUBMITTED",
                count: submitted.toString(),
                icon: Icons.access_time_rounded,
                gradientColors: const [Color(0xffFB923C), Color(0xffF97316)],
                trend: "No pending",
                trendUp: false,
              ),
              StatusCard(
                title: "IN PROGRESS",
                count: inProgress.toString(),
                icon: Icons.trending_up_rounded,
                gradientColors: const [Color(0xffA855F7), Color(0xff9333EA)],
                trend: "${inProgress} active",
                trendUp: true,
              ),
              StatusCard(
                title: "ELIGIBLE",
                count: total.toString(),
                icon: Icons.check_circle_rounded,
                gradientColors: const [Color(0xff10B981), Color(0xff059669)],
                trend: "${total} eligible",
                trendUp: true,
              ),
            ],
          );
        },
      );
    });
  }
}

/// 🔹 ENHANCED STATUS CARD
class StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final List<Color> gradientColors;
  final String? trend;
  final bool trendUp;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.gradientColors,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),

                    // Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        count,
                        style: TextStyle(
                          color: gradientColors[0],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),

                const SizedBox(height: 4),

                // Trend (if provided)
                if (trend != null) ...[
                  Row(
                    children: [
                      Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white70,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trend!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: AppFonts.opensansRegular,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
