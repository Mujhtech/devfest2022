import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devfest/core/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:devfest/models/models.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthState.unauthenticated()) {
    on<AuthSignIn>(_onSignIn);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    try {
      await _authenticationRepository.logInWithGithub(event.context);
    } catch (e) {
      //
    }
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (state.user == null && event.user != null) {}
    emit(
      event.user != null && event.user!.isNotEmpty
          ? AuthState.authenticated(event.user!)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
