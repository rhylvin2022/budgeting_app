import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/blocs/budget/budget_bloc.dart';
import 'package:budgeting_app/global/app_strings.dart';
import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/blocs/sample_bloc/sample_bloc_bloc.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/enums.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:budgeting_app/widgets/card_content.dart';
import 'package:budgeting_app/widgets/common_date_form_field.dart';
import 'package:budgeting_app/widgets/common_dropdown_button.dart';
import 'package:budgeting_app/widgets/input_field.dart';
import 'package:budgeting_app/widgets/mobile_app_bar.dart';
import 'package:budgeting_app/widgets/mobile_scaffold.dart';
import 'package:budgeting_app/widgets/positioned_circular_button.dart';
import 'package:budgeting_app/widgets/primary_button.dart';
import 'package:budgeting_app/widgets/secondary_button.dart';
import 'package:budgeting_app/widgets/single_choice_row_buttons.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swagger/api.dart';

class CreateLogPage extends BaseView {
  const CreateLogPage({super.key});

  @override
  CreateLogPageState createState() => CreateLogPageState();
}

class CreateLogPageState extends BaseViewState {
  final logKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final dateFocusNode = FocusNode();
  String dateErrorText = '';
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final remarksController = TextEditingController();
  bool expense = true;
  int entryType = 0;
  int currencyType = 0;
  String expenseCategory = AppStrings.expenseCategories.first;
  String incomeCategory = AppStrings.incomeCategories.first;

  @override
  void initState() {
    initDate();
    super.initState();
  }

  void initDate() {
    setState(() {
      dateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    });
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
          BlocListener<BudgetBloc, BudgetState>(
            listener: (context, state) {
              if (state is CreateBudgetLogSuccess) {
                hideLoadingDialog(context);
                setState(() {});
                openConfirmationAlertBox(
                  body: AppLocalizations.of(context)!.translate("date") ??
                      "You have successfully created a Log, Would you like to create another?",
                  title: 'Success!',
                  onDeny: () {
                    GlobalFunctions.beamBack(context);
                  },
                  onConfirm: () {
                    resetFunction();
                  },
                );
              } else if (state is CreateBudgetLogFail) {
                hideLoadingDialog(context);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            MobileScaffold(
              child: Column(
                children: [
                  VerticalSpace(
                    spaceMultiplier: 0.05,
                  ),
                  CardContent(
                    child: Column(
                      children: [
                        VerticalSpace(),
                        SingleChoiceRowButtons(
                            title: AppLocalizations.of(context)!
                                    .translate("entry_type") ??
                                "Entry Type",
                            currentChosenButtonIndex: entryType,
                            buttonNames: AppStrings.entryType,
                            chooseButton: (value) {
                              setState(() {
                                entryType = value;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  expense = entryType == 0;
                                });
                              });
                            }),
                        CommonDateFormField(
                          required: true,
                          controller: dateController,
                          initialDate: DateTime.now(),
                          dateFormTitle:
                              AppLocalizations.of(context)!.translate("date") ??
                                  "Date",
                          focusNode: dateFocusNode,
                          horizontalPadding: 15,
                          errorText: dateErrorText,
                          dateSelected: () {
                            setState(() {});
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              setState(() {});
                            });
                          },
                        ),
                        expense
                            ? CommonDropDownButton(
                                dropdownTitle: AppLocalizations.of(context)!
                                        .translate("expense_category") ??
                                    "Expense Category",
                                valueList: AppStrings.expenseCategories,
                                currentValue: expenseCategory,
                                includeSearchBar: true,
                                onValueChange: (value) {
                                  setState(() {
                                    expenseCategory = value;
                                  });
                                },
                              )
                            : CommonDropDownButton(
                                dropdownTitle: AppLocalizations.of(context)!
                                        .translate("income_category") ??
                                    "Income Category",
                                valueList: AppStrings.incomeCategories,
                                currentValue: incomeCategory,
                                includeSearchBar: true,
                                onValueChange: (value) {
                                  setState(() {
                                    incomeCategory = value;
                                  });
                                },
                              ),
                        Form(
                          key: logKey,
                          child: Column(
                            children: [
                              InputField(
                                minLength: 3,
                                maxLength: 50,
                                inputTitle: AppLocalizations.of(context)!
                                        .translate("title") ??
                                    "Title",
                                controller: titleController,
                                onSubmitComplete: (val) {
                                  setState(() {});
                                },
                                onChanged: (val) {
                                  setState(() {});
                                },
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                validationType: ValidationType.normal,
                                textColor: AppColors.colorThemeText,
                              ),
                              SingleChoiceRowButtons(
                                  title: AppLocalizations.of(context)!
                                          .translate("currency") ??
                                      "Currency",
                                  currentChosenButtonIndex: currencyType,
                                  buttonNames: AppStrings.currencies,
                                  chooseButton: (value) {
                                    setState(() {
                                      currencyType = value;
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!mounted) {
                                        return;
                                      }
                                    });
                                  }),
                              InputField(
                                maxLength: 20,
                                inputTitle: 'Amount',
                                controller: amountController,
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
                                textColor: expense
                                    ? AppColors.red
                                    : AppColors.colorThemeText,
                                prefixText: currencyType == 0 ? 'PHP' : 'USD',
                              ),
                            ],
                          ),
                        ),
                        InputField(
                          inputTitle: 'Remarks',
                          controller: remarksController,
                          dontValidate: true,
                          optional: true,
                          onSubmitComplete: (val) {
                            setState(() {});
                          },
                          onChanged: (val) {
                            setState(() {});
                          },
                          onEditingComplete: () {
                            setState(() {});
                          },
                          textColor: AppColors.colorThemeText,
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
                        AppLocalizations.of(context)!.translate("create_log") ??
                            "Create Log",
                    buttonWidthRatio: 0.9,
                    enabled: enablePrimaryButton(),
                    onPressed: () async {
                      showLoadingDialog(context);
                      final logItem = LogItem();
                      logItem.expense = expense;
                      logItem.category =
                          expense ? expenseCategory : incomeCategory;
                      logItem.title = titleController.text;
                      logItem.date = dateController.text;
                      logItem.currency = currencyType == 0 ? 'PHP' : 'USD';
                      logItem.amount = (double.parse(
                                  amountController.text.replaceAll(',', '')) *
                              100)
                          .toInt();
                      logItem.remarks = remarksController.text ?? '';
                      context.read<BudgetBloc>().add(CreateBudgetLog(logItem));
                    },
                  ),
                  VerticalSpace(),
                  SecondaryButton(
                      buttonText: 'Reset',
                      onPressed: () {
                        resetFunction();
                      }),
                  VerticalSpace(
                    spaceMultiplier: 0.1,
                  ),
                ],
              ),
            ),

            ///back button
            PositionedCircularButton(
              bottom: null,
              left: 20,
              right: null,
              top: 70,
              onTap: () {
                GlobalFunctions.beamBack(
                  context,
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
      );

  void resetFunction() {
    setState(() {
      initDate();
      entryType = 0;
      expense = true;
      expenseCategory = AppStrings.expenseCategories.first;
      incomeCategory = AppStrings.incomeCategories.first;
      titleController.text = '';
      amountController.text = '';
      currencyType = 0;
      remarksController.text = '';
    });
  }

  bool enablePrimaryButton() {
    return (expense
            ? expenseCategory != AppStrings.expenseCategories.first
            : incomeCategory != AppStrings.incomeCategories.first) &&
        (logKey.currentState?.validate() ?? false);
  }
}
