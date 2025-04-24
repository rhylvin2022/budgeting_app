import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double? spaceMultiplier;
  const VerticalSpace({super.key, this.spaceMultiplier = 0.03});

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * spaceMultiplier!);
}
