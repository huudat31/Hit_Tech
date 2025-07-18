import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/data/repositories/auth_repository.dart';
import 'package:hit_tech/features/auth/register/blocs/register_cubit.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/screens/forgot_password_screen.dart';
import 'package:hit_tech/features/auth/presentation/screens/home_screen.dart';
import 'package:hit_tech/features/auth/presentation/screens/splash_screen.dart';
import 'package:hit_tech/screens/login_screen.dart';
import 'package:hit_tech/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF2454F8),
          fontFamily: 'Roboto',
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}
