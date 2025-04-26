import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/blocs/authentication/authentication_bloc.dart';
import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/blocs/sample_bloc/sample_bloc_bloc.dart';
import 'package:budgeting_app/blocs/settings/settings_bloc.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/app_strings.dart';
import 'package:budgeting_app/global/enums.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:budgeting_app/widgets/card_content.dart';
import 'package:budgeting_app/widgets/input_field.dart';
import 'package:budgeting_app/widgets/mobile_scaffold.dart';
import 'package:budgeting_app/widgets/positioned_circular_button.dart';
import 'package:budgeting_app/widgets/primary_button.dart';
import 'package:budgeting_app/widgets/single_choice_row_buttons.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends BaseView {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends BaseViewState {
  int themeIndex = 0;
  final conversionRateController = TextEditingController();
  final conversionRateKey = GlobalKey<FormState>();
  late String currentConversionRate = '';

  @override
  void initState() {
    showLoadingDialog(context);
    initSettings();
    super.initState();
  }

  void initSettings() {
    context.read<SettingsBloc>().add(GetSettingsTheme());
    context.read<SettingsBloc>().add(GetSettingsConversionRate());
  }

  @override
  Widget rootWidget(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<SampleBlocBloc, SampleBlocState>(
            listener: (context, state) {
              if (state is GetSampleBlocSuccess) {
                hideLoadingDialog(context);
                setState(() {});
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is GetSettingsThemeSuccess) {
                hideLoadingDialog(context);
                setState(() {
                  themeIndex =
                      state.theme == AppStrings.settingsThemes.first ? 0 : 1;
                });
              } else if (state is GetSettingsThemeFail) {
                hideLoadingDialog(context);
                setState(() {});
              } else if (state is SetSettingsThemeSuccess) {
                hideLoadingDialog(context);
                setState(() {});
              } else if (state is GetSettingsThemeFail) {
                hideLoadingDialog(context);
                setState(() {});
              } else if (state is GetSettingsConversionRateSuccess) {
                hideLoadingDialog(context);
                setState(() {
                  currentConversionRate =
                      (double.parse(state.conversionRate) / 100.00)
                          .toDouble()
                          .toStringAsFixed(2);
                  conversionRateController.text = currentConversionRate;
                });
              } else if (state is GetSettingsConversionRateFail) {
                hideLoadingDialog(context);
                setState(() {});
              } else if (state is SetSettingsConversionRateSuccess) {
                hideLoadingDialog(context);
                setState(() {});
                print('You have successfully update the Conversion Rate');
                openSuccessAlertBox(
                  body: AppLocalizations.of(context)!.translate("date") ??
                      "You have successfully update the Conversion Rate",
                  route: NavigationRoutes.login,
                  removeUntilEnabled: true,
                  popUntil: true,
                );
              } else if (state is SetSettingsConversionRateFail) {
                hideLoadingDialog(context);
                setState(() {});
              }
            },
          ),
        ],
        child: Stack(
          children: [
            MobileScaffold(
              child: Column(
                children: [
                  ///back button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PositionedCircularButton(
                      usePositioned: false,
                      positionPoint: PositionPoint.topLeft,
                      onTap: () {
                        GlobalFunctions.beamBack(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  CardContent(
                    child: Column(
                      children: [
                        VerticalSpace(),
                        SingleChoiceRowButtons(
                          title: AppLocalizations.of(context)!
                                  .translate("theme") ??
                              "Theme",
                          currentChosenButtonIndex: themeIndex,
                          buttonNames: AppStrings.settingsThemes,
                          chooseButton: (value) {
                            setState(() {
                              themeIndex = value;
                            });
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) {
                                return;
                              }
                              context.read<SettingsBloc>().add(
                                    SetSettingsTheme(
                                      themeIndex == 0
                                          ? AppStrings.settingsThemes.first
                                          : AppStrings.settingsThemes.last,
                                    ),
                                  );
                            });
                          },
                        ),
                        Form(
                          key: conversionRateKey,
                          child: InputField(
                            maxLength: 20,
                            inputTitle: 'Conversion Rate - USD to PHP',
                            controller: conversionRateController,
                            onSubmitComplete: (val) {
                              setState(() {});
                            },
                            onChanged: (val) {
                              setState(() {});
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            align: TextAlign.right,
                            validationType: ValidationType.amount,
                            inputType: KeyBoardType.number,
                            textColor: AppColors.colorThemeText,
                          ),
                        ),
                        VerticalSpace(),
                      ],
                    ),
                  ),
                  VerticalSpace(
                    spaceMultiplier: 0.05,
                  ),
                  PrimaryButton(
                    buttonText:
                        AppLocalizations.of(context)!.translate("save") ??
                            "Save",
                    buttonWidthRatio: 0.9,
                    enabled: enablePrimaryButton(),
                    onPressed: () async {
                      showLoadingDialog(context);
                      String conversionRate = (double.parse(
                                  conversionRateController.text
                                      .replaceAll(',', '')) *
                              100)
                          .toString();
                      context
                          .read<SettingsBloc>()
                          .add(SetSettingsConversionRate(conversionRate));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  bool enablePrimaryButton() {
    return ((conversionRateKey.currentState?.validate() ?? false) &&
        conversionRateController.text != currentConversionRate);
  }
}
