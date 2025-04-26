import 'package:budgeting_app/global/app_colors.dart';
import 'package:flutter/material.dart';

///developed by: Rhylvin September 2023
class CardContent extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final Widget child;
  final Color? backgroundColor;
  const CardContent({
    super.key,
    required this.child,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(width: 0.5, color: AppColors.grey),
        ),
        color: backgroundColor ?? AppColors.colorTheme,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: child,
        ),
      );
}
