import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceDetailModal extends StatefulWidget {
  final Map<String, dynamic> service;
  final VoidCallback onBookingConfirmed;

  const ServiceDetailModal({
    Key? key,
    required this.service,
    required this.onBookingConfirmed,
  }) : super(key: key);

  @override
  State<ServiceDetailModal> createState() => _ServiceDetailModalState();
}

class _ServiceDetailModalState extends State<ServiceDetailModal>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _guestCount = 1;
  DateTime _selectedDate = DateTime.now();
  String _selectedTimeSlot = '';
  String _specialRequests = '';
  List<String> _selectedAddOns = [];
  double _totalPrice = 0;

  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM'
  ];

  final List<Map<String, dynamic>> _addOnServices = [
    {
      'name': 'Premium Package',
      'price': 50,
      'description': 'Enhanced experience with premium amenities'
    },
    {
      'name': 'Photography Service',
      'price': 75,
      'description': 'Professional photos of your experience'
    },
    {
      'name': 'Refreshments',
      'price': 25,
      'description': 'Complimentary drinks and snacks'
    },
    {
      'name': 'Transportation',
      'price': 40,
      'description': 'Round-trip luxury transport'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calculateTotalPrice();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    double basePrice =
        double.parse((widget.service['price'] as String).replaceAll('\$', ''));
    double addOnPrice = _selectedAddOns.fold(0, (sum, addOn) {
      final addOnData =
          _addOnServices.firstWhere((service) => service['name'] == addOn);
      return sum + (addOnData['price'] as int);
    });

    setState(() {
      _totalPrice = (basePrice * _guestCount) + addOnPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildImageGallery(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBookingTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
          _buildBookingFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.service['name'] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final List<String> images = [
      widget.service['image'] as String,
      'https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/6663573/pexels-photo-6663573.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ];

    return SizedBox(
      height: 25.h,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomImageWidget(
                imageUrl: images[index],
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'Overview'),
          Tab(text: 'Booking'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.service['category'] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.accentLight,
                size: 20,
              ),
              SizedBox(width: 1.w),
              Text(
                '${widget.service['rating']} (${widget.service['reviews']} reviews)',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Description',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.service['fullDescription'] ??
                'Experience luxury at its finest with our premium service offering. Our expert team ensures every detail is perfect for your comfort and satisfaction.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          Text(
            'What\'s Included',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ..._buildIncludedItems(),
          SizedBox(height: 3.h),
          Text(
            'Duration & Pricing',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                widget.service['duration'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Spacer(),
              Text(
                'Starting from ${widget.service['price']}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIncludedItems() {
    final items = [
      'Professional service staff',
      'Premium amenities',
      'Complimentary refreshments',
      'Luxury facilities access',
    ];

    return items
        .map((item) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successLight,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildBookingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelection(),
          SizedBox(height: 3.h),
          _buildTimeSlotSelection(),
          SizedBox(height: 3.h),
          _buildGuestCountSelection(),
          SizedBox(height: 3.h),
          _buildAddOnServices(),
          SizedBox(height: 3.h),
          _buildSpecialRequests(),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _timeSlots.map((timeSlot) {
            final isSelected = _selectedTimeSlot == timeSlot;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeSlot = timeSlot;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  timeSlot,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuestCountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Guests',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            IconButton(
              onPressed: _guestCount > 1
                  ? () {
                      setState(() {
                        _guestCount--;
                        _calculateTotalPrice();
                      });
                    }
                  : null,
              icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: _guestCount > 1
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 32,
              ),
            ),
            Container(
              width: 20.w,
              alignment: Alignment.center,
              child: Text(
                '$_guestCount',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: _guestCount < 10
                  ? () {
                      setState(() {
                        _guestCount++;
                        _calculateTotalPrice();
                      });
                    }
                  : null,
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: _guestCount < 10
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 32,
              ),
            ),
            Spacer(),
            Text(
              'Max 10 guests',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddOnServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-On Services',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ..._addOnServices.map((addOn) {
          final isSelected = _selectedAddOns.contains(addOn['name']);
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedAddOns.add(addOn['name'] as String);
                  } else {
                    _selectedAddOns.remove(addOn['name']);
                  }
                  _calculateTotalPrice();
                });
              },
              title: Text(
                addOn['name'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                addOn['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              secondary: Text(
                '+\$${addOn['price']}',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSpecialRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Requests',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requests or preferences...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            _specialRequests = value;
          },
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    final reviews = [
      {
        'name': 'Sarah Johnson',
        'rating': 5,
        'date': '2 days ago',
        'comment':
            'Absolutely amazing experience! The staff was incredibly professional and the service exceeded all expectations.',
        'avatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      },
      {
        'name': 'Michael Chen',
        'rating': 4,
        'date': '1 week ago',
        'comment':
            'Great service overall. The facilities were top-notch and the attention to detail was impressive.',
        'avatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      },
      {
        'name': 'Emma Wilson',
        'rating': 5,
        'date': '2 weeks ago',
        'comment':
            'Perfect for a special occasion. The luxury experience was worth every penny!',
        'avatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${widget.service['rating']}',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: 'star',
                        color:
                            index < (widget.service['rating'] as double).floor()
                                ? AppTheme.accentLight
                                : AppTheme.lightTheme.colorScheme.outline,
                        size: 16,
                      );
                    }),
                  ),
                  Text(
                    '${widget.service['reviews']} reviews',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...reviews.map((review) => _buildReviewItem(review)).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 6.w,
            backgroundImage: NetworkImage(review['avatar'] as String),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      review['date'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: List.generate(5, (index) {
                    return CustomIconWidget(
                      iconName: 'star',
                      color: index < (review['rating'] as int)
                          ? AppTheme.accentLight
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 14,
                    );
                  }),
                ),
                SizedBox(height: 1.h),
                Text(
                  review['comment'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingFooter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedTimeSlot.isNotEmpty ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Confirm Booking',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmBooking() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Confirmed'),
        content: Text(
            'Your service reservation has been confirmed. You will receive a confirmation email shortly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close modal
              widget.onBookingConfirmed();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
