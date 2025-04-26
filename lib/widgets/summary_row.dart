import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const SummaryRow({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SummaryItem(label: 'Income', amount: income, color: AppColors.green),
        SummaryItem(label: 'Expense', amount: expense, color: AppColors.red),
        SummaryItem(label: 'Balance', amount: balance, color: AppColors.blue),
      ],
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const SummaryItem({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(
          '₱${GlobalFunctions.format(amount)}',
          style: TextStyle(color: color, fontSize: 16),
        ),
      ],
    );
  }
}
