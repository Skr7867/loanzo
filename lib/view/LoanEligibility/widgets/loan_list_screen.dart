import 'package:dsa/res/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/response/status.dart';
import '../../../models/LoanList/loan_list_model.dart';
import '../../../res/color/app_colors.dart';
import '../../../res/routes/routes_name.dart';
import '../../../viewModels/controllers/LoanList/loan_list_controller.dart';
import '../../../viewModels/controllers/Theme/theme_controller.dart';

class LoanListScreen extends StatelessWidget {
  LoanListScreen({super.key});

  final LoanListController controller = Get.find();

  final List<String> filterOptions = const [
    'All Applications',
    'Stage1_BasicDetails',
    'Stage2_AdditionalDetails',
    'Submitted',
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.grey.withOpacity(0.2)
              : AppColors.greyColor.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _topBar(isDark),
          Divider(
            height: 1,
            color: isDark
                ? Colors.grey.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
          ),
          Obx(() {
            switch (controller.rxStatus.value) {
              case Status.LOADING:
                return _loadingState();
              case Status.ERROR:
                return _errorState();
              case Status.COMPLETED:
                return _loanTable(isDark);
            }
          }),
        ],
      ),
    );
  }

  // ---------------- LOADING STATE ----------------
  Widget _loadingState() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 16),
          Text(
            'Loading applications...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ERROR STATE ----------------
  Widget _errorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TOP BAR WITH SEARCH AND FILTERS ----------------
  Widget _topBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.15),
              ),
            ),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                hintText: 'Search by brand, model, amount, tenure...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                  fontSize: 14,
                  fontFamily: AppFonts.opensansRegular,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.opensansRegular,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter Chips
          Obx(() {
            return Wrap(
              spacing: 5,
              runSpacing: 8,
              children: filterOptions.map((filter) {
                final isSelected = controller.selectedFilter.value == filter;
                return _filterChip(filter, isSelected, isDark);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // ---------------- FILTER CHIP ----------------
  Widget _filterChip(String label, bool isSelected, bool isDark) {
    Color getChipColor() {
      if (isSelected) {
        return const Color(0xff3B82F6);
      }
      return isDark
          ? Colors.grey.withOpacity(0.15)
          : Colors.grey.withOpacity(0.1);
    }

    return InkWell(
      onTap: () => controller.updateFilter(label),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        height: 30,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: getChipColor(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xff3B82F6)
                : isDark
                ? Colors.grey.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_circle, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label.replaceAll('_', ' '),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isDark
                    ? Colors.grey[300]
                    : Colors.grey[700],
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: AppFonts.opensansRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TABLE ----------------
  Widget _loanTable(bool isDark) {
    final list = _filteredLoans();

    if (list.isEmpty) {
      return _emptyState(isDark);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: IntrinsicWidth(
              child: Column(
                children: [
                  _tableHeader(isDark),
                  const SizedBox(height: 8),
                  ...list.asMap().entries.map(
                    (entry) => _tableRow(entry.value, entry.key, isDark),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- EMPTY STATE ----------------
  Widget _emptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          const Text(
            'No applications found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }

  List<Data> _filteredLoans() {
    final filter = controller.selectedFilter.value;
    final query = controller.searchQuery.value.toLowerCase();

    return controller.loanList.where((item) {
      /// -------- STAGE FILTER --------
      final bool matchesStage = filter == 'All Applications'
          ? true
          : item.applicationStatus?.currentStage == filter;

      /// -------- SEARCH FILTER --------
      if (query.isEmpty) return matchesStage;

      final brand = item.vehicleInfo?.vehicleBrand?.toLowerCase() ?? '';
      final model = item.vehicleInfo?.vehicleModel?.toLowerCase() ?? '';
      final amount = item.loanAmount?.toString() ?? '';
      final tenure = item.loanTenureMonths?.toString() ?? '';
      final stage = item.applicationStatus?.currentStage?.toLowerCase() ?? '';

      final bool matchesSearch =
          brand.contains(query) ||
          model.contains(query) ||
          amount.contains(query) ||
          tenure.contains(query) ||
          stage.contains(query);

      return matchesStage && matchesSearch;
    }).toList();
  }

  Widget _tableHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.withOpacity(0.08) : const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          _HeaderCell('SR.NO', 50),
          _HeaderCell('LOAN AMOUNT', 100),
          _HeaderCell('TENURE', 70),
          _HeaderCell('VEHICLE DETAILS', 130),
          _HeaderCell('MAX ELIGIBLE', 110),
          _HeaderCell('STATUS', 130),
          _HeaderCell('ACTION', 80),
        ],
      ),
    );
  }

  Widget _tableRow(Data item, int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? Colors.grey.withOpacity(0.15)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          _DataCell(
            '#${(index + 1).toString().padLeft(2, '0')}',
            50,
            color: Colors.grey[600],
          ),
          _DataCell(
            '₹${_formatAmount(item.loanAmount ?? 0)}',
            80,
            bold: true,
            color: const Color(0xff3B82F6),
          ),
          _DataCell('${item.loanTenureMonths ?? 0} Months', 80),
          _vehicleCell(item, isDark),
          _DataCell(
            '₹${_formatAmount(item.dtiCalculation?.maxEligibleLoanAmount ?? 0)}',
            80,
            color: const Color(0xff10B981),
            bold: true,
          ),
          _statusChip(item.applicationStatus?.currentStage ?? '-', isDark),
          _actionButton(isDark, item),
        ],
      ),
    );
  }

  // ---------------- VEHICLE CELL WITH ICON ----------------
  Widget _vehicleCell(Data item, bool isDark) {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_car,
              size: 18,
              color: Color(0xff3B82F6),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.vehicleInfo?.vehicleBrand ?? 'No Brand',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                    fontFamily: AppFonts.opensansRegular,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.vehicleInfo?.vehicleModel ?? 'No Model',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: AppFonts.opensansRegular,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- FORMAT AMOUNT ----------------
  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final value = amount is int ? amount : int.tryParse(amount.toString()) ?? 0;
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(2)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

// ---------------- HEADER CELL ----------------
class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _HeaderCell(this.text, this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[700],
          letterSpacing: 0.2,
          fontFamily: AppFonts.opensansRegular,
        ),
      ),
    );
  }
}

// ---------------- DATA CELL ----------------
class _DataCell extends StatelessWidget {
  final String text;
  final double width;
  final bool bold;
  final Color? color;

  const _DataCell(this.text, this.width, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
          color: color,
          fontFamily: AppFonts.opensansRegular,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ---------------- STATUS CHIP ----------------
Widget _statusChip(String status, bool isDark) {
  Color backgroundColor;
  Color textColor;
  IconData icon;

  if (status.contains('Stage1')) {
    backgroundColor = const Color(0xffDCFCE7);
    textColor = Colors.red;
    icon = Icons.edit_document;
  } else if (status.contains('Stage2')) {
    backgroundColor = const Color(0xffDCEEFF);
    textColor = const Color(0xff1E40AF);
    icon = Icons.pending_actions;
  } else if (status == 'Submitted') {
    backgroundColor = const Color(0xffD1FAE5);
    textColor = Colors.green;
    icon = Icons.check_circle;
  } else {
    backgroundColor = Colors.grey.shade200;
    textColor = Colors.grey.shade700;
    icon = Icons.info_outline;
  }

  if (isDark) {
    backgroundColor = backgroundColor.withOpacity(0.2);
    textColor = textColor.withOpacity(0.9);
  }

  return SizedBox(
    width: 120,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              status.replaceAll('_', ' '),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: AppFonts.opensansRegular,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------- ACTION BUTTON ----------------
Widget _actionButton(bool isDark, Data item) {
  return SizedBox(
    width: 100,
    height: 35,
    child: ElevatedButton.icon(
      onPressed: () {
        Get.toNamed(RouteName.applicationDetailsScreen, arguments: item.sId);
      },
      icon: const Icon(Icons.visibility, size: 16),
      label: Text(
        'View',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.opensansRegular,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff3B82F6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    ),
  );
}
