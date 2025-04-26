import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/enums.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

class PositionedCircularButton extends StatefulWidget {
  final Function onTap;
  final Icon icon;
  final bool usePositioned;
  final PositionPoint? positionPoint;
  const PositionedCircularButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.usePositioned = true,
    this.positionPoint,
  });

  @override
  State<PositionedCircularButton> createState() =>
      _PositionedCircularButtonState();
}

class _PositionedCircularButtonState extends State<PositionedCircularButton> {
  double? bottom;

  double? left;

  double? right;

  double? top;
  MainAxisAlignment axisAlignment = MainAxisAlignment.start;

  @override
  void initState() {
    setPositionPoint();
    super.initState();
  }

  void setPositionPoint() {
    switch (widget.positionPoint) {
      case PositionPoint.topLeft:
        setState(() {
          bottom = null;
          left = 20;
          right = null;
          top = 70;
          axisAlignment = MainAxisAlignment.start;
        });
        break;
      case PositionPoint.topRight:
        setState(() {
          bottom = null;
          left = null;
          right = 20;
          top = 70;
          axisAlignment = MainAxisAlignment.end;
        });
        break;
      case PositionPoint.bottomCenter:
        setState(() {
          bottom = 40;
          left = 0;
          right = 0;
          top = null;
          axisAlignment = MainAxisAlignment.center;
        });
        break;
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.usePositioned
      ? Positioned(
          bottom: bottom,
          left: left,
          right: right,
          top: top,
          child: content(),
        )
      : Row(
          mainAxisAlignment: axisAlignment,
          children: [
            content(),
          ],
        );

  Widget content() => Center(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            ButtonConflictPrevention.activate(() {
              widget.onTap();
            });
          },
          shape: const CircleBorder(),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          child: widget.icon,
        ),
      );
}
