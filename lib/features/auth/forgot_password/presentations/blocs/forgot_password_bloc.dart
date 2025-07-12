import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/forgot_password/data/repository/forgot_password_repository.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_event.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;
  ForgotPasswordBloc({required this.repository})
    : super(const ForgotPasswordState()) {
    on<EmailSubmitted>(_onEmailSubmitted);
    on<VerifyOptSubmitted>(_onVerifyOptSubmitted);
    on<PasswordResetSubmitted>(_onPasswordResetSubmitted);
    on<StepChanged>(_onStepChanged);
  }

  Future<void> _onEmailSubmitted(
    EmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      final response = await repository.sendOptToEmail(event.email);
      if (response.success) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.success,
            email: event.email,
            currentStep: 1,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVerifyOptSubmitted(
    VerifyOptSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      final response = await repository.verifyOtpToResetPassword(
        event.email,
        event.otpCode,
      );
      if (response.success) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.success,
            verifyOpt: event.otpCode,
            currentStep: 2,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPasswordResetSubmitted(
    PasswordResetSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      final response = await repository.resetPassword(
        event.email,
        event.newPassword,
        event.confirmPassword,
      );
      if (response.success) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.success,
            currentStep: 3,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStepChanged(
    StepChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(currentStep: event.step));
  }
}
