part of 'budget_bloc.dart';

@immutable
abstract class BudgetState extends Equatable {}

class BudgetStateInitial extends BudgetState {
  @override
  List<Object?> get props => [];
}

class CreateBudgetLogSuccess extends BudgetState {
  final DateTime triggeredAt;

  CreateBudgetLogSuccess() : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [triggeredAt];
}

class CreateBudgetLogFail extends BudgetState {
  CreateBudgetLogFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class LoadBudgetLogSuccessNoData extends BudgetState {
  final DateTime triggeredAt;

  LoadBudgetLogSuccessNoData() : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [triggeredAt];
}

class LoadBudgetLogSuccess extends BudgetState {
  final List<LogItem> logItems;

  LoadBudgetLogSuccess(this.logItems);

  @override
  List<Object?> get props => [logItems];
}

class LoadBudgetLogFail extends BudgetState {
  LoadBudgetLogFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}
