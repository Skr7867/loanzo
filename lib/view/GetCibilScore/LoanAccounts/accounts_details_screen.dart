import 'package:dsa/res/color/app_colors.dart';
import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/CibilScore/cibil_score_model.dart';
import '../../../viewModels/controllers/CibilScore/cibil_score_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class AccountsDetailsScreen extends StatelessWidget {
  const AccountsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserCibilScoreController>();
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    final args = Get.arguments as Map<String, dynamic>?;
    final int selectedIndex = args?['accountIndex'] ?? 0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Loan Accounts',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final report = controller.cibilScore.value?.report;
          final accounts = report?.accounts ?? [];

          if (accounts.isEmpty) {
            return const Center(child: Text('No account details found'));
          }

          final account = accounts.firstWhere(
            (a) => a.accountIndex == selectedIndex,
            orElse: () => accounts.first,
          );

          final activeCount = accounts
              .where((a) => a.accountStatus == 'Active')
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$activeCount active accounts out of ${accounts.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                ),
                const SizedBox(height: 16),

                /// ================= LOAN HEADER =================
                _loanHeader(account),

                const SizedBox(height: 16),

                /// ================= INFO CARDS =================
                _infoCard(
                  icon: Icons.calendar_month,
                  iconColor: Colors.blue,
                  title: 'Loan Tenure',
                  value:
                      '${account.dateOpened ?? '--'} - ${account.dateClosed ?? 'Invalid Date'}',
                  bgColor: isDark
                      ? AppColors.blackColor
                      : const Color(0xFFEFF5FF),
                ),

                _infoCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  title: 'On Time Payments',
                  value:
                      '${account.monthlyHistory?.where((e) => e.status == "On Time").length ?? 0}',
                  bgColor: isDark
                      ? AppColors.blackColor
                      : const Color(0xFFEFFAF3),
                ),

                _infoCard(
                  icon: Icons.error_outline,
                  iconColor: Colors.red,
                  title: 'Late Payments',
                  value:
                      '${account.monthlyHistory?.where((e) => e.status != "On Time").length ?? 0}',
                  bgColor: isDark
                      ? AppColors.blackColor
                      : const Color(0xFFFFF1F1),
                ),

                _infoCard(
                  icon: Icons.timelapse,
                  iconColor: Colors.orange,
                  title: 'Months Reported',
                  value: '${account.monthsReported ?? 0}',
                  bgColor: isDark
                      ? AppColors.blackColor
                      : const Color(0xFFFFF8E6),
                ),

                const SizedBox(height: 20),

                /// ================= FINANCIAL INFO =================
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.blackColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Financial Information',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.opensansRegular,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _financialTile(
                        'Current Balance',
                        '₹${account.currentBalance ?? 0}',
                      ),
                      _financialTile(
                        'High Credit',
                        '₹${account.highCreditAmount ?? 0}',
                      ),
                      _financialTile(
                        'Amount Overdue',
                        '₹${account.amountOverdue ?? 0}',
                      ),
                      _financialTile(
                        'EMI Amount',
                        '₹${account.emiAmount ?? 0}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= ADDITIONAL DETAILS =================
                _additionalDetails(account),

                const SizedBox(height: 20),

                /// ================= MONTHLY PAYMENT HISTORY =================
                _monthlyHistory(account),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _loanHeader(Accounts account) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${account.accountType ?? 'Loan'}\nDetails',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: account.accountStatus == 'Active'
                  ? Colors.green.shade100
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              account.accountStatus ?? 'NA',
              style: TextStyle(
                color: account.accountStatus == 'Active'
                    ? Colors.green
                    : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _financialTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      // decoration: _cardDecoration(),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyHistory(Accounts account) {
    final history = account.monthlyHistory ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Monthly Payment History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${history.length} months',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.8,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (_, index) {
            final item = history[index];
            final isPaidOnTime =
                item.status == 'paid' ||
                item.status == 'On Time'; // Adjust based on your data model

            return _PaymentStatusCircle(
              date: item.date ?? '',
              isPaidOnTime: isPaidOnTime,
              index: index,
            );
          },
        ),
      ],
    );
  }

  Widget _additionalDetails(Accounts account) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          const SizedBox(height: 12),
          _financialTile('Ownership Type', account.ownership ?? 'NA'),
          _financialTile('Last Payment Date', account.lastPaymentDate ?? 'NA'),
          _financialTile('Last Bank Update', account.lastBankUpdate ?? 'NA'),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    return BoxDecoration(
      color: isDark ? AppColors.blackColor : Colors.white,
      borderRadius: BorderRadius.circular(12),

      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
      ],
    );
  }
}

class _PaymentStatusCircle extends StatefulWidget {
  final String date;
  final bool isPaidOnTime;
  final int index;

  const _PaymentStatusCircle({
    required this.date,
    required this.isPaidOnTime,
    required this.index,
  });

  @override
  State<_PaymentStatusCircle> createState() => _PaymentStatusCircleState();
}

class _PaymentStatusCircleState extends State<_PaymentStatusCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isPaidOnTime ? Colors.green : Colors.red;
    final bgColor = widget.isPaidOnTime
        ? Colors.green.shade50
        : Colors.red.shade50;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border.all(color: color.withOpacity(0.3), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.isPaidOnTime ? Icons.check : Icons.close,
                  color: color,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(widget.date),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.opensansRegular,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    // Format date as needed, e.g., "Jan 24" or "01/24"
    try {
      final parsedDate = DateTime.parse(date);
      return '${_getMonthAbbr(parsedDate.month)} ${parsedDate.year.toString().substring(2)}';
    } catch (e) {
      return date;
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
