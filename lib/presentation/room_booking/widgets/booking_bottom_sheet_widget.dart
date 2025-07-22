import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final VoidCallback onReserveRoom;

  const BookingBottomSheetWidget({
    Key? key,
    required this.roomData,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onReserveRoom,
  }) : super(key: key);

  @override
  State<BookingBottomSheetWidget> createState() =>
      _BookingBottomSheetWidgetState();
}

class _BookingBottomSheetWidgetState extends State<BookingBottomSheetWidget> {
  int _guestCount = 2;
  final TextEditingController _specialRequestsController =
      TextEditingController();

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nights = widget.checkOutDate.difference(widget.checkInDate).inDays;
    final roomPrice = double.parse((widget.roomData['price'] as String)
        .replaceAll('\$', '')
        .replaceAll(',', ''));
    final subtotal = roomPrice * nights;
    final taxes = subtotal * 0.15;
    final total = subtotal + taxes;

    return Container(
      height: 85.h,
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
                  'Book Room',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Info
                  _buildRoomInfo(),
                  SizedBox(height: 3.h),

                  // Dates Info
                  _buildDatesInfo(),
                  SizedBox(height: 3.h),

                  // Guest Count
                  _buildGuestCountSection(),
                  SizedBox(height: 3.h),

                  // Special Requests
                  _buildSpecialRequestsSection(),
                  SizedBox(height: 3.h),

                  // Pricing Breakdown
                  _buildPricingBreakdown(
                      nights, roomPrice, subtotal, taxes, total),
                ],
              ),
            ),
          ),
          // Reserve Button
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onReserveRoom,
                    child: Text('Reserve Room'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImageWidget(
            imageUrl: ((widget.roomData['images'] as List).first as String),
            width: 20.w,
            height: 15.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.roomData['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                widget.roomData['price'] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'per night',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatesInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Check-in',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${widget.checkInDate.day}/${widget.checkInDate.month}/${widget.checkInDate.year}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'arrow_forward',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Check-out',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${widget.checkOutDate.day}/${widget.checkOutDate.month}/${widget.checkOutDate.year}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Guests',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            IconButton(
              onPressed:
                  _guestCount > 1 ? () => setState(() => _guestCount--) : null,
              icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: _guestCount > 1
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _guestCount.toString(),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed:
                  _guestCount < 4 ? () => setState(() => _guestCount++) : null,
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: _guestCount < 4
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              _guestCount == 1 ? 'Guest' : 'Guests',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Requests',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _specialRequestsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requests or preferences...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingBreakdown(int nights, double roomPrice, double subtotal,
      double taxes, double total) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing Breakdown',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPriceRow('\$${roomPrice.toStringAsFixed(2)} x $nights nights',
              '\$${subtotal.toStringAsFixed(2)}'),
          SizedBox(height: 1.h),
          _buildPriceRow('Taxes & Fees', '\$${taxes.toStringAsFixed(2)}'),
          SizedBox(height: 1.h),
          Divider(),
          _buildPriceRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)
              : AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        Text(
          amount,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                )
              : AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
