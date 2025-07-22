import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingHistorySummaryWidget extends StatelessWidget {
  final int totalBookings;
  final int completedStays;
  final String favoriteRoomType;
  final VoidCallback onViewAllTap;

  const BookingHistorySummaryWidget({
    Key? key,
    required this.totalBookings,
    required this.completedStays,
    required this.favoriteRoomType,
    required this.onViewAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Bookings',
                totalBookings.toString(),
                Icons.hotel,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                'Completed Stays',
                completedStays.toString(),
                Icons.check_circle,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: AppTheme.mediumRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorite Room Type',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                favoriteRoomType,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onViewAllTap,
            child: Text('View All Bookings'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: AppTheme.mediumRadius,
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
