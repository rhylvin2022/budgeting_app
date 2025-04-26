import 'package:budgeting_app/beamer/navigation_routes.dart';
import 'package:budgeting_app/blocs/budget/budget_bloc.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:budgeting_app/widgets/base_view.dart';
import 'package:budgeting_app/widgets/card_content.dart';
import 'package:budgeting_app/widgets/log_item_pie_chart.dart';
import 'package:budgeting_app/widgets/mobile_scaffold.dart';
import 'package:budgeting_app/widgets/positioned_circular_button.dart';
import 'package:budgeting_app/widgets/summary_row.dart';
import 'package:budgeting_app/widgets/transaction_item.dart';
import 'package:budgeting_app/widgets/vertical_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swagger/api.dart';
import 'package:intl/intl.dart';

class LoginPage extends BaseView {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends BaseViewState {
  List<LogItem> logItems = [];
  List<LogItem> futureLogItems = [];
  List<LogItem> todayLogItems = [];
  List<LogItem> yesterdayLogItems = [];
  List<LogItem> previousLogItems = [];
  bool displayLogs = false;
  double totalIncome = 0;
  double totalExpense = 0;
  double totalBalance = 0;
  @override
  void initState() {
    loadLogTransactions();
    super.initState();
  }

  void loadLogTransactions() {
    showLoadingDialog(context);
    context.read<BudgetBloc>().add(LoadBudgetLog());
  }

  @override
  Widget rootWidget(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<BudgetBloc, BudgetState>(listener: (context, state) {
            if (state is LoadBudgetLogSuccess) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final yesterday = today.subtract(Duration(days: 1));

              double totalExpenseInPHP = 0;
              double totalIncomeInPHP = 0;
              double totalExpenseInUSD = 0;
              double totalIncomeInUSD = 0;

              for (var logItem in state.logItems) {
                DateTime actualDate =
                    DateFormat("MM/dd/yyyy").parse(logItem.date!);
                DateTime logDate =
                    DateTime(actualDate.year, actualDate.month, actualDate.day);

                if (logDate == today) {
                  todayLogItems.add(logItem);
                } else if (logDate == yesterday) {
                  yesterdayLogItems.add(logItem);
                } else if (logDate.isAfter(today)) {
                  futureLogItems.add(logItem);
                } else {
                  previousLogItems.add(logItem);
                }

                if (logItem.currency == 'PHP') {
                  if (logItem.expense!) {
                    totalExpenseInPHP += (logItem.amount! / 100);
                  } else {
                    totalIncomeInPHP += (logItem.amount! / 100);
                  }
                } else {
                  if (logItem.expense!) {
                    totalExpenseInUSD += (logItem.amount! / 100);
                  } else {
                    totalIncomeInUSD += (logItem.amount! / 100);
                  }
                }
              }
              setState(() {
                logItems = state.logItems;
                totalExpense = totalExpenseInPHP +
                    GlobalFunctions.convertUSDtoPHP(totalExpenseInUSD);
                totalIncome = totalIncomeInPHP +
                    GlobalFunctions.convertUSDtoPHP(totalIncomeInUSD);
                totalBalance = totalIncome - totalExpense;
                displayLogs = true;
              });
              hideLoadingDialog(context);
            } else if (state is LoadBudgetLogSuccessNoData) {
              hideLoadingDialog(context);
            } else if (state is LoadBudgetLogFail) {
              hideLoadingDialog(context);
            }
          }),
        ],
        child: Stack(
          children: [
            MobileScaffold(
              child: displayLogs
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          VerticalSpace(
                            spaceMultiplier: 0.05,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CardContent(
                              horizontalPadding: 20,
                              verticalPadding: 20,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    VerticalSpace(
                                      spaceMultiplier: 0.02,
                                    ),

                                    ///content
                                    Column(
                                      children: [
                                        ///future
                                        futureContent(),

                                        ///today
                                        todayContent(),

                                        ///yesterday
                                        yesterdayContent(),

                                        ///previous transactions
                                        previousContent(),

                                        ///space
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                        ),
                                      ],
                                    ),
                                    VerticalSpace(
                                      spaceMultiplier: 0.02,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalSpace(),
                          SummaryRow(
                            balance: totalBalance,
                            expense: totalExpense,
                            income: totalIncome,
                          ),
                          LogItemPieChart(
                            logItems: logItems,
                          ),
                          VerticalSpace(
                            spaceMultiplier: 0.07,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [],
                    ),
            ),

            ///add button
            PositionedCircularButton(
              bottom: 40,
              left: 0,
              right: 0,
              top: null,
              onTap: () {
                GlobalFunctions.beamToNamed(
                    context, NavigationRoutes.createLog);
              },
              icon: Icon(Icons.add),
            ),

            ///settings button
            PositionedCircularButton(
              bottom: null,
              left: null,
              right: 20,
              top: 70,
              onTap: () {
                GlobalFunctions.beamToNamed(context, NavigationRoutes.settings);
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      );

  Widget futureContent() {
    try {
      bool empty = futureLogItems.isEmpty;
      if (empty) {
        return Container();
      } else {
        return Column(
          children: [
            ///date item
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Future Dates',
                          style: TextStyle(
                            color: AppColors.colorThemeText,
                            fontSize: 11.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(
              spaceMultiplier: 0.01,
            ),
            for (var logItem in futureLogItems)
              TransactionItem(logItem: logItem),
          ],
        );
      }
    } catch (e) {
      return Container();
    }
  }

  Widget todayContent() {
    try {
      bool empty = todayLogItems.isEmpty;
      if (empty) {
        return Container();
      } else {
        return Column(
          children: [
            ///date item
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Today',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(
              spaceMultiplier: 0.01,
            ),
            for (var logItem in todayLogItems)
              TransactionItem(logItem: logItem),
          ],
        );
      }
    } catch (e) {
      return Container();
    }
  }

  Widget yesterdayContent() {
    try {
      bool empty = yesterdayLogItems.isEmpty;
      if (empty) {
        return Container();
      } else {
        return Column(
          children: [
            ///date item
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Yesterday',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(
              spaceMultiplier: 0.01,
            ),
            for (var logItem in yesterdayLogItems)
              TransactionItem(logItem: logItem),
          ],
        );
      }
    } catch (e) {
      return Container();
    }
  }

  Widget previousContent() {
    try {
      bool empty = previousLogItems.isEmpty;
      if (empty) {
        return Container();
      } else {
        return Column(
          children: [
            ///date item
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Previous Days',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(
              spaceMultiplier: 0.01,
            ),
            for (var logItem in previousLogItems)
              TransactionItem(logItem: logItem),
          ],
        );
      }
    } catch (e) {
      return Container();
    }
  }
}
