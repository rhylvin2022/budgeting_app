part of 'budget_bloc.dart';

@immutable
abstract class BudgetEvent {}

class CreateBudgetLog extends BudgetEvent {
  final LogItem logItem;
  CreateBudgetLog(this.logItem);
}
