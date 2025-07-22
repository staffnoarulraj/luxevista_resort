import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final VoidCallback onEnableBiometric;
  final VoidCallback onSkip;

  const BiometricPromptWidget({
    super.key,
    required this.onEnableBiometric,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.heavyShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            constraints: BoxConstraints(
              maxWidth: 60,
              maxHeight: 60,
              minWidth: 48,
              minHeight: 48,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 28,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Enable Biometric Login',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Use your fingerprint or face recognition for quick and secure access to your account.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSkip,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onEnableBiometric,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Enable',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
