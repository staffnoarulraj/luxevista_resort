import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onQuickBook;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onQuickBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = service['isFavorite'] ?? false;
    final bool isAvailable = service['isAvailable'] ?? true;
    final bool isPopular = service['isPopular'] ?? false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showServiceOptions(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, isPopular, isFavorite),
            _buildContentSection(context, isAvailable),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
      BuildContext context, bool isPopular, bool isFavorite) {
    final bool isAvailable = service['isAvailable'] ?? true;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: CustomImageWidget(
            imageUrl: service['image'] as String,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
        if (isPopular)
          Positioned(
            top: 2.h,
            left: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: Colors.white,
                    size: 12,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Popular',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 2.h,
          right: 3.w,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: isFavorite ? 'favorite' : 'favorite_border',
                color:
                    isFavorite ? Colors.red : AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        if (!isAvailable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Currently Unavailable',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, bool isAvailable) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  service['category'] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                service['duration'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.accentLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${service['rating']} (${service['reviews']})',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            service['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Starting from',
                      style: AppTheme.lightTheme.textTheme.labelSmall,
                    ),
                    Text(
                      service['price'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isAvailable ? onQuickBook : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAvailable
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isAvailable ? 'Quick Book' : 'Unavailable',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showServiceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                'Share Service',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: service['isFavorite'] == true
                    ? 'favorite'
                    : 'favorite_border',
                color: service['isFavorite'] == true
                    ? Colors.red
                    : AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                service['isFavorite'] == true
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onFavoriteToggle();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
