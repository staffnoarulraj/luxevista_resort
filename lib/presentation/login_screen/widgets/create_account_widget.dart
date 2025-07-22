import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CreateAccountWidget extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;

  const CreateAccountWidget({
    Key? key,
    required this.isSignUp,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSignUp ? 'Already have an account? ' : "Don't have an account? ",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFF666666),
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            isSignUp ? 'Sign In' : 'Create Account',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFF8B7355),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}