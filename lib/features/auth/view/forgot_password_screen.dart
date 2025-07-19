import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/models/repositories/forgot_password_repo.dart';
import 'package:hit_tech/features/auth/cubit/forgot_password/blocs/forgot_password_bloc.dart';
import 'package:hit_tech/features/auth/view/widgets/forgot_password_view.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ForgotPasswordBloc(repository: ForgotPasswordRepository()),
      child: ForgotPasswordView(),
    );
  }
}
