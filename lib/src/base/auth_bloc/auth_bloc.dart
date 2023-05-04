import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthStateType { none, logged, logged_out }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<AuthLoaded>(_mapAuthLoadedToState);
    on<LogoutEvent>(_mapLogoutToState);
  }

  _mapAuthLoadedToState(AuthLoaded event, Emitter<AuthState> emit) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      emit(AuthState(stateType: AuthStateType.logged, user: {}));
    } catch (e) {
      emit(AuthState(stateType: AuthStateType.logged_out));
    }
  }

  _mapLogoutToState(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthState(stateType: AuthStateType.logged_out));
    } catch (e) {}
  }
}
