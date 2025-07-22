import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/booking_filter_widget.dart';
import './widgets/booking_modification_widget.dart';
import './widgets/booking_stats_widget.dart';
import './widgets/booking_tab_widget.dart';
import './widgets/empty_bookings_widget.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({Key? key}) : super(key: key);

  @override
  State<BookingManagement> createState() => _BookingManagementState();
}

class _BookingManagementState extends State<BookingManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentFilter = 'all';
  String _currentSort = 'date_desc';
  bool _isRefreshing = false;
  bool _isCalendarView = false;

  final List<String> _tabs = ['Upcoming', 'Past', 'Cancelled'];
  final List<Map<String, dynamic>> _allBookings = [
    {
      "id": 1,
      "serviceName": "Ocean View Suite",
      "serviceType": "Room",
      "date": "25/07/2025",
      "fullDate": "2025-07-25T00:00:00.000Z",
      "time": "15:00",
      "guestCount": 2,
      "reference": "LV2025072501",
      "status": "Confirmed",
      "category": "upcoming",
      "specialRequests": "Late check-in requested",
      "price": "\$450.00",
      "isFavorite": false,
    },
    {
      "id": 2,
      "serviceName": "Couples Spa Treatment",
      "serviceType": "Spa",
      "date": "26/07/2025",
      "fullDate": "2025-07-26T00:00:00.000Z",
      "time": "10:30",
      "guestCount": 2,
      "reference": "LV2025072602",
      "status": "Confirmed",
      "category": "upcoming",
      "specialRequests": "",
      "price": "\$280.00",
      "isFavorite": true,
    },
    {
      "id": 3,
      "serviceName": "Beachfront Cabana",
      "serviceType": "Cabana",
      "date": "27/07/2025",
      "fullDate": "2025-07-27T00:00:00.000Z",
      "time": "09:00",
      "guestCount": 4,
      "reference": "LV2025072703",
      "status": "Pending",
      "category": "upcoming",
      "specialRequests": "Champagne service",
      "price": "\$180.00",
      "isFavorite": false,
    },
    {
      "id": 4,
      "serviceName": "Fine Dining Experience",
      "serviceType": "Dining",
      "date": "20/07/2025",
      "fullDate": "2025-07-20T00:00:00.000Z",
      "time": "19:30",
      "guestCount": 2,
      "reference": "LV2025072004",
      "status": "Completed",
      "category": "past",
      "specialRequests": "Vegetarian menu",
      "price": "\$320.00",
      "isFavorite": false,
    },
    {
      "id": 5,
      "serviceName": "Sunset Beach Tour",
      "serviceType": "Tour",
      "date": "18/07/2025",
      "fullDate": "2025-07-18T00:00:00.000Z",
      "time": "17:00",
      "guestCount": 2,
      "reference": "LV2025071805",
      "status": "Completed",
      "category": "past",
      "specialRequests": "",
      "price": "\$120.00",
      "isFavorite": true,
    },
    {
      "id": 6,
      "serviceName": "Deluxe Room",
      "serviceType": "Room",
      "date": "15/07/2025",
      "fullDate": "2025-07-15T00:00:00.000Z",
      "time": "14:00",
      "guestCount": 1,
      "reference": "LV2025071506",
      "status": "Cancelled",
      "category": "cancelled",
      "specialRequests": "",
      "price": "\$380.00",
      "isFavorite": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredBookings() {
    List<Map<String, dynamic>> filtered = List.from(_allBookings);

    // Filter by tab
    final currentTab = _tabs[_tabController.index].toLowerCase();
    if (currentTab == 'upcoming') {
      filtered = filtered
          .where((booking) => booking['category'] == 'upcoming')
          .toList();
    } else if (currentTab == 'past') {
      filtered =
          filtered.where((booking) => booking['category'] == 'past').toList();
    } else if (currentTab == 'cancelled') {
      filtered = filtered
          .where((booking) => booking['category'] == 'cancelled')
          .toList();
    }

    // Filter by service type
    if (_currentFilter != 'all') {
      filtered = filtered
          .where((booking) =>
              (booking['serviceType'] as String).toLowerCase() ==
              _currentFilter)
          .toList();
    }

    // Sort bookings
    switch (_currentSort) {
      case 'date_desc':
        filtered.sort((a, b) => DateTime.parse(b['fullDate'])
            .compareTo(DateTime.parse(a['fullDate'])));
        break;
      case 'date_asc':
        filtered.sort((a, b) => DateTime.parse(a['fullDate'])
            .compareTo(DateTime.parse(b['fullDate'])));
        break;
      case 'name':
        filtered.sort((a, b) =>
            (a['serviceName'] as String).compareTo(b['serviceName'] as String));
        break;
      case 'status':
        filtered.sort(
            (a, b) => (a['status'] as String).compareTo(b['status'] as String));
        break;
    }

    return filtered;
  }

  List<int> _getTabCounts() {
    return [
      _allBookings.where((booking) => booking['category'] == 'upcoming').length,
      _allBookings.where((booking) => booking['category'] == 'past').length,
      _allBookings
          .where((booking) => booking['category'] == 'cancelled')
          .length,
    ];
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showModificationBottomSheet(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BookingModificationWidget(
          booking: booking,
          onSave: (updatedBooking) {
            setState(() {
              final index = _allBookings
                  .indexWhere((b) => b['id'] == updatedBooking['id']);
              if (index != -1) {
                _allBookings[index] = updatedBooking;
              }
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking updated successfully'),
                backgroundColor: AppTheme.successLight,
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showCancellationDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.mediumRadius,
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.warningLight,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('Cancel Booking'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this booking?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: AppTheme.smallRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['serviceName'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${booking['date']} at ${booking['time']}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Reference: ${booking['reference']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: AppTheme.smallRadius,
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancellation Policy',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warningLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• Free cancellation up to 24 hours before\n• 50% refund for cancellations within 24 hours\n• No refund for same-day cancellations',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index =
                    _allBookings.indexWhere((b) => b['id'] == booking['id']);
                if (index != -1) {
                  _allBookings[index]['status'] = 'Cancelled';
                  _allBookings[index]['category'] = 'cancelled';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> booking) {
    setState(() {
      final index = _allBookings.indexWhere((b) => b['id'] == booking['id']);
      if (index != -1) {
        _allBookings[index]['isFavorite'] =
            !(_allBookings[index]['isFavorite'] as bool);
      }
    });

    final isFavorite = booking['isFavorite'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isFavorite ? 'Removed from favorites' : 'Added to favorites'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _getFilteredBookings();
    final tabCounts = _getTabCounts();
    final totalBookings = _allBookings.length;
    final upcomingBookings =
        _allBookings.where((b) => b['category'] == 'upcoming').length;
    final completedBookings =
        _allBookings.where((b) => b['category'] == 'past').length;
    final cancelledBookings =
        _allBookings.where((b) => b['category'] == 'cancelled').length;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Booking Management'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isCalendarView = !_isCalendarView;
              });
            },
            icon: CustomIconWidget(
              iconName: _isCalendarView ? 'view_list' : 'calendar_view_month',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              // Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking report exported successfully'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BookingStatsWidget(
            totalBookings: totalBookings,
            upcomingBookings: upcomingBookings,
            completedBookings: completedBookings,
            cancelledBookings: cancelledBookings,
          ),
          BookingFilterWidget(
            onFilterChanged: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            onSortChanged: (sort) {
              setState(() {
                _currentSort = sort;
              });
            },
            currentFilter: _currentFilter,
            currentSort: _currentSort,
          ),
          SizedBox(height: 2.h),
          BookingTabWidget(
            tabController: _tabController,
            tabs: _tabs,
            tabCounts: tabCounts,
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final tabBookings = _getFilteredBookings();

                if (tabBookings.isEmpty) {
                  return EmptyBookingsWidget(
                    tabType: tab,
                    onBookNow: () =>
                        Navigator.pushNamed(context, '/room-booking'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshBookings,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: tabBookings.length,
                    itemBuilder: (context, index) {
                      final booking = tabBookings[index];
                      return BookingCardWidget(
                        booking: booking,
                        onTap: () {
                          // Navigate to booking details
                        },
                        onCancel: () => _showCancellationDialog(booking),
                        onModify: () => _showModificationBottomSheet(booking),
                        onFavorite: () => _toggleFavorite(booking),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Booking Management tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/login-screen');
              break;
            case 1:
              Navigator.pushNamed(context, '/dashboard-home');
              break;
            case 2:
              Navigator.pushNamed(context, '/room-booking');
              break;
            case 3:
              Navigator.pushNamed(context, '/service-reservations');
              break;
            case 4:
              // Current screen
              break;
            case 5:
              Navigator.pushNamed(context, '/user-profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'login',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'login',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'bed',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'bed',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'spa',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'spa',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'event_note',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'event_note',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
