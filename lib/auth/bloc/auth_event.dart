part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user];
}

class AuthSignIn extends AuthEvent {
  const AuthSignIn(this.context);

  final BuildContext context;

  @override
  List<Object> get props => [context];
}
