import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_bottom_sheet_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_button_widget.dart';
import './widgets/room_card_widget.dart';

class RoomBooking extends StatefulWidget {
  const RoomBooking({Key? key}) : super(key: key);

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  DateTime _checkInDate = DateTime.now().add(Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 3));
  Map<String, dynamic> _activeFilters = {};
  String _sortBy = 'price';
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // Mock room data
  final List<Map<String, dynamic>> _allRooms = [
    {
      "id": 1,
      "name": "Ocean View Deluxe Suite",
      "price": "\$450",
      "images": [
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg",
        "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg",
        "https://images.pexels.com/photos/1743229/pexels-photo-1743229.jpeg"
      ],
      "amenities": ["Ocean View", "WiFi", "Spa", "Balcony", "Room Service"],
      "isAvailable": true,
      "isFavorite": false,
      "roomType": "Deluxe",
      "viewType": "Ocean View"
    },
    {
      "id": 2,
      "name": "Presidential Ocean Suite",
      "price": "\$850",
      "images": [
        "https://images.pexels.com/photos/1743229/pexels-photo-1743229.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg",
        "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg"
      ],
      "amenities": [
        "Ocean View",
        "WiFi",
        "Spa",
        "Pool Access",
        "Minibar",
        "Air Conditioning"
      ],
      "isAvailable": true,
      "isFavorite": true,
      "roomType": "Presidential",
      "viewType": "Ocean View"
    },
    {
      "id": 3,
      "name": "Garden View Standard Room",
      "price": "\$220",
      "images": [
        "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg"
      ],
      "amenities": ["WiFi", "Air Conditioning", "Room Service"],
      "isAvailable": true,
      "isFavorite": false,
      "roomType": "Standard",
      "viewType": "Garden View"
    },
    {
      "id": 4,
      "name": "Pool View Deluxe Room",
      "price": "\$380",
      "images": [
        "https://images.pexels.com/photos/1743229/pexels-photo-1743229.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg",
        "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg"
      ],
      "amenities": ["Pool Access", "WiFi", "Balcony", "Minibar"],
      "isAvailable": false,
      "isFavorite": false,
      "roomType": "Deluxe",
      "viewType": "Pool View"
    },
    {
      "id": 5,
      "name": "City View Suite",
      "price": "\$320",
      "images": [
        "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg",
        "https://images.pexels.com/photos/1743229/pexels-photo-1743229.jpeg"
      ],
      "amenities": ["WiFi", "Room Service", "Air Conditioning", "Minibar"],
      "isAvailable": true,
      "isFavorite": false,
      "roomType": "Suite",
      "viewType": "City View"
    }
  ];

  List<Map<String, dynamic>> _filteredRooms = [];

  @override
  void initState() {
    super.initState();
    _filteredRooms = List.from(_allRooms);
    _sortRooms();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshRooms,
        child: Column(
          children: [
            // Sticky Date Picker
            DatePickerWidget(
              checkInDate: _checkInDate,
              checkOutDate: _checkOutDate,
              onDateTap: _showDatePicker,
            ),
            SizedBox(height: 1.h),

            // Filter and Sort Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  FilterButtonWidget(
                    onFilterTap: _showFilterBottomSheet,
                    activeFiltersCount: _getActiveFiltersCount(),
                  ),
                  SizedBox(width: 3.w),
                  _buildSortButton(),
                  Spacer(),
                  Text(
                    '${_filteredRooms.length} rooms',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),

            // Active Filter Chips
            _activeFilters.isNotEmpty
                ? _buildActiveFilterChips()
                : SizedBox.shrink(),

            // Room List
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _filteredRooms.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredRooms.length,
                          itemBuilder: (context, index) {
                            return RoomCardWidget(
                              roomData: _filteredRooms[index],
                              onViewDetails: () =>
                                  _viewRoomDetails(_filteredRooms[index]),
                              onBookNow: () => _showBookingBottomSheet(
                                  _filteredRooms[index]),
                              onFavoriteToggle: () => _toggleFavorite(index),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Room Booking'),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showSearchDialog,
          icon: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _sortBy = value;
          _sortRooms();
        });
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'price', child: Text('Price: Low to High')),
        PopupMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
        PopupMenuItem(value: 'name', child: Text('Name')),
        PopupMenuItem(value: 'availability', child: Text('Availability')),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            SizedBox(width: 1.w),
            Text(
              'Sort',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_activeFilters['roomTypes'] != null &&
        (_activeFilters['roomTypes'] as List).isNotEmpty) {
      for (String type in (_activeFilters['roomTypes'] as List)) {
        chips.add(_buildFilterChip(type, () => _removeRoomTypeFilter(type)));
      }
    }

    if (_activeFilters['viewTypes'] != null &&
        (_activeFilters['viewTypes'] as List).isNotEmpty) {
      for (String view in (_activeFilters['viewTypes'] as List)) {
        chips.add(_buildFilterChip(view, () => _removeViewTypeFilter(view)));
      }
    }

    if (_activeFilters['amenities'] != null &&
        (_activeFilters['amenities'] as List).isNotEmpty) {
      for (String amenity in (_activeFilters['amenities'] as List)) {
        chips.add(
            _buildFilterChip(amenity, () => _removeAmenityFilter(amenity)));
      }
    }

    return Container(
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: chips,
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Chip(
        label: Text(label),
        deleteIcon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 16,
        ),
        onDeleted: onRemove,
        backgroundColor:
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.primary,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          height: 35.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 25.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 2.h,
                        width: 60.w,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 1.5.h,
                        width: 40.w,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'hotel',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No rooms available',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your dates or filters to find available rooms.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeFilters.clear();
                  _applyFilters();
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkInDate, end: _checkOutDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerTheme.of(context).copyWith(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
      _refreshRooms();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _showBookingBottomSheet(Map<String, dynamic> roomData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingBottomSheetWidget(
        roomData: roomData,
        checkInDate: _checkInDate,
        checkOutDate: _checkOutDate,
        onReserveRoom: () {
          Navigator.pop(context);
          _showBookingConfirmation(roomData);
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return AlertDialog(
          title: Text('Search Rooms'),
          content: TextField(
            onChanged: (value) => searchQuery = value,
            decoration: InputDecoration(
              hintText: 'Enter room name or type...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _searchRooms(searchQuery);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingConfirmation(Map<String, dynamic> roomData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Your reservation for ${roomData['name']} has been confirmed.'),
            SizedBox(height: 1.h),
            Text(
                'Check-in: ${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}'),
            Text(
                'Check-out: ${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/booking-management');
            },
            child: Text('View Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshRooms() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _applyFilters();
    });
  }

  void _searchRooms(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRooms = List.from(_allRooms);
        _sortRooms();
      });
      return;
    }

    setState(() {
      _filteredRooms = _allRooms.where((room) {
        final name = (room['name'] as String).toLowerCase();
        final roomType = (room['roomType'] as String).toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || roomType.contains(searchLower);
      }).toList();
      _sortRooms();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allRooms);

    // Filter by room types
    if (_activeFilters['roomTypes'] != null &&
        (_activeFilters['roomTypes'] as List).isNotEmpty) {
      filtered = filtered.where((room) {
        return (_activeFilters['roomTypes'] as List).contains(room['roomType']);
      }).toList();
    }

    // Filter by view types
    if (_activeFilters['viewTypes'] != null &&
        (_activeFilters['viewTypes'] as List).isNotEmpty) {
      filtered = filtered.where((room) {
        return (_activeFilters['viewTypes'] as List).contains(room['viewType']);
      }).toList();
    }

    // Filter by amenities
    if (_activeFilters['amenities'] != null &&
        (_activeFilters['amenities'] as List).isNotEmpty) {
      filtered = filtered.where((room) {
        final roomAmenities = room['amenities'] as List<String>;
        return (_activeFilters['amenities'] as List)
            .any((amenity) => roomAmenities.contains(amenity));
      }).toList();
    }

    // Filter by price range
    if (_activeFilters['minPrice'] != null &&
        _activeFilters['maxPrice'] != null) {
      filtered = filtered.where((room) {
        final price = double.parse(
            (room['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
        return price >= (_activeFilters['minPrice'] as double) &&
            price <= (_activeFilters['maxPrice'] as double);
      }).toList();
    }

    setState(() {
      _filteredRooms = filtered;
      _sortRooms();
    });
  }

  void _sortRooms() {
    switch (_sortBy) {
      case 'price':
        _filteredRooms.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_desc':
        _filteredRooms.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll('\$', '').replaceAll(',', ''));
          return priceB.compareTo(priceA);
        });
        break;
      case 'name':
        _filteredRooms.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'availability':
        _filteredRooms.sort((a, b) {
          final availableA = a['isAvailable'] as bool;
          final availableB = b['isAvailable'] as bool;
          return availableB
              ? 1
              : availableA
                  ? -1
                  : 0;
        });
        break;
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      _filteredRooms[index]['isFavorite'] =
          !(_filteredRooms[index]['isFavorite'] as bool);
    });
  }

  void _viewRoomDetails(Map<String, dynamic> roomData) {
    // Navigate to room details screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(roomData['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${roomData['price']} per night'),
            SizedBox(height: 1.h),
            Text('Amenities:'),
            ...(roomData['amenities'] as List<String>)
                .map((amenity) => Text('• $amenity')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingBottomSheet(roomData);
            },
            child: Text('Book Now'),
          ),
        ],
      ),
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_activeFilters['roomTypes'] != null &&
        (_activeFilters['roomTypes'] as List).isNotEmpty) {
      count += (_activeFilters['roomTypes'] as List).length;
    }
    if (_activeFilters['viewTypes'] != null &&
        (_activeFilters['viewTypes'] as List).isNotEmpty) {
      count += (_activeFilters['viewTypes'] as List).length;
    }
    if (_activeFilters['amenities'] != null &&
        (_activeFilters['amenities'] as List).isNotEmpty) {
      count += (_activeFilters['amenities'] as List).length;
    }
    if (_activeFilters['minPrice'] != null ||
        _activeFilters['maxPrice'] != null) {
      count += 1;
    }
    return count;
  }

  void _removeRoomTypeFilter(String type) {
    setState(() {
      (_activeFilters['roomTypes'] as List).remove(type);
      if ((_activeFilters['roomTypes'] as List).isEmpty) {
        _activeFilters.remove('roomTypes');
      }
      _applyFilters();
    });
  }

  void _removeViewTypeFilter(String view) {
    setState(() {
      (_activeFilters['viewTypes'] as List).remove(view);
      if ((_activeFilters['viewTypes'] as List).isEmpty) {
        _activeFilters.remove('viewTypes');
      }
      _applyFilters();
    });
  }

  void _removeAmenityFilter(String amenity) {
    setState(() {
      (_activeFilters['amenities'] as List).remove(amenity);
      if ((_activeFilters['amenities'] as List).isEmpty) {
        _activeFilters.remove('amenities');
      }
      _applyFilters();
    });
  }
}
