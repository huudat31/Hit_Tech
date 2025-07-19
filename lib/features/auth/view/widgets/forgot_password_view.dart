import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_bloc.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_event.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_state.dart';
import 'package:hit_tech/features/auth/view/widgets/email_step.dart';
import 'package:hit_tech/features/auth/view/widgets/password_step.dart';
import 'package:hit_tech/features/auth/view/widgets/verify_opt_step.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 51),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (state.currentStep > 0) {
                            context.read<ForgotPasswordBloc>().add(
                              StepChanged(state.currentStep - 1),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      bool isActive = index == state.currentStep;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 32,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  //content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [EmailStep(), VerifyOptStep(), PasswordStep()],
                    ),
                  ),
                ],
              );
            },
            listener: (context, state) {
              if (state.currentStep == 1) {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (state.currentStep == 2) {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(microseconds: 2),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
