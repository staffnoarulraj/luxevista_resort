import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import './widgets/booking_history_summary_widget.dart';
import './widgets/editable_field_widget.dart';
import './widgets/help_support_item_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/preference_toggle_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _authService.getUserProfile();
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        Fluttertoast.showToast(
            msg: "Failed to load profile. Please try again.");
      }
    }
  }

  Future<void> _handleSignOut() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Sign Out',
                    style: GoogleFonts.inter(
                        fontSize: 18.sp, fontWeight: FontWeight.w600)),
                content: Text('Are you sure you want to sign out?',
                    style: GoogleFonts.inter(fontSize: 14.sp)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel',
                          style: GoogleFonts.inter(
                              color: const Color(0xFF666666)))),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          await _authService.signOut();
                          if (mounted) {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.loginScreen);
                          }
                        } catch (e) {
                          if (mounted) {
                            Fluttertoast.showToast(msg: "Failed to sign out");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text('Sign Out',
                          style: GoogleFonts.inter(color: Colors.white))),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(
              title: Text('Profile',
                  style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              backgroundColor: const Color(0xFF8B7355),
              elevation: 0),
          body: const Center(child: CircularProgressIndicator()));
    }

    if (userProfile == null) {
      return Scaffold(
          appBar: AppBar(
              title: Text('Profile', style: GoogleFonts.inter()),
              backgroundColor: const Color(0xFF8B7355)),
          body: const Center(child: Text('Failed to load profile')));
    }

    final preferences = userProfile!['preferences'] ?? {};
    final notifications = preferences['notifications'] ?? {};

    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
            title: Text('Profile',
                style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            backgroundColor: const Color(0xFF8B7355),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: _handleSignOut,
                  icon: const Icon(Icons.logout, color: Colors.white)),
            ]),
        body: SingleChildScrollView(
            child: Column(children: [
          ProfileHeaderWidget(
            guestName: userProfile!['full_name'] ?? 'Guest',
            membershipStatus: userProfile!['membership_status'] ?? 'Standard',
            profileImageUrl: userProfile!['profile_image'] ?? '',
            onProfileImageTap: () {},
          ),

          SizedBox(height: 2.h),

          // Personal Information Section
          ProfileSectionWidget(title: 'Personal Information', children: [
            EditableFieldWidget(
                label: 'Full Name',
                value: userProfile!['full_name'] ?? '',
                onSave: (value) async {
                  await _authService.updateUserProfile(fullName: value);
                  _loadUserProfile();
                }),
            EditableFieldWidget(
                label: 'Phone Number',
                value: userProfile!['phone'] ?? '',
                onSave: (value) async {
                  await _authService.updateUserProfile(phone: value);
                  _loadUserProfile();
                }),
          ]),

          // Preferences Section
          ProfileSectionWidget(title: 'Preferences', children: [
            PreferenceToggleWidget(
                title: 'Email Notifications',
                value: notifications['email'] ?? true,
                onChanged: (value) async {
                  await _authService
                      .updatePreferences(notifications: {'email': value});
                  _loadUserProfile();
                }),
            PreferenceToggleWidget(
                title: 'Push Notifications',
                value: notifications['push'] ?? true,
                onChanged: (value) async {
                  await _authService
                      .updatePreferences(notifications: {'push': value});
                  _loadUserProfile();
                }),
            PreferenceToggleWidget(
                title: 'SMS Notifications',
                value: notifications['sms'] ?? false,
                onChanged: (value) async {
                  await _authService
                      .updatePreferences(notifications: {'sms': value});
                  _loadUserProfile();
                }),
          ]),

          // Booking History Summary
          BookingHistorySummaryWidget(
            totalBookings: userProfile!['total_bookings'] ?? 0,
            completedStays: userProfile!['completed_stays'] ?? 0,
            favoriteRoomType: userProfile!['favorite_room_type'] ?? 'Standard',
            onViewAllTap: () {},
          ),

          // Payment Methods Section
          ProfileSectionWidget(title: 'Payment Methods', children: [
            PaymentMethodWidget(
              cardType: 'Visa',
              lastFourDigits: '1234',
              expiryDate: '12/25',
              isDefault: true,
              onSetDefault: () {},
              onRemove: () {},
            ),
          ]),

          // Help & Support Section
          ProfileSectionWidget(title: 'Help & Support', children: [
            HelpSupportItemWidget(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Frequently asked questions',
              onTap: () {},
            ),
            HelpSupportItemWidget(
              icon: Icons.support_agent,
              title: 'Contact Support',
              subtitle: 'Get help from our team',
              onTap: () {},
            ),
            HelpSupportItemWidget(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we protect your data',
              onTap: () {},
            ),
            HelpSupportItemWidget(
              icon: Icons.article_outlined,
              title: 'Terms of Service',
              subtitle: 'Terms and conditions',
              onTap: () {},
            ),
          ]),

          SizedBox(height: 3.h),
        ])));
  }
}