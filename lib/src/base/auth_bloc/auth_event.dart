part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoaded extends AuthEvent {
  final bool forceUpdate;

  const AuthLoaded([this.forceUpdate = false]);

  @override
  List<Object> get props => [forceUpdate];
}

class LogoutEvent extends AuthEvent {}
