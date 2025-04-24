import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

class PositionedCircularButton extends StatelessWidget {
  final double? bottom;
  final double? left;
  final double? right;
  final double? top;
  final Function onTap;
  final Icon icon;
  const PositionedCircularButton({
    super.key,
    this.bottom,
    this.left,
    this.right,
    this.top,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Positioned(
        bottom: bottom,
        left: left,
        right: right,
        top: top,
        child: Center(
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
              ButtonConflictPrevention.activate(() {
                onTap();
              });
            },
            shape: const CircleBorder(),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            child: icon,
          ),
        ),
      );
}
