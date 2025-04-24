import 'package:budgeting_app/global/app_colors.dart';
import 'package:flutter/material.dart';

///developed by: Rhylvin September 2023
class CardContent extends StatelessWidget {
  final Widget child;
  const CardContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(width: 0.5, color: AppColors.grey),
        ),
        color: AppColors.white,
        child: child,
      );
}
