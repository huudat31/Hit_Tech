class VerifyOtpRequest {
  final String email;
  final String opt;
  VerifyOtpRequest({required this.email, required this.opt});
  Map<String, dynamic> toJson() {
    return {'email': email, 'opt': opt};
  }
}
