import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/auth_service.dart';

class ForgotPasswordWidget extends StatelessWidget {
  final AuthService authService;

  const ForgotPasswordWidget({
    Key? key,
    required this.authService,
  }) : super(key: key);

  Future<void> _handleForgotPassword(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Password',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: const Color(0xFF666666),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B7355), width: 2),
                ),
              ),
              style: GoogleFonts.inter(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isEmpty) {
                Fluttertoast.showToast(msg: "Please enter your email");
                return;
              }

              try {
                await authService.resetPassword(
                    email: emailController.text.trim());
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: "Password reset link sent to your email",
                  toastLength: Toast.LENGTH_LONG,
                );
              } catch (e) {
                Fluttertoast.showToast(
                  msg: "Failed to send reset link. Please try again.",
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B7355),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Send Reset Link',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleForgotPassword(context),
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: const Color(0xFF8B7355),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}