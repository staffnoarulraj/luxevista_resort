import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String cardType;
  final String lastFourDigits;
  final String expiryDate;
  final bool isDefault;
  final VoidCallback onRemove;
  final VoidCallback onSetDefault;

  const PaymentMethodWidget({
    Key? key,
    required this.cardType,
    required this.lastFourDigits,
    required this.expiryDate,
    required this.isDefault,
    required this.onRemove,
    required this.onSetDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: isDefault
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.outline,
          width: isDefault ? 2 : 1,
        ),
        borderRadius: AppTheme.mediumRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getCardColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'credit_card',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cardType,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        if (isDefault) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Default',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '•••• •••• •••• $lastFourDigits',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Expires $expiryDate',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'default') {
                    onSetDefault();
                  } else if (value == 'remove') {
                    onRemove();
                  }
                },
                itemBuilder: (context) => [
                  if (!isDefault)
                    PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('Set as Default'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                child: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ],
          ),
          if (isDefault) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Securely stored with 256-bit encryption',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getCardColor() {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Color(0xFF1A1F71);
      case 'mastercard':
        return Color(0xFFEB001B);
      case 'american express':
        return Color(0xFF006FCF);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
