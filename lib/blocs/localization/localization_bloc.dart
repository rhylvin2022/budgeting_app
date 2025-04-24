import 'dart:ui';

import 'package:base_code/global/enums.dart';
import 'package:base_code/storage/preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState(Locale('en', 'US')));

  @override
  Stream<LocalizationState> mapEventToState(LocalizationEvent event) async* {
    if (event is LanguageLoadStarted) {
      yield* _mapLocalizationLoadStartedToState();
    } else if (event is LanguageSelected) {
      yield* _mapLocalizationSelectedToState(event.languageCode);
    }
  }

  Stream<LocalizationState> _mapLocalizationLoadStartedToState() async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    final defaultLocalizationCode = sharedPrefService!.languageCode;
    Locale locale;

    if (defaultLocalizationCode == null) {
      locale = const Locale('en', 'US');
      await sharedPrefService.setLanguage(locale.languageCode);
    } else {
      locale = Locale(defaultLocalizationCode);
    }

    yield LocalizationState(locale);
  }

  Stream<LocalizationState> _mapLocalizationSelectedToState(
      Language selectedLanguage) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    final defaultLocalizationCode = sharedPrefService!.languageCode;

    if (selectedLanguage == Language.EN &&
        defaultLocalizationCode != LanguageKeys.en.toString()) {
      yield* _loadLocalization(sharedPrefService, 'en', 'EN');
    } else if (selectedLanguage == Language.LK &&
        defaultLocalizationCode != LanguageKeys.si.toString()) {
      yield* _loadLocalization(sharedPrefService, 'si', 'LK');
    } else if (selectedLanguage == Language.IN &&
        defaultLocalizationCode != LanguageKeys.ta.toString()) {
      yield* _loadLocalization(sharedPrefService, 'ta', 'IN');
    }
  }

  /// This method is added to reduce code repetition.
  Stream<LocalizationState> _loadLocalization(
      SharedPreferencesService sharedPreferencesService,
      String localizationCode,
      String countryCode) async* {
    final locale = Locale(localizationCode, countryCode);
    await sharedPreferencesService.setLanguage(locale.languageCode);
    yield LocalizationState(locale);
  }
}
