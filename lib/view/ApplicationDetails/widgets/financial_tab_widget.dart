import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';

class FinancialTabScreen extends StatelessWidget {
  const FinancialTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationDetailsController>();

    return Obx(() {
      if (controller.application == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final app = controller.application!;
      final dti = app.dtiCalculation;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CustomerDTIRatioCard(dti.debtToIncomeRatio),
            const SizedBox(height: 16),
            _IncomeDetailsCard(
              income: app.monthlyIncome,
              occupation: app.occupation,
            ),
            const SizedBox(height: 16),
            _ExpenseBreakdownCard(
              expensePercent: dti.personalExpensePercentage,
              expenseAmount: dti.availableForEMI,
              emiCommitments: dti.currentEMICommitments,
            ),
            const SizedBox(height: 16),
            _EMIStatsSection(dti),
            const SizedBox(height: 16),
            _DTIAnalysisLevelsCard(dti.debtToIncomeRatio),
          ],
        ),
      );
    });
  }
}

/* -------------------------------------------------------
   CUSTOMER DTI RATIO
--------------------------------------------------------*/
class _CustomerDTIRatioCard extends StatelessWidget {
  final double dti;

  const _CustomerDTIRatioCard(this.dti);

  @override
  Widget build(BuildContext context) {
    return _card(
      borderColor: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWithBadge(
            'Customer DTI Ratio',
            '${dti.toStringAsFixed(2)}%',
            Colors.green,
          ),
          const SizedBox(height: 6),
          const Text(
            'Debt-to-Income Ratio Analysis',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: dti / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: TextStyle(fontSize: 10)),
              Text('50% (Healthy Limit)', style: TextStyle(fontSize: 10)),
              Text('100%', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------
   INCOME DETAILS
--------------------------------------------------------*/
class _IncomeDetailsCard extends StatelessWidget {
  final int income;
  final String occupation;

  const _IncomeDetailsCard({required this.income, required this.occupation});

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.currency_rupee,
            title: 'Income Details',
          ),
          const SizedBox(height: 12),
          _InfoTile(
            label: 'Monthly Income',
            value: '₹$income',
            valueColor: Colors.blue,
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 10),
          _InfoTile(label: 'Occupation', value: occupation),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------
   EXPENSE BREAKDOWN
--------------------------------------------------------*/
class _ExpenseBreakdownCard extends StatelessWidget {
  final int expensePercent;
  final int expenseAmount;
  final int emiCommitments;

  const _ExpenseBreakdownCard({
    required this.expensePercent,
    required this.expenseAmount,
    required this.emiCommitments,
  });

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.percent, title: 'Expense Breakdown'),
          const SizedBox(height: 12),
          _InfoTile(
            label: 'Personal Expenses',
            value: '$expensePercent%',
            subtitle: '₹$expenseAmount',
          ),
          const SizedBox(height: 10),
          _InfoTile(
            label: 'Existing EMI Commitments',
            value: '₹$emiCommitments',
            valueColor: Colors.red,
            icon: Icons.trending_down,
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------
   EMI STATS
--------------------------------------------------------*/
class _EMIStatsSection extends StatelessWidget {
  final dti;

  const _EMIStatsSection(this.dti);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _card(
          child: _InfoTile(
            label: 'Available for EMI',
            value: '₹${dti.availableForEMI}',
            subtitle: 'After personal expenses',
            valueColor: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: _InfoTile(
            label: 'Available EMI Capacity',
            value: '₹${dti.availableEMICapacity}',
            subtitle: 'After existing EMIs',
            valueColor: Colors.blue,
          ),
        ),
        const SizedBox(height: 12),
        _card(
          borderColor: Colors.blue,
          bgColor: Colors.blue.shade50,
          child: _InfoTile(
            label: 'Maximum Eligible Amount',
            value: '₹${dti.maxEligibleLoanAmount}',
            subtitle: 'Based on DTI ratio',
            valueColor: Colors.blue,
            isBold: true,
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------
   DTI ANALYSIS LEVELS
--------------------------------------------------------*/
class _DTIAnalysisLevelsCard extends StatelessWidget {
  final double dti;

  const _DTIAnalysisLevelsCard(this.dti);

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'DTI Ratio Analysis'),
          const SizedBox(height: 10),
          _dtiRow('0–20%', 'Excellent', dti <= 20),
          _dtiRow('21–35%', 'Good', dti > 20 && dti <= 35),
          _dtiRow('36–50%', 'Moderate', dti > 35 && dti <= 50),
          _dtiRow('> 50%', 'High Risk', dti > 50),
        ],
      ),
    );
  }

  Widget _dtiRow(String range, String title, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isCurrent ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$range • $title',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Current',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------
   COMMON WIDGETS
--------------------------------------------------------*/

Widget _card({required Widget child, Color? borderColor, Color? bgColor}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: bgColor ?? Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor ?? Colors.grey.shade300),
    ),
    child: child,
  );
}

Widget _titleWithBadge(String title, String value, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  final IconData? icon;
  final String title;

  const _SectionTitle({this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18),
        if (icon != null) const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;
  final IconData? icon;
  final bool isBold;

  const _InfoTile({
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
    this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isBold ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          if (icon != null) Icon(icon, color: valueColor ?? Colors.black),
        ],
      ),
    );
  }
}
