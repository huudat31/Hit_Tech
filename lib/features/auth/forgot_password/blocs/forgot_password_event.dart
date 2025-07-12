part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();

  List<Object> get props => [];
}

class EmailSubmitted extends ForgotPasswordEvent {
  final String email;
  const EmailSubmitted(text, {required this.email});
}

class VerifyOptSubmitted extends ForgotPasswordEvent {
  final String email;
  final String otpCode;
  const VerifyOptSubmitted(this.email, {required this.otpCode});
}

class PasswordResetSubmitted extends ForgotPasswordEvent {
  final String email;
  final String newPassword;
  final String reenterPassword;

  const PasswordResetSubmitted({
    required this.email,
    required this.newPassword,
    required this.reenterPassword,
  });
}

class StepChanged extends ForgotPasswordEvent {
  final int step;

  const StepChanged(this.step);
}
