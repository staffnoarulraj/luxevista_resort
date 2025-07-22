import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherWidget({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wb_sunny',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Local Weather',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                (weatherData['location'] as String?) ?? 'Maldives',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weatherData['temperature'] ?? '28'}°C',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      (weatherData['condition'] as String?) ?? 'Sunny',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Feels like ${weatherData['feelsLike'] ?? '30'}°C',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildWeatherDetail(
                            'water_drop',
                            'Humidity',
                            '${weatherData['humidity'] ?? '65'}%',
                          ),
                        ),
                        Expanded(
                          child: _buildWeatherDetail(
                            'air',
                            'Wind',
                            '${weatherData['windSpeed'] ?? '12'} km/h',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildWeatherDetail(
                            'visibility',
                            'UV Index',
                            '${weatherData['uvIndex'] ?? '8'}',
                          ),
                        ),
                        Expanded(
                          child: _buildWeatherDetail(
                            'waves',
                            'Sea Temp',
                            '${weatherData['seaTemp'] ?? '26'}°C',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String iconName, String label, String value) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.2.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
