import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyBookingsWidget extends StatelessWidget {
  final String tabType;
  final VoidCallback? onBookNow;

  const EmptyBookingsWidget({
    Key? key,
    required this.tabType,
    this.onBookNow,
  }) : super(key: key);

  String _getEmptyMessage() {
    switch (tabType.toLowerCase()) {
      case 'upcoming':
        return 'No upcoming bookings found.\nStart planning your luxury experience!';
      case 'past':
        return 'No past bookings to display.\nYour booking history will appear here.';
      case 'cancelled':
        return 'No cancelled bookings.\nGreat! All your reservations are active.';
      default:
        return 'No bookings found.\nDiscover our exclusive services and amenities.';
    }
  }

  String _getEmptyIcon() {
    switch (tabType.toLowerCase()) {
      case 'upcoming':
        return 'event_available';
      case 'past':
        return 'history';
      case 'cancelled':
        return 'cancel_presentation';
      default:
        return 'event_note';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: _getEmptyIcon(),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.6),
              size: 20.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _getEmptyMessage(),
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (tabType.toLowerCase() == 'upcoming' ||
              tabType.toLowerCase() == 'all') ...[
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onBookNow,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Book Now'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.mediumRadius,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  'Rooms',
                  'bed',
                  () => Navigator.pushNamed(context, '/room-booking'),
                ),
                _buildQuickActionButton(
                  'Spa',
                  'spa',
                  () => Navigator.pushNamed(context, '/service-reservations'),
                ),
                _buildQuickActionButton(
                  'Dining',
                  'restaurant',
                  () => Navigator.pushNamed(context, '/service-reservations'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, String iconName, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
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
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
