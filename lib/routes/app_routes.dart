import 'package:flutter/material.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/room_booking/room_booking.dart';
import '../presentation/service_reservations/service_reservations.dart';
import '../presentation/booking_management/booking_management.dart';
import '../presentation/user_profile/user_profile.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String dashboardHome = '/dashboard_home';
  static const String roomBooking = '/room_booking';
  static const String serviceReservations = '/service_reservations';
  static const String bookingManagement = '/booking_management';
  static const String userProfile = '/user_profile';

  static Map<String, WidgetBuilder> get routes => {
        loginScreen: (context) => const LoginScreen(),
        dashboardHome: (context) => const DashboardHome(),
        roomBooking: (context) => const RoomBooking(),
        serviceReservations: (context) => const ServiceReservations(),
        bookingManagement: (context) => const BookingManagement(),
        userProfile: (context) => const UserProfile(),
      };
}