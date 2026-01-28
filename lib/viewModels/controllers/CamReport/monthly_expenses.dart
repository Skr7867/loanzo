import 'package:flutter/material.dart';

class MonthlyExpense {
  String type;

  /// when type == 'Other'
  TextEditingController otherTypeController;

  TextEditingController amountController;
  TextEditingController noteController;

  MonthlyExpense({
    this.type = 'Rent',
    TextEditingController? otherTypeController,
    required this.amountController,
    required this.noteController,
  }) : otherTypeController = otherTypeController ?? TextEditingController();

  void dispose() {
    amountController.dispose();
    noteController.dispose();
    otherTypeController.dispose();
  }
}
