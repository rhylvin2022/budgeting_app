// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:math';

import 'package:budgeting_app/global/app_strings.dart';
import 'package:budgeting_app/global/global_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:budgeting_app/storage/storage.helper.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsStateInitial());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetSettingsTheme) {
      yield* _onGetSettingsTheme(event);
    } else if (event is SetSettingsTheme) {
      yield* _onSetSettingsTheme(event);
    } else if (event is InitSettingsTheme) {
      yield* _onInitSettingsTheme(event);
    } else if (event is GetSettingsConversionRate) {
      yield* _onGetSettingsConversionRate(event);
    } else if (event is InitSettingsConversionRate) {
      yield* _onInitSettingsConversionRate(event);
    } else if (event is SetSettingsConversionRate) {
      yield* _onSetSettingsConversionRate(event);
    }
  }

  Stream<SettingsState> _onGetSettingsTheme(GetSettingsTheme event) async* {
    try {
      String theme =
          await StorageHelper().getSecureData(AppStrings.settingsTheme);
      String lightTheme = AppStrings.settingsThemes.first;

      if (theme.isEmpty) {
        await StorageHelper()
            .addSecuredData(AppStrings.settingsTheme, lightTheme);
        theme = lightTheme;
      }
      yield GetSettingsThemeSuccess(theme);
    } catch (e) {
      yield GetSettingsThemeFail(e);
    }
  }

  Stream<SettingsState> _onSetSettingsTheme(SetSettingsTheme event) async* {
    try {
      await StorageHelper()
          .addSecuredData(AppStrings.settingsTheme, event.theme);

      GlobalFunctions.setTheme(event.theme);
      yield SetSettingsThemeSuccess(event.theme);
    } catch (e) {
      yield SetSettingsThemeFail(e);
    }
  }

  Stream<SettingsState> _onInitSettingsTheme(InitSettingsTheme event) async* {
    try {
      String theme =
          await StorageHelper().getSecureData(AppStrings.settingsTheme);
      String lightTheme = AppStrings.settingsThemes.first;

      if (theme.isEmpty) {
        await StorageHelper()
            .addSecuredData(AppStrings.settingsTheme, lightTheme);
        theme = lightTheme;
      }
      GlobalFunctions.setTheme(theme);
      yield InitSettingsThemeSuccess(theme);
    } catch (e) {
      yield InitSettingsThemeFail(e);
    }
  }

  Stream<SettingsState> _onGetSettingsConversionRate(
      GetSettingsConversionRate event) async* {
    try {
      String conversionRate = await StorageHelper()
          .getSecureData(AppStrings.settingsConversionRate);
      double lastCheckConversionRate = 56.24;
      if (conversionRate.isEmpty) {
        conversionRate = (lastCheckConversionRate * 100).toString();
        await StorageHelper()
            .addSecuredData(AppStrings.settingsConversionRate, conversionRate);
      }
      yield GetSettingsConversionRateSuccess(conversionRate);
    } catch (e) {
      yield GetSettingsConversionRateFail(e);
    }
  }

  Stream<SettingsState> _onSetSettingsConversionRate(
      SetSettingsConversionRate event) async* {
    try {
      await StorageHelper().addSecuredData(
          AppStrings.settingsConversionRate, event.conversionRate);

      double conversionRate = (double.parse(event.conversionRate) / 100);

      GlobalFunctions.setConversionRate(conversionRate);
      yield SetSettingsConversionRateSuccess(event.conversionRate);
    } catch (e) {
      yield SetSettingsConversionRateFail(e);
    }
  }

  Stream<SettingsState> _onInitSettingsConversionRate(
      InitSettingsConversionRate event) async* {
    try {
      String conversionRateString = await StorageHelper()
          .getSecureData(AppStrings.settingsConversionRate);
      double lastCheckConversionRate = 56.24;
      double conversionRate = 0;
      if (conversionRateString.isEmpty) {
        conversionRateString = (lastCheckConversionRate * 100).toString();
        await StorageHelper().addSecuredData(
            AppStrings.settingsConversionRate, conversionRateString);
        conversionRate = lastCheckConversionRate;
      } else {
        conversionRate = (double.parse(conversionRateString) / 100);
      }
      GlobalFunctions.setConversionRate(conversionRate);
      yield InitSettingsConversionRateSuccess(conversionRateString);
    } catch (e) {
      yield InitSettingsConversionRateFail(e);
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
