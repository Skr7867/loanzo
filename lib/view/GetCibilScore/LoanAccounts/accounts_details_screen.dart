import 'package:dsa/res/color/app_colors.dart';
import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/CibilScore/cibil_score_model.dart';
import '../../../viewModels/controllers/CibilScore/cibil_score_controller.dart';

class AccountsDetailsScreen extends StatelessWidget {
  const AccountsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserCibilScoreController>();
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
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                  bgColor: const Color(0xFFEFF5FF),
                ),

                _infoCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  title: 'On Time Payments',
                  value:
                      '${account.monthlyHistory?.where((e) => e.status == "On Time").length ?? 0}',
                  bgColor: const Color(0xFFEFFAF3),
                ),

                _infoCard(
                  icon: Icons.error_outline,
                  iconColor: Colors.red,
                  title: 'Late Payments',
                  value:
                      '${account.monthlyHistory?.where((e) => e.status != "On Time").length ?? 0}',
                  bgColor: const Color(0xFFFFF1F1),
                ),

                _infoCard(
                  icon: Icons.timelapse,
                  iconColor: Colors.orange,
                  title: 'Months Reported',
                  value: '${account.monthsReported ?? 0}',
                  bgColor: const Color(0xFFFFF8E6),
                ),

                const SizedBox(height: 20),

                /// ================= FINANCIAL INFO =================
                const Text(
                  'Financial Information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                _financialTile('EMI Amount', '₹${account.emiAmount ?? 0}'),

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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total: ${history.length} months',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            final item = history[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.date ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Row(
                    children: const [
                      Icon(Icons.check_circle, size: 14, color: Colors.green),
                      SizedBox(width: 6),
                      Text(
                        'Paid on Time',
                        style: TextStyle(fontSize: 11, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _additionalDetails(Accounts account) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // shadow color
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
