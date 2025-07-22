import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingFilterWidget extends StatefulWidget {
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;
  final String currentFilter;
  final String currentSort;

  const BookingFilterWidget({
    Key? key,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.currentFilter,
    required this.currentSort,
  }) : super(key: key);

  @override
  State<BookingFilterWidget> createState() => _BookingFilterWidgetState();
}

class _BookingFilterWidgetState extends State<BookingFilterWidget> {
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Filter & Sort',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Service Type',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildFilterChip('All', 'all'),
                _buildFilterChip('Room', 'room'),
                _buildFilterChip('Spa', 'spa'),
                _buildFilterChip('Dining', 'dining'),
                _buildFilterChip('Cabana', 'cabana'),
                _buildFilterChip('Tour', 'tour'),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Sort By',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              children: [
                _buildSortOption('Date (Newest)', 'date_desc'),
                _buildSortOption('Date (Oldest)', 'date_asc'),
                _buildSortOption('Service Name', 'name'),
                _buildSortOption('Status', 'status'),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onFilterChanged('all');
                      widget.onSortChanged('date_desc');
                      Navigator.pop(context);
                    },
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = widget.currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        widget.onFilterChanged(value);
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedColor:
          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
      checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
      labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.dividerColor,
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = widget.currentSort == value;
    return RadioListTile<String>(
      title: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      value: value,
      groupValue: widget.currentSort,
      onChanged: (value) {
        if (value != null) {
          widget.onSortChanged(value);
        }
      },
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: AppTheme.smallRadius,
                border: Border.all(
                  color:
                      AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search bookings...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintStyle:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: AppTheme.smallRadius,
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              onPressed: _showFilterBottomSheet,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: BoxConstraints(
                minWidth: 12.w,
                minHeight: 6.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
