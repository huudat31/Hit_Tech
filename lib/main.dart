import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/data/repositories/auth_repository.dart';
import 'package:hit_tech/presentation/blocs/register_cubit.dart';
import 'package:hit_tech/features/auth/forgot_password/presentations/screens/forgot_password_screen.dart';
import 'package:hit_tech/presentation/screens/home_screen.dart';
import 'package:hit_tech/screens/login_screen.dart';
import 'package:hit_tech/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: ForgotPasswordScreen(),
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
