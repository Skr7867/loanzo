import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../viewModels/controllers/ApplicationDetails/application_details_controller.dart';

class DocumentsWidgets extends StatelessWidget {
  const DocumentsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationDetailsController>();

    return Obx(() {
      final app = controller.application;

      if (app == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final salarySlips = app.salarySlips;
      final itr = app.itr;
      final businessProof = app.businessProof;

      final totalDocs =
          salarySlips.length + (itr.isNotEmpty ? 1 : 0) + businessProof.length;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TOP SUMMARY GRID
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final items = [
                  _summaryItem(salarySlips.length.toString(), 'Salary Slips'),
                  _summaryItem(itr.isNotEmpty ? '1' : '0', 'ITR Documents'),
                  _summaryItem(
                    businessProof.length.toString(),
                    'Business Proof',
                  ),
                  _summaryItem(totalDocs.toString(), 'Total Documents'),
                ];
                return _summaryCard(items[index]);
              },
            ),

            const SizedBox(height: 16),

            /// 🔹 SALARY SLIPS
            if (salarySlips.isNotEmpty) ...[
              _sectionTitle(
                'Salary Slips (${salarySlips.length})',
                trailing: _outlinedButton(
                  'Download All',
                  () => _downloadAll(salarySlips),
                ),
              ),
              ...salarySlips.asMap().entries.map(
                (e) => _documentTile(
                  'Salary Slip ${e.key + 1}',
                  url: e.value,
                  verified: true,
                ),
              ),
              const SizedBox(height: 16),
            ],

            /// 🔹 ITR DOCUMENT
            if (itr.isNotEmpty) ...[
              _sectionTitle('Income Tax Return (ITR)'),
              _singleDocumentCard(
                title: 'Income Tax Return Document',
                subtitle: 'ITR PDF',
                url: itr,
              ),
              const SizedBox(height: 20),
            ],

            /// 🔹 VERIFICATION STATUS
            _sectionTitle('Document Verification Status'),
            _statusTile(
              'Salary Slips',
              '${salarySlips.length} files',
              salarySlips.isNotEmpty,
            ),
            _statusTile(
              'ITR Documents',
              itr.isNotEmpty ? '1 files' : '0 files',
              itr.isNotEmpty,
            ),
            _statusTile(
              'Business Proof',
              '${businessProof.length} files',
              businessProof.isNotEmpty,
            ),
          ],
        ),
      );
    });
  }

  // ======================= DOWNLOAD / OPEN (FIXED) =======================

  Future<void> _openDocument(String url) async {
    try {
      final uri = Uri.parse(Uri.encodeFull(url));

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'Unable to open document',
        'Please install a PDF viewer or browser',
      );
    }
  }

  Future<void> _downloadAll(List<String> urls) async {
    for (final url in urls) {
      await _openDocument(url);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  // ======================= UI HELPERS =======================

  static Map<String, String> _summaryItem(String value, String label) => {
    'value': value,
    'label': label,
  };

  Widget _summaryCard(Map<String, String> data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data['value']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data['label']!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _documentTile(
    String title, {
    required String url,
    bool verified = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          _iconBox(Icons.picture_as_pdf, Colors.red.shade100),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (verified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Verified',
                style: TextStyle(fontSize: 11, color: Colors.green),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _openDocument(url),
          ),
        ],
      ),
    );
  }

  Widget _singleDocumentCard({
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(borderColor: Colors.green),
      child: Row(
        children: [
          _iconBox(Icons.picture_as_pdf, Colors.green.shade100),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          _outlinedButton('Open', () => _openDocument(url)),
        ],
      ),
    );
  }

  Widget _statusTile(String title, String count, bool verified) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          Icon(
            verified ? Icons.check_circle : Icons.error,
            color: verified ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
          Text(count, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _outlinedButton(String text, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _iconBox(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18),
    );
  }

  BoxDecoration _boxDecoration({Color borderColor = const Color(0xFFE0E0E0)}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
    );
  }
}
