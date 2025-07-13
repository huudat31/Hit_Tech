abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();

  List<Object> get props => [];
}

class EmailSubmitted extends ForgotPasswordEvent {
  final String email;
  const EmailSubmitted({required this.email});
}

class VerifyOptSubmitted extends ForgotPasswordEvent {
  final String email;
  final String otpCode;
  const VerifyOptSubmitted({required this.email, required this.otpCode});
}

class PasswordResetSubmitted extends ForgotPasswordEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const PasswordResetSubmitted({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class StepChanged extends ForgotPasswordEvent {
  final int step;

  const StepChanged(this.step);
}
