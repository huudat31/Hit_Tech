class ResetPasswordRequest {
  final String email;
  final String newPassword;
  final String reenterPassword;

  ResetPasswordRequest({
    required this.email,
    required this.newPassword,
    required this.reenterPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
      'reenterPassword': reenterPassword,
    };
  }

  @override
  String toString() {
    return 'ResetPasswordRequest(email: $email, newPassword: $newPassword, reenterPassword: $reenterPassword)';
  }
}
