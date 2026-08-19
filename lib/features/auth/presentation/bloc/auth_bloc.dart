import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const String boxName = 'auth';
  static const String loggedInKey = 'isLoggedIn';

  late final Box _box;

  AuthBloc()
      : super(
    const AuthState(
      status: AuthStatus.initial,
    ),
  ) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<CheckLoginStatus>(_onCheckLoginStatus);

    _initialize();
  }

  Future<void> _initialize() async {
    _box = await Hive.openBox(boxName);

    add(CheckLoginStatus());
  }

  Future<void> _onCheckLoginStatus(
      CheckLoginStatus event,
      Emitter<AuthState> emit,
      ) async {
    final isLoggedIn =
    _box.get(
      loggedInKey,
      defaultValue: false,
    ) as bool;

    emit(
      state.copyWith(
        status: isLoggedIn
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }

  Future<void> _onLogin(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
      ),
    );

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (event.email.isEmpty ||
        event.password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage:
          'Email and password are required.',
        ),
      );
      return;
    }

    if (event.email == 'test@gmail.com' &&
        event.password == '123456') {
      await _box.put(
        loggedInKey,
        true,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage:
          'Invalid email or password.',
        ),
      );
    }
  }

  Future<void> _onLogout(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _box.put(
      loggedInKey,
      false,
    );

    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
      ),
    );
  }
}