import 'package:budgeting_app/global/app_colors.dart';
import 'package:flutter/material.dart';

class MobileScaffold extends StatelessWidget {
  final Widget child;
  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        ),
      );
}
