import 'package:base_code/global/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState.unauthenticated()) {
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<ChangeAuthentication>(
      (event, emit) async =>
          emit(await _mapAuthenticationStatusChangedToState(event)),
    );
  }

  bool isAuthenticated() => state.status == AuthenticationStatus.authenticated;

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    ChangeAuthentication event,
  ) async {
    return const AuthenticationState.authenticated();
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.unauthenticated());
  }
}
