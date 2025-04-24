import 'package:budgeting_app/global/app_strings.dart';
import 'package:budgeting_app/blocs/authentication/authentication_bloc.dart';
import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/blocs/sample_bloc/sample_bloc_bloc.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/enums.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:budgeting_app/widgets/card_content.dart';
import 'package:budgeting_app/widgets/common_date_form_field.dart';
import 'package:budgeting_app/widgets/common_dropdown_button.dart';
import 'package:budgeting_app/widgets/input_field.dart';
import 'package:budgeting_app/widgets/mobile_app_bar.dart';
import 'package:budgeting_app/widgets/mobile_scaffold.dart';
import 'package:budgeting_app/widgets/primary_button.dart';
import 'package:budgeting_app/widgets/single_choice_row_buttons.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateLogPage extends BaseView {
  const CreateLogPage({super.key});

  @override
  CreateLogPageState createState() => CreateLogPageState();
}

class CreateLogPageState extends BaseViewState {
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
        ],
        child: MobileAppBar(
          context: context,
          title: 'Add Item',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                    InputField(
                      inputTitle:
                          AppLocalizations.of(context)!.translate("title") ??
                              "Title",
                      controller: titleController,
                      onSubmitComplete: (val) {},
                      onChanged: (val) {},
                      onEditingComplete: () {},
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) {
                              return;
                            }
                          });
                        }),
                    InputField(
                      inputTitle: 'Amount',
                      controller: amountController,
                      onSubmitComplete: (val) {},
                      onChanged: (val) {},
                      onEditingComplete: () {},
                      align: TextAlign.right,
                      validationType: ValidationType.amount,
                      inputType: KeyBoardType.number,
                      textColor: expense ? AppColors.red : AppColors.black,
                    ),
                    InputField(
                      inputTitle: 'Remarks',
                      controller: remarksController,
                      onSubmitComplete: (val) {},
                      onChanged: (val) {},
                      onEditingComplete: () {},
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
                // enabled: checkWhichToVerify(),
                onPressed: () async {
                  //   if (validateAmountMax(
                  //       double.parse(amountController.text.replaceAll(',', '')),
                  //       double.parse(
                  //           displayWalletCardWithAccountBalances[walletCurrentIndex]
                  //               .accountBalance!
                  //               .availableBalance!))) {
                  //     setState(() {
                  //       redirectLoading = true;
                  //     });
                  //     await setUpTransaction(false);
                  //     if (bankType == 0 || networkUsed == "INSTAPAY") {
                  //       context.beamToNamed(
                  //         NavigationRoutes.SEND_MONEY_VERIFY_TRANSACTION_DETAILS,
                  //         data: sendMoneyArgs,
                  //       );
                  //     } else if (networkUsed == "PESONET") {
                  //       openConfirmationAlertBox(
                  //           title: "Reminder!",
                  //           bodyFont: kIsWeb ? null : 14,
                  //           body: AppLocalizations.of(context)!
                  //               .translate("pesonet_warning") ??
                  //               '',
                  //           onConfirm: () {
                  //             context.beamToNamed(
                  //               NavigationRoutes
                  //                   .SEND_MONEY_VERIFY_TRANSACTION_DETAILS,
                  //               data: sendMoneyArgs,
                  //             );
                  //           });
                  //     } else {}
                  //   } else {
                  //     openErrorAlertBox(
                  //       substituteText: AppLocalizations.of(context)!
                  //           .translate("not_enough_balance") ??
                  //           '',
                  //     );
                  //   }
                },
              ),
              VerticalSpace(
                spaceMultiplier: 0.1,
              ),
            ],
          ),
        ),
      );
}
