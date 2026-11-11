
import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';

import '../../../../core/network/api_response.dart';

class LoginService {
  final SupabaseClientService _supabaseClientService;

  const LoginService({
    required this._supabaseClientService,
  });

  Future<ApiResponse<dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Authenticate user
      final authResponse = await _supabaseClientService.client.auth
          .signInWithPassword(
        email: email,
        password: password,
      );

      final authUser = authResponse.user;

      if (authUser == null) {
        return ApiResponse(
          message: 'Authentication failed',
          data: null,
        );
      }

      // 2. Get user profile and role
      final userResponse = await _supabaseClientService.client
          .from('users')
          .select('id, name, email, role, phone, auth_id')
          .eq('auth_id', authUser.id)
          .single();

      // 3. Check user role
      final role = userResponse['role'] as String?;

      if (role == null || role.toUpperCase() != 'ADMIN') {
        await _supabaseClientService.client.auth.signOut();

        return ApiResponse(
          message: 'Access denied. Admin account required.',
          data: null,
        );
      }

      // 4. Return user data
      return ApiResponse(
        data: userResponse,
      );
    } catch (e) {
      return ApiResponse(
        message: e.toString(),
        data: null,
      );
    }
  }
}
