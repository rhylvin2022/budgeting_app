import 'package:base_code/global/app_colors.dart';
import 'package:base_code/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final double buttonWidthRatio;
  final bool enabled;
  final Function? onPressed;
  final bool removeArrowWidget;
  final double roundedRectangleRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? textFontSize;
  final Widget? leading;
  final bool lightButton;
  final double? buttonHeightRatio;
  final bool centerText;
  final bool arrowForwardDirection;

  PrimaryButton({
    Key? key,
    required this.buttonText,
    this.enabled = true,
    this.buttonWidthRatio = 0.5,
    this.onPressed,
    this.removeArrowWidget = false,
    this.roundedRectangleRadius = 13,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.textFontSize = 19,
    this.leading,
    this.lightButton = false,
    this.buttonHeightRatio = .07,
    this.centerText = true,
    this.arrowForwardDirection = true,
  }) : super(key: key);
  final WidgetStatesController controller = WidgetStatesController();

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
          child: ElevatedButton(
            statesController: controller,
            style: ButtonStyle(
              elevation: WidgetStateProperty.all<double>(1),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedRectangleRadius),
                ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.enabledPrimaryButtonColorTheme;
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.disabledPrimaryButtonColorTheme;
                  }
                  return AppColors.enabledPrimaryButtonColorTheme;
                },
              ),
              textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return TextStyle(
                      fontSize: textFontSize,
                      fontFamily: 'Satoshi-Regular',
                      color: Colors.white,
                    );
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return TextStyle(
                      fontSize: textFontSize,
                      fontFamily: 'Satoshi-Regular',
                      color: Colors.white,
                    );
                  }
                  return TextStyle(
                    fontSize: textFontSize,
                    fontFamily: 'Satoshi-Regular',
                    color: Colors.white,
                  );
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.white;
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.grey;
                  }
                  return AppColors.white;
                },
              ),
            ),
            onPressed: enabled
                ? () {
                    ButtonConflictPrevention.activate(() {
                      onPressed!();
                    });
                  }
                : null,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: leading == null ? 0 : 30),
                  child: Row(
                    mainAxisAlignment: centerText
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                removeArrowWidget
                    ? Container()
                    : Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          arrowForwardDirection
                              ? Icons.arrow_forward
                              : Icons.arrow_back,
                          color: lightButton
                              ? AppColors.primaryColor
                              : enabled
                                  ? Colors.white
                                  : Colors.grey,
                          size: 25,
                        ),
                      ),
                leading != null
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: leading!,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
}
