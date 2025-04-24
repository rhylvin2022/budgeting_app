// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:budgeting_app/global/alert_dialog_popper.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/material.dart';

///developed by: Rhylvin May 2023
class CommonDropDownButton extends StatefulWidget {
  final String dropdownTitle;
  String? currentValue;
  final double horizontalPadding;
  final FocusNode? focusNode;
  final List<String> valueList;
  final Function(String)? onValueChange;
  final bool disableDropdown;
  final int truncateLength;
  final int maxCountUntilScrollable;
  final bool includeSearchBar;
  final String loadIfValueIs;
  CommonDropDownButton({
    super.key,
    required this.dropdownTitle,
    this.horizontalPadding = 20,
    this.focusNode,
    required this.valueList,
    required this.currentValue,
    this.onValueChange,
    this.disableDropdown = false,
    this.truncateLength = 30,
    this.maxCountUntilScrollable = 10,
    this.includeSearchBar = false,
    this.loadIfValueIs = '',
  });

  @override
  CommonDropDownButtonState createState() => CommonDropDownButtonState();
}

bool mobileHeightIsTooLow(BuildContext context) =>
    MediaQuery.of(context).size.height < 700;

bool mobileHeightIsTooLarge(BuildContext context) =>
    MediaQuery.of(context).size.height > 900;

