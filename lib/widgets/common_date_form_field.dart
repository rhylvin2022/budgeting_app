import 'dart:async';

import 'package:budgeting_app/global/alert_dialog_popper.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///developed by: Rhylvin March 2023
///date picker with the same ui as the common_text_form_field
class CommonDateFormField extends StatefulWidget {
  final String dateFormTitle;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function dateSelected;
  final double? horizontalPadding;
  final String errorText;
  final int? firstYear;
  final int? lastYearIncrement;
  final DateTime? initialDate;
  final bool required;
  const CommonDateFormField({
    super.key,
    required this.dateFormTitle,
    required this.controller,
    this.focusNode,
    required this.dateSelected,
    this.horizontalPadding = 0,
    this.errorText = '',
    this.firstYear = 1950,
    this.lastYearIncrement = 30,
    this.initialDate,
    this.required = false,
  });

  @override
  State<CommonDateFormField> createState() => _CommonDateFormFieldState();
}

class _CommonDateFormFieldState extends State<CommonDateFormField> {
  DateTime selectedDate = DateTime.now();

  bool initialColor = true;
  @override
  void initState() {
    greyOutFirstFunction();
    super.initState();
  }

  void greyOutFirstFunction() {
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        initialColor = false;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    AlertDialogPopper.setEnabled();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialDate ?? selectedDate,
        firstDate: DateTime(widget.firstYear!),
        lastDate: DateTime(DateTime.now().year + widget.lastYearIncrement!),
        builder: (BuildContext dialogContext, Widget? child) {
          AlertDialogPopper.setDialogContext(dialogContext);
          return child!;
        }).then((DateTime? selectedDate) async {
      if (selectedDate != null) {
        // Do something with the selected date
        setState(() {
          selectedDate = selectedDate;
          String stringDateSelected =
              DateFormat('MM/dd/yyyy').format(selectedDate!);
          widget.controller.text = stringDateSelected;
        });
        widget.dateSelected();
        AlertDialogPopper.setDisabled();
      } else {
        AlertDialogPopper.setDisabled();
      }
      return null;
    });

    if (picked != null && picked != selectedDate) {
      AlertDialogPopper.setDisabled();
    }
  }

  @override
  void dispose() {
    AlertDialogPopper.popDialogContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            /// input field title
            Row(
              children: [
                Text(
                  widget.dateFormTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi-Medium',
                    color: AppColors.colorThemeText,
                  ),
                ),
              ],
            ),

            /// spacing
            const SizedBox(
              height: 10,
            ),

            /// date picker
            Focus(
              onFocusChange: (bool hasFocus) {},
              child: GestureDetector(
                onTap: () {
                  ButtonConflictPrevention.activate(() {
                    _selectDate(context);
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    TextFormField(
                      enabled: false,
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      autocorrect: false,
                      style: TextStyle(
                        color: AppColors.colorThemeText,
                        fontSize: 16,
                        fontFamily: 'Satoshi-Regular',
                      ),
                      cursorColor: AppColors.primaryColor,
                      onTap: () {},
                      onEditingComplete: () {
                        widget.focusNode?.unfocus();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: AppColors.colorThemeText,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: initialColor
                                  ? AppColors.grey
                                  : widget.required
                                      ? widget.controller.text == ''
                                          ? AppColors.red
                                          : widget.errorText == ''
                                              ? AppColors.grey
                                              : AppColors.red
                                      : widget.errorText == ''
                                          ? AppColors.grey
                                          : AppColors.red,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.errorText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Satoshi-Regular',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
