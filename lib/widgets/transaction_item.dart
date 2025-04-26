// ignore_for_file: import_of_legacy_library_into_null_safe, no_logic_in_create_state, unnecessary_null_comparison

import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/widgets/card_content.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swagger/api.dart';

///developed by: Rhylvin June 2023
class TransactionItem extends StatelessWidget {
  final LogItem logItem;
  final int truncateLength;
  const TransactionItem({
    super.key,
    required this.logItem,
    this.truncateLength = 30,
  });

  final int mobileTruncateLengthDifference = 5;
  @override
  Widget build(BuildContext context) {
    String formattedNumberString = formattedNumber(logItem.amount! / 100);
    String amount =
        '${logItem.expense! ? '-' : '+'} ${logItem.currency ?? 'PHP'} $formattedNumberString';
    return CardContent(
      backgroundColor: AppColors.colorThemeCardContentMultiple,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              VerticalSpace(
                spaceMultiplier: 0.01,
              ),

              ///time
              Row(
                children: [
                  Text(
                    logItem.date!,
                    style: TextStyle(
                      color: AppColors.colorThemeText,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),

              ///category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    truncateDescription(logItem.category!),
                    style: TextStyle(
                      color: AppColors.colorThemeText,
                      fontSize: 13.0,
                    ),
                  ),
                  Row(
                    children: [
                      ///amount
                      Text(
                        amount,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: logItem.expense! ? Colors.red : Colors.green,
                            fontSize: 13.0),
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),

              ///title
              Row(
                children: [
                  Text(
                    truncateDescription(logItem.title!),
                    style: TextStyle(
                      color: AppColors.colorThemeText,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),

              ///remarks
              Row(
                children: [
                  Text(
                    truncateDescription(logItem.remarks!),
                    style: TextStyle(
                      color: AppColors.colorThemeText,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              VerticalSpace(
                spaceMultiplier: 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formattedNumber(double amount) =>
      amount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );

  String formattedDate(DateTime date) => DateFormat('MM/dd/yyyy').format(date);

  DateTime parseDateString(String dateString) =>
      DateFormat("MM/dd/yyyy").parse(dateString);

  String truncateDescription(String value) {
    int _truncateLength = kIsWeb
        ? truncateLength
        : (truncateLength - mobileTruncateLengthDifference);
    try {
      if (value.length > _truncateLength) {
        return '${value.substring(0, _truncateLength)}...';
      } else {
        return value;
      }
    } catch (e) {
      return value;
    }
  }
}
