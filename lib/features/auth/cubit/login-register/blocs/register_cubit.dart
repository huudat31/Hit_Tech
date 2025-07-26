import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/models/login_request.dart';
import 'package:hit_tech/features/auth/models/register_request.dart';
import 'package:hit_tech/features/auth/models/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;

  const RegisterRequested({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object> get props => [username, password, firstName, lastName, email];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? token;
  final Map<String, dynamic>? user;
  final String? message;

  const AuthSuccess({this.token, this.user, this.message});

  @override
  List<Object?> get props => [token, user, message];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final loginRequest = LoginRequest(
        username: event.username,
        password: event.password,
      );

      final response = await authRepository.login(loginRequest);

      if (response.success) {
        emit(
          AuthSuccess(
            token: response.token,
            user: response.user,
            message: response.message,
          ),
        );
      } else {
        emit(AuthFailure(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: 'An error occurred during login'));
    }
  }

  void _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final registerRequest = RegisterRequest(
        username: event.username,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
      );

      final response = await authRepository.register(registerRequest);

      if (response.success) {
        emit(
          AuthSuccess(message: response.message ?? 'Registration successful'),
        );
      } else {
        emit(AuthFailure(message: response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthFailure(message: 'An error occurred during registration'));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      print('[AuthBloc] Logout error: $e');
      emit(AuthInitial()); // Vẫn logout dù có lỗi
    }
  }

  void _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isAuthenticated = await authRepository.isAuthenticated();

      if (isAuthenticated) {
        final userData = await authRepository.getCurrentUser();
        emit(
          AuthSuccess(
            token:
                'existing_token', // Token đã được lưu trong SharedPreferences
            user: userData,
            message: 'Already authenticated',
          ),
        );
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      print('[AuthBloc] Check auth status error: $e');
      emit(AuthInitial());
    }
  }
}
