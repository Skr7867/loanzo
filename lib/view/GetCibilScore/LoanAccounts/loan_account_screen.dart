import 'package:dsa/res/custom_widgets/custome_appbar.dart';
import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:dsa/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/CibilScore/cibil_score_model.dart';
import '../../../viewModels/controllers/CibilScore/cibil_score_controller.dart'
    show UserCibilScoreController;

class LoanAccountScreen extends StatelessWidget {
  const LoanAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserCibilScoreController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Loan Account View',
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
            return const Center(child: Text('No loan accounts found'));
          }

          final activeCount = accounts
              .where((a) => a.accountStatus == 'Active')
              .length;

          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 5, right: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(activeCount, accounts.length),
                  const Divider(height: 1),

                  /// 🔥 CRITICAL FIX — BOUNDED HEIGHT
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 850,
                        child: ListView(
                          children: [
                            _buildTableHeadings(),
                            ...accounts.map(_buildLoanRowFromModel).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= DATA → UI =================

  Widget _buildLoanRowFromModel(Accounts account) {
    final isActive = account.accountStatus == 'Active';

    final tenure =
        "${account.dateOpened ?? '--'} -\n${account.dateClosed ?? 'Invalid Date'}";

    final paymentsDone =
        account.monthlyHistory?.where((e) => e.status == 'On Time').length ?? 0;

    final totalMonths = account.repaymentTenureMonths ?? paymentsDone;

    return _buildLoanRow(
      accountIndex: account.accountIndex ?? 0,
      type: account.accountType ?? 'NA',
      institution: account.memberShortName ?? 'NA',
      id: account.accountNumberMasked ?? 'XXXX',
      behavior: isActive ? 'On Time' : 'Closed',
      payments: "$paymentsDone of $totalMonths",
      tenure: tenure,
      status: account.accountStatus ?? 'NA',
      balance: "₹${account.currentBalance ?? 0}",
      isActive: isActive,
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(int active, int total) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Loan Accounts",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            "$active active accounts out of $total",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================= TABLE HEAD =================

  Widget _buildTableHeadings() {
    return Container(
      color: const Color(0xFFFBFBFB),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: const [
          SizedBox(
            width: 180,
            child: Text("ACCOUNT TYPE", style: _headingStyle),
          ),
          SizedBox(
            width: 150,
            child: Text("INSTITUTION", style: _headingStyle),
          ),
          SizedBox(
            width: 120,
            child: Text("PAYMENT BEHAVIOR", style: _headingStyle),
          ),
          SizedBox(
            width: 110,
            child: Text("LOAN TENURE", style: _headingStyle),
          ),
          SizedBox(width: 80, child: Text("STATUS", style: _headingStyle)),
          SizedBox(
            width: 100,
            child: Text("BALANCE (₹)", style: _headingStyle),
          ),
          SizedBox(width: 60, child: Text("ACTIONS", style: _headingStyle)),
        ],
      ),
    );
  }

  // ================= ROW =================

  Widget _buildLoanRow({
    required int accountIndex,
    required String type,
    required String institution,
    required String id,
    required String behavior,
    required String payments,
    required String tenure,
    required String status,
    required String balance,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.account_balance, size: 16),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "Individual",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institution,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  id,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  behavior,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$payments payments",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              tenure,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              balance,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 90,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(
                  RouteName.accountDetailsScreen,
                  arguments: {'accountIndex': accountIndex},
                );
              },
              icon: const Icon(Icons.visibility_outlined, size: 10),
              label: const Text(
                "View",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFonts.opensansRegular,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEEF4FF),
                foregroundColor: const Color(0xFF4C84FF),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _headingStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey,
  );
}
