import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';

class ExistingLoanWidgets extends StatelessWidget {
  const ExistingLoanWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationDetailsController>();

    return Obx(() {
      final app = controller.application;

      /// 🔹 Loading
      if (app == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final loans = app.dtiCalculation.existingLoansBreakdown;
      final summary = app.cibilScore.summary;

      final int activeLoans = loans.length;
      final int totalOutstanding = loans.fold(
        0,
        (sum, loan) => sum + loan.outstanding,
      );
      final int totalMonthlyEmi = loans.fold(
        0,
        (sum, loan) => sum + loan.emiAmount,
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 SUMMARY GRID
            _summaryGrid(
              activeLoans: activeLoans,
              totalOutstanding: totalOutstanding,
              totalEmi: totalMonthlyEmi,
              activeCards: summary.totalActiveCreditCards,
            ),

            const SizedBox(height: 16),

            /// 🔹 ACTIVE LOANS TABLE
            _sectionTitle('Active Loan Accounts'),
            _activeLoanTable(loans),

            const SizedBox(height: 16),

            /// 🔹 EMI DETAILS TABLE
            _emiDetailsTable(loans),

            const SizedBox(height: 16),

            /// 🔹 MONTHLY PAYMENT BREAKDOWN
            _sectionTitle('Monthly Payment Breakdown'),
            ...loans.map(
              (loan) => _monthlyPaymentCard(
                title: loan.accountType,
                subtitle: loan.lender,
                amount: '₹${loan.emiAmount}',
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 LOAN DISTRIBUTION
            _sectionTitle('Loan Type Distribution'),
            _loanDistributionCard(summary),

            const SizedBox(height: 16),

            /// 🔹 BOTTOM SUMMARY
            _summaryGridBottom(summary),
          ],
        ),
      );
    });
  }

  // ================= SUMMARY GRID =================
  Widget _summaryGrid({
    required int activeLoans,
    required int totalOutstanding,
    required int totalEmi,
    required int activeCards,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _StatBox(title: 'Active Loans', value: activeLoans.toString()),
        _StatBox(
          title: 'Total Outstanding',
          value: '₹$totalOutstanding',
          color: Colors.red,
        ),
        _StatBox(
          title: 'Monthly EMI',
          value: '₹$totalEmi',
          color: Colors.green,
        ),
        _StatBox(title: 'Active Credit Cards', value: activeCards.toString()),
      ],
    );
  }

  // ================= ACTIVE LOANS =================
  Widget _activeLoanTable(List loans) {
    return _card(
      child: Column(
        children: [
          _tableHeader(['Account Type', 'Bank', 'Outstanding']),
          ...loans.map(
            (loan) => _tableRow([
              loan.accountType,
              loan.lender,
              '₹${loan.outstanding}',
            ]),
          ),
        ],
      ),
    );
  }

  // ================= EMI DETAILS =================
  Widget _emiDetailsTable(List loans) {
    return _card(
      child: Column(
        children: [
          _tableHeader(['Outstanding', 'EMI', 'Status']),
          ...loans.map(
            (loan) => _tableRow([
              '₹${loan.outstanding}',
              '₹${loan.emiAmount}',
              'Active',
            ]),
          ),
        ],
      ),
    );
  }

  // ================= MONTHLY PAYMENT =================
  Widget _monthlyPaymentCard({
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ================= LOAN DISTRIBUTION =================
  Widget _loanDistributionCard(summary) {
    return _card(
      child: Column(
        children: [
          _StatRow(
            label: 'Total Loan Outstanding',
            value: '₹${summary.totalLoanOutstanding}',
          ),
          const SizedBox(height: 10),
          _StatRow(
            label: 'Credit Card Outstanding',
            value: '₹${summary.totalCardOutstanding}',
          ),
          const SizedBox(height: 10),
          _StatRow(
            label: 'Overdue Payments',
            value: summary.overduePaymentsCount.toString(),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM GRID =================
  Widget _summaryGridBottom(summary) {
    return GridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 4,
      children: [
        _StatBox(
          title: 'Total Loan Outstanding',
          value: '₹${summary.totalLoanOutstanding}',
        ),
        _StatBox(
          title: 'Credit Card Outstanding',
          value: '₹${summary.totalCardOutstanding}',
        ),
        _StatBox(
          title: 'Overdue Payments',
          value: summary.overduePaymentsCount.toString(),
        ),
      ],
    );
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: child,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  Widget _tableHeader(List<String> headers) {
    return Row(
      children: headers
          .map(
            (h) => Expanded(
              child: Text(
                h,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _tableRow(List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: values
            .map(
              (v) => Expanded(
                child: Text(
                  v,
                  style: TextStyle(
                    fontSize: 12,
                    color: v == 'Active' ? Colors.green : Colors.black,
                    fontWeight: v == 'Active'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ================= SMALL WIDGETS =================
class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatBox({
    required this.title,
    required this.value,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
