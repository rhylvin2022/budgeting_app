// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:math';

import 'package:budgeting_app/global/app_strings.dart';
import 'package:budgeting_app/repositories/sample_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budgeting_app/storage/storage.helper.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swagger/api.dart';

part 'budget_event.dart';

part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetStateInitial());

  @override
  Stream<BudgetState> mapEventToState(BudgetEvent event) async* {
    if (event is CreateBudgetLog) {
      yield* _onCreateBudgetLog(event);
    } else if (event is LoadBudgetLog) {
      yield* _onLoadBudgetLog(event);
    }
  }

  Stream<BudgetState> _onCreateBudgetLog(CreateBudgetLog event) async* {
    try {
      String jsonList =
          await StorageHelper().getSecureData(AppStrings.budgetItemLogs);

      List<LogItem> itemLogs;

      if (jsonList.isEmpty) {
        itemLogs = [event.logItem];
      } else {
        List<dynamic> decodedJson = json.decode(jsonList);
        itemLogs = LogItem.listFromJson(decodedJson);
        itemLogs.add(event.logItem);
      }
      String updatedJson =
          json.encode(itemLogs.map((e) => e.toJson()).toList());

      await StorageHelper()
          .addSecuredData(AppStrings.budgetItemLogs, updatedJson);

      yield CreateBudgetLogSuccess();
    } catch (e) {
      yield CreateBudgetLogFail(e);
    }
  }

  Stream<BudgetState> _onLoadBudgetLog(LoadBudgetLog event) async* {
    try {
      String jsonList =
          await StorageHelper().getSecureData(AppStrings.budgetItemLogs);

      List<LogItem> itemLogs;

      if (jsonList.isEmpty) {
        yield LoadBudgetLogSuccessNoData();
      } else {
        List<dynamic> decodedJson = json.decode(jsonList);
        itemLogs = LogItem.listFromJson(decodedJson);
        yield LoadBudgetLogSuccess(itemLogs);
      }
    } catch (e) {
      yield LoadBudgetLogFail(e);
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
