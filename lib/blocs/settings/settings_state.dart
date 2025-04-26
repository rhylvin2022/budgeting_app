part of 'settings_bloc.dart';

@immutable
abstract class SettingsState extends Equatable {}

class SettingsStateInitial extends SettingsState {
  @override
  List<Object?> get props => [];
}

class GetSettingsThemeSuccess extends SettingsState {
  final String theme;
  final DateTime triggeredAt;
  GetSettingsThemeSuccess(this.theme) : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [theme, triggeredAt];
}

class GetSettingsThemeFail extends SettingsState {
  GetSettingsThemeFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class SetSettingsThemeSuccess extends SettingsState {
  final String theme;
  final DateTime triggeredAt;
  SetSettingsThemeSuccess(this.theme) : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [theme, triggeredAt];
}

class SetSettingsThemeFail extends SettingsState {
  SetSettingsThemeFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class InitSettingsThemeSuccess extends SettingsState {
  final String theme;
  final DateTime triggeredAt;
  InitSettingsThemeSuccess(this.theme) : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [theme, triggeredAt];
}

class InitSettingsThemeFail extends SettingsState {
  InitSettingsThemeFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class GetSettingsConversionRateSuccess extends SettingsState {
  final String conversionRate;
  final DateTime triggeredAt;
  GetSettingsConversionRateSuccess(this.conversionRate)
      : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [conversionRate, triggeredAt];
}

class GetSettingsConversionRateFail extends SettingsState {
  GetSettingsConversionRateFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class SetSettingsConversionRateSuccess extends SettingsState {
  final String conversionRate;
  final DateTime triggeredAt;
  SetSettingsConversionRateSuccess(this.conversionRate)
      : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [conversionRate, triggeredAt];
}

class SetSettingsConversionRateFail extends SettingsState {
  SetSettingsConversionRateFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}

class InitSettingsConversionRateSuccess extends SettingsState {
  final String conversionRate;
  final DateTime triggeredAt;
  InitSettingsConversionRateSuccess(this.conversionRate)
      : triggeredAt = DateTime.now();

  @override
  List<Object?> get props => [conversionRate, triggeredAt];
}

class InitSettingsConversionRateFail extends SettingsState {
  InitSettingsConversionRateFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}
