import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  // Get current user
  User? get currentUser => _supabaseService.syncClient.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': 'guest',
        },
      );

      if (response.user != null && phone != null && phone.isNotEmpty) {
        // Update user profile with phone number
        await updateUserProfile(phone: phone);
      }

      return response;
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      final client = await _supabaseService.client;
      await client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!isAuthenticated) return null;

      final client = await _supabaseService.client;
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? fullName,
    String? phone,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? travelDates,
  }) async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      final client = await _supabaseService.client;
      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (preferences != null) updateData['preferences'] = preferences;
      if (travelDates != null) updateData['travel_dates'] = travelDates;

      if (updateData.isNotEmpty) {
        updateData['updated_at'] = DateTime.now().toIso8601String();

        await client
            .from('user_profiles')
            .update(updateData)
            .eq('id', currentUser!.id);
      }
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  // Listen to authentication state changes
  Stream<AuthState> get authStateChanges =>
      _supabaseService.syncClient.auth.onAuthStateChange;

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('user_profiles')
          .select('id')
          .eq('email', email)
          .limit(1);

      return response.isNotEmpty;
    } catch (error) {
      return false; // Assume email doesn't exist on error
    }
  }

  // Update user preferences
  Future<void> updatePreferences({
    String? language,
    String? currency,
    Map<String, bool>? notifications,
    List<String>? dietaryRestrictions,
    List<String>? specialRequests,
  }) async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      // Get current preferences
      final profile = await getUserProfile();
      if (profile == null) throw Exception('Profile not found');

      final currentPreferences =
          Map<String, dynamic>.from(profile['preferences'] ?? {});

      // Update preferences
      if (language != null) currentPreferences['language'] = language;
      if (currency != null) currentPreferences['currency'] = currency;
      if (notifications != null) {
        currentPreferences['notifications'] = {
          ...Map<String, dynamic>.from(
              currentPreferences['notifications'] ?? {}),
          ...notifications.map((key, value) => MapEntry(key, value)),
        };
      }
      if (dietaryRestrictions != null)
        currentPreferences['dietary_restrictions'] = dietaryRestrictions;
      if (specialRequests != null)
        currentPreferences['special_requests'] = specialRequests;

      await updateUserProfile(preferences: currentPreferences);
    } catch (error) {
      throw Exception('Failed to update preferences: $error');
    }
  }

  // Update travel dates
  Future<void> updateTravelDates({
    DateTime? checkIn,
    DateTime? checkOut,
    int? guests,
  }) async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      final travelData = <String, dynamic>{};

      if (checkIn != null) travelData['check_in'] = checkIn.toIso8601String();
      if (checkOut != null)
        travelData['check_out'] = checkOut.toIso8601String();
      if (guests != null) travelData['guests'] = guests;

      await updateUserProfile(travelDates: travelData);
    } catch (error) {
      throw Exception('Failed to update travel dates: $error');
    }
  }
}
