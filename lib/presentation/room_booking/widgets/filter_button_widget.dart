import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onFilterTap;
  final int activeFiltersCount;

  const FilterButtonWidget({
    Key? key,
    required this.onFilterTap,
    this.activeFiltersCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onFilterTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: activeFiltersCount > 0
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: activeFiltersCount > 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'tune',
              color: activeFiltersCount > 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            SizedBox(width: 1.w),
            Text(
              'Filter',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: activeFiltersCount > 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            activeFiltersCount > 0 ? SizedBox(width: 1.w) : SizedBox.shrink(),
            activeFiltersCount > 0
                ? Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      activeFiltersCount.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
