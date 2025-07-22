import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/popular_services_section.dart';
import './widgets/service_card.dart';
import './widgets/service_category_chip.dart';
import './widgets/service_detail_modal.dart';
import './widgets/service_filter_bottom_sheet.dart';

class ServiceReservations extends StatefulWidget {
  const ServiceReservations({Key? key}) : super(key: key);

  @override
  State<ServiceReservations> createState() => _ServiceReservationsState();
}

class _ServiceReservationsState extends State<ServiceReservations> {
  int _currentBottomNavIndex = 2;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data for services
  final List<Map<String, dynamic>> _allServices = [
    {
      'id': 1,
      'name': 'Oceanview Spa Treatment',
      'category': 'Spa',
      'duration': '90 minutes',
      'price': '\$180',
      'rating': 4.8,
      'reviews': 124,
      'description':
          'Indulge in our signature oceanview spa treatment with premium aromatherapy oils and personalized massage techniques.',
      'fullDescription':
          'Experience ultimate relaxation with our signature oceanview spa treatment. This 90-minute session combines traditional massage techniques with modern wellness practices, all while enjoying breathtaking ocean views. Our expert therapists use premium aromatherapy oils and customize each treatment to your specific needs.',
      'image':
          'https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': true,
      'isFavorite': false,
      'isPopular': true,
    },
    {
      'id': 2,
      'name': 'Fine Dining Experience',
      'category': 'Dining',
      'duration': '2 hours',
      'price': '\$120',
      'rating': 4.9,
      'reviews': 89,
      'description':
          'Savor exquisite cuisine crafted by our award-winning chefs in an elegant oceanfront setting.',
      'fullDescription':
          'Embark on a culinary journey with our fine dining experience. Our award-winning chefs create innovative dishes using the finest local ingredients, perfectly paired with premium wines. Enjoy your meal in our elegant oceanfront restaurant with panoramic views.',
      'image':
          'https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': true,
      'isFavorite': true,
      'isPopular': true,
    },
    {
      'id': 3,
      'name': 'Private Beach Cabana',
      'category': 'Activities',
      'duration': '4 hours',
      'price': '\$200',
      'rating': 4.7,
      'reviews': 156,
      'description':
          'Enjoy exclusive access to a private beach cabana with personalized service and premium amenities.',
      'fullDescription':
          'Escape to your own private paradise with our exclusive beach cabana service. Each cabana comes with dedicated staff, premium refreshments, and luxury amenities. Perfect for couples or small groups seeking privacy and comfort.',
      'image':
          'https://images.pexels.com/photos/189296/pexels-photo-189296.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': true,
      'isFavorite': false,
      'isPopular': false,
    },
    {
      'id': 4,
      'name': 'Sunset Yacht Tour',
      'category': 'Tours',
      'duration': '3 hours',
      'price': '\$250',
      'rating': 4.9,
      'reviews': 203,
      'description':
          'Sail into the sunset aboard our luxury yacht with champagne service and gourmet appetizers.',
      'fullDescription':
          'Experience the magic of a tropical sunset from the deck of our luxury yacht. This exclusive tour includes champagne service, gourmet appetizers, and professional crew. Watch dolphins play in our wake as the sun sets over the horizon.',
      'image':
          'https://images.pexels.com/photos/1001682/pexels-photo-1001682.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': true,
      'isFavorite': true,
      'isPopular': true,
    },
    {
      'id': 5,
      'name': 'Couples Massage Suite',
      'category': 'Spa',
      'duration': '2 hours',
      'price': '\$320',
      'rating': 4.8,
      'reviews': 78,
      'description':
          'Romantic couples massage in our private suite with champagne and chocolate-covered strawberries.',
      'fullDescription':
          'Reconnect with your partner in our luxurious couples massage suite. This intimate experience includes synchronized massages by our expert therapists, champagne service, and chocolate-covered strawberries. The perfect romantic getaway.',
      'image':
          'https://images.pexels.com/photos/6663573/pexels-photo-6663573.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': false,
      'isFavorite': false,
      'isPopular': false,
    },
    {
      'id': 6,
      'name': 'Water Sports Adventure',
      'category': 'Activities',
      'duration': '3 hours',
      'price': '\$150',
      'rating': 4.6,
      'reviews': 134,
      'description':
          'Thrilling water sports package including jet skiing, parasailing, and snorkeling equipment.',
      'fullDescription':
          'Get your adrenaline pumping with our comprehensive water sports adventure package. Includes jet skiing, parasailing, snorkeling equipment, and professional instruction. All safety equipment and insurance included.',
      'image':
          'https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'isAvailable': true,
      'isFavorite': false,
      'isPopular': false,
    },
  ];

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'icon': 'apps'},
    {'name': 'Spa', 'icon': 'spa'},
    {'name': 'Dining', 'icon': 'restaurant'},
    {'name': 'Activities', 'icon': 'beach_access'},
    {'name': 'Tours', 'icon': 'directions_boat'},
  ];

  List<Map<String, dynamic>> get _filteredServices {
    List<Map<String, dynamic>> filtered = List.from(_allServices);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((service) => service['category'] == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((service) {
        final name = (service['name'] as String).toLowerCase();
        final description = (service['description'] as String).toLowerCase();
        final category = (service['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply additional filters
    if (_currentFilters.isNotEmpty) {
      filtered = filtered.where((service) {
        // Price filter
        if (_currentFilters['minPrice'] != null &&
            _currentFilters['maxPrice'] != null) {
          final price =
              double.parse((service['price'] as String).replaceAll('\$', ''));
          if (price < _currentFilters['minPrice'] ||
              price > _currentFilters['maxPrice']) {
            return false;
          }
        }

        // Duration filter
        if (_currentFilters['duration'] != null &&
            _currentFilters['duration'] != 'Any') {
          final duration = service['duration'] as String;
          final filterDuration = _currentFilters['duration'] as String;
          if (filterDuration == '30 min' && !duration.contains('30'))
            return false;
          if (filterDuration == '1 hour' &&
              !duration.contains('1') &&
              !duration.contains('90')) return false;
          if (filterDuration == '2 hours' && !duration.contains('2'))
            return false;
          if (filterDuration == '3+ hours' &&
              !duration.contains('3') &&
              !duration.contains('4')) return false;
        }

        // Availability filter
        if (_currentFilters['availableOnly'] == true &&
            !(service['isAvailable'] as bool)) {
          return false;
        }

        // Rating filter
        if (_currentFilters['minRating'] != null &&
            _currentFilters['minRating'] > 0) {
          if ((service['rating'] as double) < _currentFilters['minRating']) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _popularServices {
    return _allServices
        .where((service) => service['isPopular'] == true)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Implement pull-to-refresh or infinite scroll if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshServices,
        child: Column(
          children: [
            _buildSearchAndFilters(),
            _buildCategoryChips(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredServices.isEmpty
                      ? _buildEmptyState()
                      : _buildServicesList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Service Reservations',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showFilterBottomSheet,
          icon: CustomIconWidget(
            iconName: 'tune',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search services...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.primaryColor,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 8.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ServiceCategoryChip(
            title: category['name']!,
            iconName: category['icon']!,
            isSelected: _selectedCategory == category['name'],
            onTap: () {
              setState(() {
                _selectedCategory = category['name']!;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildServicesList() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (_selectedCategory == 'All' && _searchQuery.isEmpty)
          SliverToBoxAdapter(
            child: PopularServicesSection(
              popularServices: _popularServices,
              onServiceTap: _showServiceDetail,
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final service = _filteredServices[index];
              return ServiceCard(
                service: service,
                onTap: () => _showServiceDetail(service),
                onFavoriteToggle: () => _toggleFavorite(service),
                onQuickBook: () => _quickBookService(service),
              );
            },
            childCount: _filteredServices.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10.h),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading services...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'No services found',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _clearAllFilters,
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      onTap: _onBottomNavTap,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentBottomNavIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'hotel',
            color: _currentBottomNavIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'room_service',
            color: _currentBottomNavIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'event_note',
            color: _currentBottomNavIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentBottomNavIndex == 4
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard-home');
        break;
      case 1:
        Navigator.pushNamed(context, '/room-booking');
        break;
      case 2:
        // Current screen - do nothing
        break;
      case 3:
        Navigator.pushNamed(context, '/booking-management');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  Future<void> _refreshServices() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _currentFilters.clear();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceFilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _showServiceDetail(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailModal(
        service: service,
        onBookingConfirmed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Service booked successfully!'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> service) {
    setState(() {
      final index = _allServices.indexWhere((s) => s['id'] == service['id']);
      if (index != -1) {
        _allServices[index]['isFavorite'] =
            !(_allServices[index]['isFavorite'] as bool);
      }
    });

    final isFavorite = service['isFavorite'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Removed from favorites' : 'Added to favorites',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _quickBookService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quick Booking'),
        content: Text(
            'Would you like to book "${service['name']}" for the next available time slot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Quick booking confirmed!'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
