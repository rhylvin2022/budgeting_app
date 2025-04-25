import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String buttonText;
  final double buttonWidthRatio;
  final bool enabled;
  final Function? onPressed;
  final double roundedRectangleRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? textFontSize;
  final double? buttonHeightRatio;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.buttonText,
    this.enabled = true,
    required this.onPressed,
    this.buttonWidthRatio = 0.9,
    this.roundedRectangleRadius = 13,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.textFontSize = 19,
    this.buttonHeightRatio = 0.06,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 0,
          horizontal: horizontalPadding ?? 0,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * buttonWidthRatio,
          height:
              MediaQuery.of(context).size.height * (buttonHeightRatio ?? .07),
          child: OutlinedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedRectangleRadius),
                ),
              ),
              overlayColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return AppColors.primaryColor;
                  }
                  if (states.contains(MaterialState.disabled)) {
                    return AppColors.grey;
                  }
                  return AppColors.primaryColor;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const BorderSide(
                      width: 1.5,
                      color: AppColors.primaryColor,
                    );
                  }
                  if (states.contains(MaterialState.disabled)) {
                    return const BorderSide(
                      width: 1.5,
                      color: AppColors.grey,
                    );
                  }
                  return const BorderSide(
                    width: 1.5,
                    color: AppColors.primaryColor,
                  );
                },
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: textFontSize,
                  fontFamily: 'Satoshi-Regular',
                ),
              ),
            ),
            onPressed: enabled
                ? () {
                    ButtonConflictPrevention.activate(() {
                      onPressed?.call();
                    });
                  }
                : null,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Satoshi-Regular',
                  fontSize: textFontSize,
                  color: color),
            ),
          ),
        ),
      );
}
