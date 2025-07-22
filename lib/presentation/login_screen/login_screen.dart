import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/create_account_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/forgot_password_widget.dart';
import './widgets/logo_widget.dart';
import './widgets/password_input_widget.dart';
import './widgets/sign_in_button_widget.dart';
import 'widgets/biometric_prompt_widget.dart';
import 'widgets/create_account_widget.dart';
import 'widgets/email_input_widget.dart';
import 'widgets/forgot_password_widget.dart';
import 'widgets/logo_widget.dart';
import 'widgets/password_input_widget.dart';
import 'widgets/sign_in_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isSignUp = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    _authService.authStateChanges.listen((data) {
      if (data.event == 'signedIn' && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboardHome);
      }
    });

    // Check if already authenticated
    if (_authService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboardHome);
      });
    }
  }

  Future<void> _handleSignIn() async {
    if (!_validateInputs()) return;

    setState(() => isLoading = true);

    try {
      await _authService.signIn(
          email: emailController.text.trim(),
          password: passwordController.text);

      if (mounted) {
        Fluttertoast.showToast(
            msg: "Welcome to LuxeVista Resort!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboardHome);
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
            msg: "Sign in failed. Please check your credentials.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleSignUp() async {
    if (!_validateSignUpInputs()) return;

    setState(() => isLoading = true);

    try {
      final response = await _authService.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          fullName: fullNameController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim());

      if (mounted) {
        if (response.user != null) {
          Fluttertoast.showToast(
              msg: "Account created successfully! Welcome to LuxeVista Resort!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboardHome);
        } else {
          Fluttertoast.showToast(
              msg: "Please check your email to verify your account.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
            msg: "Sign up failed. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email");
      return false;
    }
    if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return false;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your password");
      return false;
    }
    return true;
  }

  bool _validateSignUpInputs() {
    if (!_validateInputs()) return false;
    if (fullNameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your full name");
      return false;
    }
    if (passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
      return false;
    }
    return true;
  }

  void _toggleMode() {
    setState(() {
      isSignUp = !isSignUp;
      emailController.clear();
      passwordController.clear();
      fullNameController.clear();
      phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.h),
                      const LogoWidget(),
                      SizedBox(height: 4.h),
                      Text(isSignUp ? 'Create Your Account' : 'Welcome Back',
                          style: GoogleFonts.inter(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A)),
                          textAlign: TextAlign.center),
                      SizedBox(height: 1.h),
                      Text(
                          isSignUp
                              ? 'Join LuxeVista Resort for exclusive luxury experiences'
                              : 'Sign in to continue your luxury journey',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFF666666),
                              height: 1.4),
                          textAlign: TextAlign.center),
                      SizedBox(height: 4.h),
                      if (isSignUp) ...[
                        // Full Name Input for Sign Up
                        Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: TextFormField(
                                controller: fullNameController,
                                decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    prefixIcon: Icon(Icons.person_outline,
                                        color: Color(0xFF8B7355)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE5E5E5))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B7355),
                                            width: 2)),
                                    filled: true,
                                    fillColor: const Color(0xFFFAFAFA)),
                                style: GoogleFonts.inter())),

                        // Phone Input for Sign Up
                        Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: 'Phone Number (Optional)',
                                    prefixIcon: Icon(Icons.phone_outlined,
                                        color: Color(0xFF8B7355)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE5E5E5))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFF8B7355),
                                            width: 2)),
                                    filled: true,
                                    fillColor: const Color(0xFFFAFAFA)),
                                style: GoogleFonts.inter())),
                      ],
                      EmailInputWidget(controller: emailController, onChanged: (value) {}),
                      SizedBox(height: 2.h),
                      PasswordInputWidget(controller: passwordController, onChanged: (value) {}),
                      SizedBox(height: 3.h),
                      SignInButtonWidget(
                          isLoading: isLoading,
                          isEnabled: true,
                          onPressed: isSignUp ? _handleSignUp : _handleSignIn),
                      if (!isSignUp) ...[
                        SizedBox(height: 2.h),
                        SizedBox(height: 2.h),
                        BiometricPromptWidget(
                          onEnableBiometric: () {}, 
                          onSkip: () {}),
                      ],
                      SizedBox(height: 3.h),
                    ]))));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}