class CommonDropDownButtonState extends State<CommonDropDownButton> {
  final GlobalKey buttonKey = GlobalKey();
  final ScrollController _controller1 = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Add a listener to the ScrollController to detect when the user releases the drag
      _controller1.addListener(() {});
    });
  }

  @override
  void dispose() {
    AlertDialogPopper.popDialogContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              controller: _controller1,
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.dropdownTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi-Medium',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
              child: IgnorePointer(
                ignoring: widget.disableDropdown,
                child: ElevatedButton(
                  key: buttonKey,
                  onPressed: () {
                    ButtonConflictPrevention.activate(() {
                      openDropdownDialog();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: widget.disableDropdown
                        ? AppColors.disabledPrimaryButtonColorTheme
                        : AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      side: BorderSide(
                          color: widget.currentValue == widget.valueList.first
                              ? AppColors.red
                              : AppColors.grey),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.loadIfValueIs != '' &&
                                widget.loadIfValueIs == widget.currentValue
                            ? '...'
                            : truncateName(widget.currentValue ?? ''),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Satoshi-Regular',
                        ),
                      ),
                      widget.disableDropdown
                          ? Container()
                          : const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  String truncateName(String value) {
    try {
      if (value.length > widget.truncateLength) {
        return '${value.substring(0, widget.truncateLength)}...';
      } else {
        return value;
      }
    } catch (e) {
      return value;
    }
  }

  double previousMaxHeight = 0;
  double previousMaxWidth = 0;

  ///developed by: Rhylvin February 2024
  ///recreated dropdown to be an alert dialog
  ///to be able to use listview instead of dropdown
  ///so that I can listen to scrolling and be able to
  ///execute InactivityTimer.reset() if dropdown items are being scrolled
  void openDropdownDialog() async {
    AlertDialogPopper.setEnabled();
    int itemCount = widget.valueList.length;
    double multiplier = MediaQuery.of(context).size.height *
        mobileHeightMultiplier(context: context);
    double currentHeight = itemCount * multiplier;
    double maxHeight = widget.maxCountUntilScrollable * multiplier;

    double dialogHeight = currentHeight < maxHeight ? currentHeight : maxHeight;

    double doubleDialogHeight = multiplier * 2;

    final RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    double dialogTop = offset.dy + renderBox.size.height;
    double screenHeight = MediaQuery.of(context).size.height;

    if (dialogHeight > (screenHeight / 2)) {
      dialogTop = (screenHeight - dialogHeight) / 2;
    } else {
      if (dialogTop + dialogHeight > screenHeight) {
        // If the dropdown extends below the screen, adjust it to appear above
        dialogTop = offset.dy - dialogHeight;
      } else {
        // Otherwise, normal positioning
        dialogTop = dialogTop - 8.0;
      }
    }

    final selectedValue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext dialogContext, BoxConstraints constraints) {
            AlertDialogPopper.setDialogContext(dialogContext);
            if (shouldResetDialog(constraints)) {
              if (!(previousMaxHeight == 0 && previousMaxWidth == 0)) {
                Navigator.pop(context);
              }
              previousMaxHeight = constraints.maxHeight;
              previousMaxWidth = constraints.maxWidth;
            }

            return StatefulDropdown(
              currentValue: widget.currentValue,
              dialogHeight: dialogHeight,
              dialogTop: dialogTop,
              includeSearchBar: widget.includeSearchBar,
              offset: offset,
              statefulDropdownContext: dialogContext,
              valueList: widget.valueList,
              onValueChange: widget.onValueChange,
            );
          },
        );
      },
    );

    if (selectedValue != null) {}
    AlertDialogPopper.setDisabled();
  }

  bool shouldResetDialog(BoxConstraints constraints) {
    return constraints.maxHeight != previousMaxHeight ||
        constraints.maxWidth != previousMaxWidth;
  }

  double webMultiplier({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
    return height >= 1071
        ? 0.05
        : height <= 1070 && height >= 855
            ? 0.05
            : height <= 854 && height >= 675
                ? 0.065
                : height <= 674
                    ? 0.08
                    : 0.05;
  }

  double webTopOffset({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;

    return height >= 1071
        ? 15.0
        : height <= 1070 && height >= 855
            ? 15.0
            : height <= 854 && height >= 675
                ? 20.0
                : height <= 674
                    ? 25.0
                    : 15.0;
  }

  double mobileHeightMultiplier({required BuildContext context}) {
    return Platform.isAndroid
        ? mobileHeightIsTooLow(context)
            ? 0.09
            : mobileHeightIsTooLarge(context)
                ? 0.06
                : 0.07
        : mobileHeightIsTooLow(context)
            ? 0.07
            : mobileHeightIsTooLarge(context)
                ? 0.06
                : 0.0675;
  }
}

class StatefulDropdown extends StatefulWidget {
  final BuildContext statefulDropdownContext;
  final double dialogTop;
  final double dialogHeight;
  final Offset offset;
  final bool includeSearchBar;
  String? currentValue;
  final Function(String)? onValueChange;
  final List<String> valueList;
  StatefulDropdown({
    super.key,
    required this.statefulDropdownContext,
    required this.dialogTop,
    required this.dialogHeight,
    required this.offset,
    required this.includeSearchBar,
    required this.currentValue,
    required this.valueList,
    this.onValueChange,
  });

  @override
  StatefulDropdownState createState() => StatefulDropdownState();
}

class StatefulDropdownState extends State<StatefulDropdown> {
  TextEditingController searchBarController = TextEditingController();
  final ScrollController _controller2 = ScrollController();
  FocusNode searchBarFocusNode = FocusNode();

  late List<String> searchValueList = widget.valueList;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Add a listener to the ScrollController to detect when the user releases the drag
      _controller2.addListener(() {});
    });
    searchBarFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: widget.dialogTop -
                (mobileHeightIsTooLow(context)
                    ? 30.0
                    : mobileHeightIsTooLarge(context)
                        ? 70.0
                        : 60.0),
            left: null,
            child: AlertDialog(
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: widget.includeSearchBar
                    ? Column(
                        children: [
                          searchBar(),
                          dropdownWidget(widget.dialogHeight,
                              widget.statefulDropdownContext)
                        ],
                      )
                    : dropdownWidget(
                        widget.dialogHeight, widget.statefulDropdownContext)),
          ),
        ],
      );

  Widget dropdownWidget(double dialogHeight, BuildContext _dropdownContext) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: dialogHeight,
        child: ListView(
          controller: _controller2,
          padding: EdgeInsets.zero,
          children: searchValueList.map((String value) {
            return ListTile(
              title: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Satoshi-Regular',
                ),
              ),
              onTap: () {
                setState(() {
                  widget.currentValue = value;
                  widget.onValueChange?.call(value);
                });
                Navigator.pop(_dropdownContext, value);
                AlertDialogPopper.setDisabled();
              },
            );
          }).toList(),
        ),
      );

  Widget searchBar() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: TextField(
            focusNode: searchBarFocusNode,
            maxLength: 30,
            cursorColor: AppColors.primaryColor,
            textAlign: TextAlign.left,
            controller: searchBarController,
            decoration: const InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.all(15),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 3),
                child: Icon(
                  Icons.search,
                  size: 28,
                  color: Colors.grey,
                ),
              ),
            ),
            onChanged: (String value) {
              if (value.isNotEmpty) {
                setState(() {
                  searchValueList = widget.valueList
                      .where((element) =>
                          element.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              } else {
                setState(() {
                  searchValueList = widget.valueList;
                });
              }
            },
          ),
        ),
      );

  double webLeftOffset({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;

    return height >= 1071
        ? 12.0
        : height <= 1070 && height >= 855
            ? 12.0
            : height <= 854 && height >= 675
                ? 20.0
                : height <= 674
                    ? 25.0
                    : 15.0;
  }
}
