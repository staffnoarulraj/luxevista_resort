import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onModify;
  final VoidCallback? onFavorite;

  const BookingCardWidget({
    Key? key,
    required this.booking,
    this.onTap,
    this.onCancel,
    this.onModify,
    this.onFavorite,
  }) : super(key: key);

  Color _getStatusColor() {
    final status = booking['status'] as String;
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
        return AppTheme.warningLight;
      case 'cancelled':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getServiceIcon() {
    final serviceType = booking['serviceType'] as String;
    switch (serviceType.toLowerCase()) {
      case 'room':
        return 'bed';
      case 'spa':
        return 'spa';
      case 'dining':
        return 'restaurant';
      case 'cabana':
        return 'beach_access';
      case 'tour':
        return 'tour';
      default:
        return 'event';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(booking['id'].toString()),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.errorLight.withValues(alpha: 0.1),
          borderRadius: AppTheme.mediumRadius,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'cancel',
              color: AppTheme.errorLight,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.errorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: AppTheme.mediumRadius,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Favorite',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onCancel != null) {
          onCancel!();
        } else if (direction == DismissDirection.endToStart &&
            onFavorite != null) {
          onFavorite!();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: AppTheme.mediumRadius,
          boxShadow: AppTheme.lightShadow,
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.mediumRadius,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: AppTheme.smallRadius,
                        ),
                        child: CustomIconWidget(
                          iconName: _getServiceIcon(),
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['serviceName'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              booking['serviceType'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking['status'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        booking['date'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        booking['time'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${booking['guestCount']} Guests',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'confirmation_number',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          booking['reference'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontFamily: 'monospace',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (booking['status'] == 'Confirmed') ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onModify,
                            icon: CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 4.w,
                            ),
                            label: Text('Modify'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // View details action
                            },
                            icon: CustomIconWidget(
                              iconName: 'visibility',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 4.w,
                            ),
                            label: Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
