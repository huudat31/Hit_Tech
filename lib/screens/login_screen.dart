import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/core/utils/validators.dart';
import 'package:hit_tech/presentation/blocs/register_cubit.dart';
import 'package:hit_tech/presentation/widgets/auth_custom_button.dart';
import 'package:hit_tech/presentation/widgets/button_gg_fb_auth.dart';
import 'package:hit_tech/presentation/widgets/custom_input_field.dart';
import 'package:hit_tech/presentation/widgets/text_bottom_auth.dart';
import 'package:hit_tech/services/shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    // Load saved username if remember me was checked
    // You can implement this based on your SharedPreferences setup
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Trigger login event
      context.read<AuthBloc>().add(
        LoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Save token and user data
            if (state.token != null) {
              SharedPreferencesService.saveToken(state.token!);
            }
            if (state.user != null) {
              SharedPreferencesService.saveUserData(state.user!);
            }

            _showSnackBar(state.message ?? AppStrings.loginSuccess);

            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            _showSnackBar(state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Container(
                  width: screenWidth,
                  height: 135,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2454F8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.login,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Form Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Username Field
                      CustomInputField(
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        width: screenWidth * 0.9,
                        height: 64,
                        controller: _usernameController,
                        title: AppStrings.username,
                        borderRadius: 12,
                        borderColor: Colors.grey[400],
                        focusedBorderColor: Color(0xFF2454F8),
                        validator: Validators.validateUsername,
                        onChanged: (value) {
                          // Real-time validation if needed
                        },
                      ),

                      const SizedBox(height: 24),

                      // Password Field
                      CustomInputField(
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        width: screenWidth * 0.9,
                        height: 64,
                        controller: _passwordController,
                        title: AppStrings.password,
                        borderRadius: 12,
                        borderColor: Colors.grey[400],
                        focusedBorderColor: Color(0xFF2454F8),
                        obscureText: !_isPasswordVisible,
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        onChanged: (value) {
                          // Real-time validation if needed
                        },
                      ),

                      const SizedBox(height: 16),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  child: _rememberMe
                                      ? Icon(
                                          Icons.check_box,
                                          color: Color(0xFF2454F8),
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.grey[600],
                                        ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Ghi nhớ đăng nhập',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to forgot password screen
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                            child: Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(
                                color: Color(0xFF2454F8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Login Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return AuthCustomButton(
                            text: isLoading
                                ? 'Đang đăng nhập...'
                                : AppStrings.login,
                            onPressed: isLoading ? null : _handleLogin,
                            isLoading: isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      DividerWithText(text: AppStrings.orLoginWith),

                      const SizedBox(height: 24),

                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonGgFbAuth(
                            image: Image(
                              image: AssetImage(
                                'assets/images/google_icon.png',
                              ),
                            ),
                            width: screenWidth * 0.4,
                            text: 'Google',
                            onPressed: () {
                              // Handle Google login
                              _handleSocialLogin('google');
                            },
                          ),
                          ButtonGgFbAuth(
                            image: Image(
                              image: AssetImage(
                                'assets/images/facebook_icon.png',
                              ),
                            ),
                            width: screenWidth * 0.4,
                            text: 'Facebook',
                            onPressed: () {
                              // Handle Facebook login
                              _handleSocialLogin('facebook');
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              AppStrings.register,
                              style: TextStyle(
                                color: Color(0xFF2454F8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // Implement social login logic here
    _showSnackBar('Chức năng đăng nhập bằng $provider đang được phát triển');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
