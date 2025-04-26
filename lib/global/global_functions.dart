import 'package:beamer/beamer.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:swagger/api.dart';
import 'package:intl/intl.dart';

class GlobalFunctions {
  static void beamToReplaceNamed(BuildContext context, String path) {
    context.beamToReplacementNamed(path);
  }

  static void beamToNamed(BuildContext context, String path) {
    context.beamToNamed(path);
  }

  static void beamBack(BuildContext context) {
    context.beamBack();
  }

  static void beamToNamedRootFalse(BuildContext context, String path) {
    Beamer.of(context, root: false).beamToNamed(path);
  }

  static setConversionRate(double conversionRate) =>
      _conversionRate = conversionRate;

  static double _conversionRate = 56.24;

  static double getConversionRate() => _conversionRate;

  static double convertUSDtoPHP(double amountInUSD) =>
      amountInUSD * _conversionRate;

  static Map<String, double> calculateCategoryTotals(List<LogItem> logItems,
      {required bool forExpense}) {
    final Map<String, double> categoryTotals = {};

    for (var item in logItems) {
      if (item.expense == forExpense) {
        String category = item.category!;
        double amount = 0;

        if (item.currency == 'PHP') {
          amount = (item.amount! / 100).toDouble();
        } else {
          amount = convertUSDtoPHP(item.amount! / 100);
        }

        categoryTotals.update(category, (value) => value + amount,
            ifAbsent: () => amount);
      }
    }

    return categoryTotals;
  }

  static String format(double amount) =>
      NumberFormat("#,##0.00", "en_US").format(amount);

  static BarChartData generateBarData(Map<String, double> categoryTotals) {
    final barGroups = <BarChartGroupData>[];
    int index = 0;

    for (var entry in categoryTotals.entries) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(toY: entry.value, width: 15, color: Colors.blue),
          ],
        ),
      );
      index++;
    }

    return BarChartData(
      barGroups: barGroups,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              if (idx >= 0 && idx < categoryTotals.keys.length) {
                return Text(categoryTotals.keys.elementAt(idx),
                    style: const TextStyle(fontSize: 10));
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
    );
  }

  static void setTheme(String theme) => AppColors.setTheme(theme);
}
