import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/helpers/button_conflict_prevention.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///develop by: Rhylvin April 2023
class SingleChoiceRowButtons extends StatefulWidget {
  final String title;
  final int currentChosenButtonIndex;
  final List<String> buttonNames;
  final Function(int) chooseButton;
  final double? buttonHeightRatio;

  const SingleChoiceRowButtons({
    super.key,
    required this.title,
    required this.currentChosenButtonIndex,
    required this.buttonNames,
    required this.chooseButton,
    this.buttonHeightRatio = .05,
  });

  @override
  State<SingleChoiceRowButtons> createState() => _SingleChoiceRowButtonsState();
}

class _SingleChoiceRowButtonsState extends State<SingleChoiceRowButtons> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Add a listener to the ScrollController to detect when the user releases the drag
      _controller.addListener(() {});
    });
  }

  @override
  build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi-Medium',
                    color: AppColors.colorThemeText,
                  ),
                ),
              ],
            ),

            ///space
            const SizedBox(
              height: 10,
            ),

            ///Row of Buttons
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var i = 0; i < widget.buttonNames.length; i++)
                      _buildValueList(i),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  _buildValueList(int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              (widget.buttonHeightRatio ?? (kIsWeb ? 0.4 : 0.7)),
          width: MediaQuery.of(context).size.width * (kIsWeb ? 0.07 : 0.33),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(1),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              backgroundColor: (index == widget.currentChosenButtonIndex)
                  ? MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.primaryColor;
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return AppColors.disabledPrimaryButtonColorTheme;
                        }
                        return AppColors.primaryColor;
                      },
                    )
                  : MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.disabledPrimaryButtonColorTheme;
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return AppColors.disabledPrimaryButtonColorTheme;
                        }
                        return AppColors.disabledPrimaryButtonColorTheme;
                      },
                    ),
              textStyle: (index == widget.currentChosenButtonIndex)
                  ? MaterialStateProperty.resolveWith<TextStyle?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi-Regular',
                            color: AppColors.white,
                          );
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi-Regular',
                            color: AppColors.white,
                          );
                        }
                        return const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi-Regular',
                          color: AppColors.white,
                        );
                      },
                    )
                  : MaterialStateProperty.resolveWith<TextStyle?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi-Regular',
                            color: AppColors.black,
                          );
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi-Regular',
                            color: AppColors.black,
                          );
                        }
                        return const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi-Regular',
                          color: AppColors.black,
                        );
                      },
                    ),
              foregroundColor: (index == widget.currentChosenButtonIndex)
                  ? MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return AppColors.white;
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return AppColors.white;
                        }
                        return AppColors.white;
                      },
                    )
                  : MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black54;
                        }
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.black54;
                        }
                        return Colors.black54;
                      },
                    ),
            ),
            onPressed: () {
              ButtonConflictPrevention.activate(() {
                widget.chooseButton(index);
              });
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                widget.buttonNames[index],
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
}
