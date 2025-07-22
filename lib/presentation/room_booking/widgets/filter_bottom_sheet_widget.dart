import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = RangeValues(100, 1000);

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 100.0,
      (_filters['maxPrice'] as double?) ?? 1000.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Rooms',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text('Clear All'),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Type Section
                  _buildSectionTitle('Room Type'),
                  SizedBox(height: 1.h),
                  _buildRoomTypeFilters(),
                  SizedBox(height: 3.h),

                  // Price Range Section
                  _buildSectionTitle('Price Range'),
                  SizedBox(height: 1.h),
                  _buildPriceRangeFilter(),
                  SizedBox(height: 3.h),

                  // View Type Section
                  _buildSectionTitle('View Type'),
                  SizedBox(height: 1.h),
                  _buildViewTypeFilters(),
                  SizedBox(height: 3.h),

                  // Amenities Section
                  _buildSectionTitle('Amenities'),
                  SizedBox(height: 1.h),
                  _buildAmenitiesFilters(),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRoomTypeFilters() {
    final roomTypes = [
      'Standard',
      'Deluxe',
      'Suite',
      'Ocean View Suite',
      'Presidential'
    ];
    final selectedTypes = (_filters['roomTypes'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: roomTypes.map((type) {
        final isSelected = selectedTypes.contains(type);
        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedTypes.add(type);
              } else {
                selectedTypes.remove(type);
              }
              _filters['roomTypes'] = selectedTypes;
            });
          },
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 50,
          max: 2000,
          divisions: 39,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
              _filters['minPrice'] = values.start;
              _filters['maxPrice'] = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewTypeFilters() {
    final viewTypes = ['Ocean View', 'Garden View', 'City View', 'Pool View'];
    final selectedViews = (_filters['viewTypes'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: viewTypes.map((view) {
        final isSelected = selectedViews.contains(view);
        return FilterChip(
          label: Text(view),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedViews.add(view);
              } else {
                selectedViews.remove(view);
              }
              _filters['viewTypes'] = selectedViews;
            });
          },
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildAmenitiesFilters() {
    final amenities = [
      'WiFi',
      'Spa',
      'Pool Access',
      'Room Service',
      'Balcony',
      'Minibar',
      'Air Conditioning'
    ];
    final selectedAmenities = (_filters['amenities'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: amenities.map((amenity) {
        final isSelected = selectedAmenities.contains(amenity);
        return FilterChip(
          label: Text(amenity),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedAmenities.add(amenity);
              } else {
                selectedAmenities.remove(amenity);
              }
              _filters['amenities'] = selectedAmenities;
            });
          },
          selectedColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
        );
      }).toList(),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = RangeValues(100, 1000);
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
