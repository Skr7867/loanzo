import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';

class PaymentHistoryWidget extends StatelessWidget {
  const PaymentHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationDetailsController>();

    return Obx(() {
      final app = controller.application;

      /// 🔹 Loading
      if (app == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final payment = app.paymentHistoryAnalysis;
      final accounts = app.cibilScore.accounts;

      /// Calculate on-time rate (simple logic – can refine later)
      final double onTimeRate = payment.totalBouncesOrDelays == 0
          ? 100.0
          : 90.0;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TOP SUMMARY (HORIZONTAL)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _SummaryCard(
                    title: 'On-time Payment Rate',
                    value: '${onTimeRate.toStringAsFixed(1)}%',
                  ),
                  _SummaryCard(
                    title: 'Total Bounces/Delays',
                    value: payment.totalBouncesOrDelays.toString(),
                  ),
                  _SummaryCard(
                    title: 'Recent (3 months)',
                    value: payment.recentBounces3Months.toString(),
                  ),
                  _SummaryCard(
                    title: 'Recent (6 months)',
                    value: payment.recentBounces6Months.toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 PAYMENT TREND
            _sectionTitle('Payment Trend'),
            _paymentTrendCard(onTimeRate),

            const SizedBox(height: 20),

            /// 🔹 RECENT PAYMENT STATUS
            _sectionTitle('Recent Payment Status'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: accounts.map((acc) {
                  return _PaymentStatusCard(
                    accountType: acc.accountType,
                    bank: acc.memberShortName,
                    status: acc.accountStatus,
                    lastPayment: acc.lastPaymentDate,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 BOUNCE ANALYSIS
            _sectionTitle('Bounce Analysis'),
            Row(
              children: [
                Expanded(
                  child: _BounceCard(
                    title: 'Recent Bounces (3 months)',
                    subtitle: 'Bounces in last 90 days',
                    value: payment.recentBounces3Months.toString(),
                    iconColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BounceCard(
                    title: 'Recent Bounces (6 months)',
                    subtitle: 'Bounces in last 180 days',
                    value: payment.recentBounces6Months.toString(),
                    iconColor: Colors.orange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  /// 🔹 Section title
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// 🔹 Payment trend card
  Widget _paymentTrendCard(double rate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'On-time Payment Rate',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${rate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Chip(
                label: Text('Excellent'),
                backgroundColor: Color(0xffE6F7EF),
                labelStyle: TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: rate / 100,
            minHeight: 8,
            backgroundColor: const Color(0xffE0E0E0),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

/* =======================================================
   SUMMARY CARD
======================================================= */
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/* =======================================================
   PAYMENT STATUS CARD
======================================================= */
class _PaymentStatusCard extends StatelessWidget {
  final String accountType;
  final String bank;
  final String status;
  final String lastPayment;

  const _PaymentStatusCard({
    required this.accountType,
    required this.bank,
    required this.status,
    required this.lastPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Account Type', accountType),
          _row('Bank', bank),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status', style: TextStyle(fontSize: 12)),
              Chip(
                label: Text(status),
                backgroundColor: const Color(0xffE6F7EF),
                labelStyle: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          _row('Last Payment', lastPayment),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

/* =======================================================
   BOUNCE CARD
======================================================= */
class _BounceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color iconColor;

  const _BounceCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: iconColor),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/* =======================================================
   SHARED DECORATION
======================================================= */
BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300),
  );
}
