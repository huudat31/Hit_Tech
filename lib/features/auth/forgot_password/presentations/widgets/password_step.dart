import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/utils/validators.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_bloc.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_event.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_state.dart';
import 'package:hit_tech/features/auth/presentation/widgets/auth_custom_button.dart';
import 'package:hit_tech/features/auth/presentation/widgets/custom_input_field.dart';

class PasswordStep extends StatelessWidget {
  const PasswordStep({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state.status == ForgotPasswordStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đặt lại mật khẩu thành công')),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đặt lại mật khẩu mới của bạn',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: newPasswordController,
                title: 'Mật khẩu mới',
                isPassword: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: confirmPasswordController,
                title: 'Nhập lại mật khẩu mới',
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu';
                  }
                  if (value != newPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              AuthCustomButton(
                text: "Xác Nhận",
                onPressed: state.status == ForgotPasswordStatus.loading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          context.read<ForgotPasswordBloc>().add(
                            PasswordResetSubmitted(
                              email: state.email,
                              newPassword: newPasswordController.text,
                              confirmPassword: confirmPasswordController.text,
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
