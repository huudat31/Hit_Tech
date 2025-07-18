import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/utils/validators.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_bloc.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_event.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/blocs/forgot_password_state.dart';
import 'package:hit_tech/features/auth/presentation/widgets/auth_custom_button.dart';
import 'package:hit_tech/features/auth/presentation/widgets/custom_input_field.dart';

class EmailStep extends StatelessWidget {
  const EmailStep({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (BuildContext context, ForgotPasswordState state) {
        return Form(
          key: formKey, // Add this line to connect the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Nhập email của bạn để đặt lại mật khẩu',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                isPassword: true,
                controller: _emailController,
                title: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 40),
              AuthCustomButton(
                text: 'Xác nhận',
                onPressed: state.status == ForgotPasswordStatus.loading
                    ? null
                    : () {
                        if (formKey.currentState?.validate() ?? false) {
                          context.read<ForgotPasswordBloc>().add(
                            EmailSubmitted(email: _emailController.text),
                          );
                        }
                      },
                isLoading: state.status == ForgotPasswordStatus.loading,
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, ForgotPasswordState state) {
        if (state.status == ForgotPasswordStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
    );
  }
}
