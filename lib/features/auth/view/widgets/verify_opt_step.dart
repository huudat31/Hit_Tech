import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_bloc.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_event.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_state.dart';
import 'package:hit_tech/features/auth/view/widgets/auth_custom_button.dart';
import 'package:hit_tech/features/auth/view/widgets/custom_input_field.dart';

class VerifyOptStep extends StatelessWidget {
  const VerifyOptStep({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final otpController = TextEditingController();

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nhập mã OTP được gửi về email của bạn',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                isPassword: true,
                controller: otpController,
                title: 'Mã OTP',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã OTP';
                  }
                  if (value.length != 6) {
                    return 'Mã OTP phải có 6 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: state.status == ForgotPasswordStatus.loading
                      ? null
                      : () {
                          context.read<ForgotPasswordBloc>().add(
                            EmailSubmitted(email: state.email),
                          );
                        },
                  child: const Text(
                    'Chưa nhận được mã OTP? Gửi lại mã',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AuthCustomButton(
                text: "Xác Nhận",
                onPressed: state.status == ForgotPasswordStatus.loading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          context.read<ForgotPasswordBloc>().add(
                            VerifyOptSubmitted(
                              email: state.email,
                              otpCode: otpController.text,
                            ),
                          );
                        }
                      },
                isLoading: state.status == ForgotPasswordStatus.loading,
              ),
            ],
          ),
        );
      },
    );
  }
}
