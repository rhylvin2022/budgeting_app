part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class GetSettingsTheme extends SettingsEvent {}

class SetSettingsTheme extends SettingsEvent {
  final String theme;
  SetSettingsTheme(this.theme);
}

class InitSettingsTheme extends SettingsEvent {}

class GetSettingsConversionRate extends SettingsEvent {}

class SetSettingsConversionRate extends SettingsEvent {
  final String conversionRate;
  SetSettingsConversionRate(this.conversionRate);
}

class InitSettingsConversionRate extends SettingsEvent {}
