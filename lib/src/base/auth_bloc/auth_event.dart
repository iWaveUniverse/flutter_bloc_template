part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoadAuthEvent extends AuthEvent {
  final bool redirect;
  final Duration delay;

  const LoadAuthEvent({this.redirect = true, this.delay = Duration.zero});
}

class UpdateUserAuthEvent extends AuthEvent {
  final dynamic user;

  const UpdateUserAuthEvent({this.user});
}

class LogoutAuthEvent extends AuthEvent {}
