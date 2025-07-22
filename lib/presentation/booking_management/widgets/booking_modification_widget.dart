import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingModificationWidget extends StatefulWidget {
  final Map<String, dynamic> booking;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const BookingModificationWidget({
    Key? key,
    required this.booking,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<BookingModificationWidget> createState() =>
      _BookingModificationWidgetState();
}

class _BookingModificationWidgetState extends State<BookingModificationWidget> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late int guestCount;
  late String specialRequests;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.booking['fullDate']);
    final timeParts = (widget.booking['time'] as String).split(':');
    selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    guestCount = widget.booking['guestCount'] as int;
    specialRequests = widget.booking['specialRequests'] ?? '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayStyle: AppTheme.lightTheme.textTheme.bodyMedium,
              yearStyle: AppTheme.lightTheme.textTheme.bodyMedium,
              weekdayStyle: AppTheme.lightTheme.textTheme.bodySmall,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.mediumRadius,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              hourMinuteTextColor: AppTheme.lightTheme.colorScheme.onSurface,
              dialHandColor: AppTheme.lightTheme.colorScheme.primary,
              dialBackgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.mediumRadius,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveChanges() {
    final updatedBooking = Map<String, dynamic>.from(widget.booking);
    updatedBooking['fullDate'] = selectedDate.toIso8601String();
    updatedBooking['date'] =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    updatedBooking['time'] =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    updatedBooking['guestCount'] = guestCount;
    updatedBooking['specialRequests'] = specialRequests;

    widget.onSave(updatedBooking);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
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
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Modify Booking',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onCancel,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.booking['serviceName'] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Reference: ${widget.booking['reference']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 4.h),
                _buildDateTimeSection(),
                SizedBox(height: 3.h),
                _buildGuestCountSection(),
                SizedBox(height: 3.h),
                _buildSpecialRequestsSection(),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        child: Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: AppTheme.smallRadius,
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: InkWell(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: AppTheme.smallRadius,
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: InkWell(
                  onTap: _selectTime,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Count',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: AppTheme.smallRadius,
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'people',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Number of guests',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: AppTheme.smallRadius,
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: guestCount > 1
                          ? () => setState(() => guestCount--)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: guestCount > 1
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                        size: 4.w,
                      ),
                      constraints:
                          BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Text(
                        guestCount.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: guestCount < 10
                          ? () => setState(() => guestCount++)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: guestCount < 10
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                        size: 4.w,
                      ),
                      constraints:
                          BoxConstraints(minWidth: 8.w, minHeight: 4.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: TextEditingController(text: specialRequests),
          onChanged: (value) => specialRequests = value,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requests or preferences...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
