import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoomCardWidget extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final VoidCallback onViewDetails;
  final VoidCallback onBookNow;
  final VoidCallback onFavoriteToggle;

  const RoomCardWidget({
    Key? key,
    required this.roomData,
    required this.onViewDetails,
    required this.onBookNow,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images =
        (widget.roomData['images'] as List).cast<String>();
    final List<String> amenities =
        (widget.roomData['amenities'] as List).cast<String>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Gallery Section
          Stack(
            children: [
              Container(
                height: 25.h,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: CustomImageWidget(
                        imageUrl: images[index],
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              // Favorite Button
              Positioned(
                top: 2.h,
                right: 4.w,
                child: InkWell(
                  onTap: widget.onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: (widget.roomData['isFavorite'] as bool)
                          ? 'favorite'
                          : 'favorite_border',
                      color: (widget.roomData['isFavorite'] as bool)
                          ? Colors.red
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Page Indicators
              images.length > 1
                  ? Positioned(
                      bottom: 2.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                            width: _currentImageIndex == index ? 3.w : 2.w,
                            height: 1.h,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? AppTheme.lightTheme.colorScheme.surface
                                  : AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          // Room Details Section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name and Availability
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.roomData['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: (widget.roomData['isAvailable'] as bool)
                            ? AppTheme.successLight.withValues(alpha: 0.1)
                            : AppTheme.warningLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (widget.roomData['isAvailable'] as bool)
                            ? 'Available'
                            : 'Limited',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: (widget.roomData['isAvailable'] as bool)
                              ? AppTheme.successLight
                              : AppTheme.warningLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                // Amenities Icons
                Wrap(
                  spacing: 3.w,
                  runSpacing: 1.h,
                  children: amenities.take(4).map((amenity) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _getAmenityIcon(amenity),
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          amenity,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),
                // Pricing and Actions
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.roomData['price'] as String,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'per night',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: widget.onViewDetails,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            minimumSize: Size(0, 0),
                          ),
                          child: Text(
                            'Details',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        ElevatedButton(
                          onPressed: (widget.roomData['isAvailable'] as bool)
                              ? widget.onBookNow
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            minimumSize: Size(0, 0),
                          ),
                          child: Text(
                            'Book Now',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return 'wifi';
      case 'ocean view':
        return 'waves';
      case 'balcony':
        return 'balcony';
      case 'spa':
        return 'spa';
      case 'pool access':
        return 'pool';
      case 'room service':
        return 'room_service';
      case 'air conditioning':
        return 'ac_unit';
      case 'minibar':
        return 'local_bar';
      default:
        return 'check_circle';
    }
  }
}
