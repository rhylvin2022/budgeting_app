part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LanguageLoadStarted extends LocalizationEvent {}

class LanguageSelected extends LocalizationEvent {
  final Language languageCode;

  const LanguageSelected(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
