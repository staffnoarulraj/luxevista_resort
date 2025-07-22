import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_booking_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/recommendations_carousel_widget.dart';
import './widgets/upcoming_events_card_widget.dart';
import './widgets/weather_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data
  final Map<String, dynamic>? currentBooking = {
    "id": 1,
    "roomType": "Ocean View Suite",
    "checkIn": "Jul 25, 2025",
    "checkOut": "Jul 30, 2025",
    "roomNumber": "Room 1205 - Oceanfront",
    "status": "confirmed"
  };

  final List<Map<String, dynamic>> recommendations = [
    {
      "id": 1,
      "title": "Sunset Spa Experience",
      "category": "Wellness",
      "price": "\$180",
      "rating": "4.9",
      "image":
          "https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description":
          "Indulge in a luxurious spa treatment while watching the sunset over the ocean."
    },
    {
      "id": 2,
      "title": "Private Beach Dinner",
      "category": "Dining",
      "price": "\$320",
      "rating": "4.8",
      "image":
          "https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description":
          "Romantic candlelit dinner on your private stretch of pristine beach."
    },
    {
      "id": 3,
      "title": "Dolphin Watching Tour",
      "category": "Activities",
      "price": "\$95",
      "rating": "4.7",
      "image":
          "https://images.pexels.com/photos/64219/dolphin-marine-mammals-water-sea-64219.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description":
          "Early morning boat excursion to witness dolphins in their natural habitat."
    },
    {
      "id": 4,
      "title": "Underwater Restaurant",
      "category": "Dining",
      "price": "\$450",
      "rating": "5.0",
      "image":
          "https://images.pexels.com/photos/544966/pexels-photo-544966.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "description":
          "Dine surrounded by marine life in our world-renowned underwater restaurant."
    }
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      "id": 1,
      "title": "Wine Tasting Evening",
      "day": "25",
      "month": "JUL",
      "time": "7:00 PM - 9:00 PM",
      "location": "Sunset Terrace",
      "description":
          "Curated selection of premium wines paired with artisanal cheeses."
    },
    {
      "id": 2,
      "title": "Yoga at Sunrise",
      "day": "26",
      "month": "JUL",
      "time": "6:00 AM - 7:00 AM",
      "location": "Beach Pavilion",
      "description":
          "Start your day with peaceful yoga session facing the ocean."
    },
    {
      "id": 3,
      "title": "Cultural Dance Show",
      "day": "27",
      "month": "JUL",
      "time": "8:30 PM - 10:00 PM",
      "location": "Main Amphitheater",
      "description":
          "Traditional Maldivian cultural performance with local artists."
    }
  ];

  final Map<String, dynamic> weatherData = {
    "location": "Maldives",
    "temperature": 28,
    "condition": "Sunny",
    "feelsLike": 30,
    "humidity": 65,
    "windSpeed": 12,
    "uvIndex": 8,
    "seaTemp": 26
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Maintain scroll position across app sessions
    // This would typically be saved to SharedPreferences
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Dashboard Home
        break;
      case 1:
        Navigator.pushNamed(context, '/booking-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/service-reservations');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _openConciergeChat() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: 40.h,
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: 'support_agent',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Concierge Service',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Our dedicated concierge team is available 24/7 to assist you with any requests or questions.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/service-reservations');
                },
                child: Text('Start Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingHeaderWidget(
                      guestName: 'Alexander Thompson',
                      currentDate: 'Tuesday, July 22, 2025',
                    ),
                    SizedBox(height: 1.h),
                    if (currentBooking != null)
                      CurrentBookingCardWidget(
                        currentBooking: currentBooking,
                      ),
                    SizedBox(height: 2.h),
                    RecommendationsCarouselWidget(
                      recommendations: recommendations,
                    ),
                    SizedBox(height: 3.h),
                    QuickActionsGridWidget(),
                    SizedBox(height: 3.h),
                    UpcomingEventsCardWidget(
                      events: upcomingEvents,
                    ),
                    SizedBox(height: 2.h),
                    WeatherWidget(
                      weatherData: weatherData,
                    ),
                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _selectedIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'book_online',
              color: _selectedIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'room_service',
              color: _selectedIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openConciergeChat,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 6.0,
        child: CustomIconWidget(
          iconName: 'chat',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
