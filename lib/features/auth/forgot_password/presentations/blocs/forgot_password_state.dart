import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, failure, email }

class ForgotPasswordState extends Equatable {
  final int currentStep;
  final ForgotPasswordStatus status;
  final String email;
  final String verifyOpt;
  final String newPassword;
  final String confirmPassword;
  final String? errorMessage;

  const ForgotPasswordState({
    this.currentStep = 0,
    this.status = ForgotPasswordStatus.initial,
    this.email = '',
    this.verifyOpt = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    int? currentStep,
    ForgotPasswordStatus? status,
    String? email,
    String? verifyOpt,
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      email: email ?? this.email,
      verifyOpt: verifyOpt ?? this.verifyOpt,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    status,
    email,
    verifyOpt,
    newPassword,
    confirmPassword,
    errorMessage,
  ];
}
