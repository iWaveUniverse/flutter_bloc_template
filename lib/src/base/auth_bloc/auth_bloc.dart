import 'dart:async';
 
import 'package:bloc/bloc.dart'; 
import 'package:equatable/equatable.dart'; 
part 'auth_event.dart';
part 'auth_state.dart';

enum AuthStateType { none, logged }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  StreamSubscription? _subscription;

  AuthBloc() : super(AuthState()) {
    on<AuthLoad>(_load);
    on<LogoutEvent>(_logout);
    on<AuthUpdateUser>(_update);
  }

  _update(AuthUpdateUser event, Emitter<AuthState> emit) async {
    state.user = event.user;
    if (state.user == null) {
      add(LogoutEvent());
    }
  }

  _load(AuthLoad event, Emitter<AuthState> emit) async {
    try {
      emit(state.update(stateType: AuthStateType.logged));
    } catch (e) {
      emit(state.update(stateType: AuthStateType.none));
    }
    if (state.stateType == AuthStateType.logged) {
      // state.user = user;
      // _subscription?.cancel();
      // _subscription =
      //     FirebaseAuth.instance.authStateChanges().listen((User? user) {
      //   add(AuthUpdateUser(user: user));
      // });
    }

    await Future.delayed(event.delay);
    _redirect();
  }

  _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    _subscription?.cancel();
    try {
      emit(state.update(stateType: AuthStateType.none));
      _redirect();
    } catch (e) {}
  }

  _redirect() {
    if (state.stateType == AuthStateType.logged) {
      // Get.offAllNamed(Routes.nav);
    } else {}
  }
}
