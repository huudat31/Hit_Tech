import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/models/repositories/auth_repository.dart';
import 'package:hit_tech/features/auth/cubit/login-register/blocs/register_cubit.dart';
import 'package:hit_tech/features/auth/view/forgot_password_screen.dart';

import 'package:hit_tech/features/auth/view/splash_page.dart';
import 'package:hit_tech/features/auth/view/login_page.dart';
import 'package:hit_tech/features/auth/view/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/features/home/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(authRepository: AuthRepository()),
            ),
            // Nếu có thêm RegisterCubit, thêm luôn ở đây
            // BlocProvider<RegisterCubit>(
            //   create: (context) => RegisterCubit(),
            // ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Auth App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: const Color(0xFF2454F8),
              fontFamily: 'Roboto',
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => HomeScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
            },
          ),
        );
      },
    );
  }
}
