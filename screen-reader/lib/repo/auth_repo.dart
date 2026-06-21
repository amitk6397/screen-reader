import 'package:screen_reader/data/api_response.dart';
import 'package:screen_reader/data/network/network_api_service.dart';
import 'package:screen_reader/model/response/auth_res/auth_res_model.dart';
import 'package:screen_reader/res/app_urls.dart';

class AuthRepo {
  final _api = NetworkApiService();

  // ================== ONBOARDING ==================
  Future<ApiResponse<OnboardingResModel>> getOnboardingData() async {
    try {
      final res = await _api.getApi(AppUrls.onboardingData);
      return ApiResponse.completed(OnboardingResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to fetch onboarding data');
    }
  }

  // ================== REGISTER ==================
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = {"name": name, "email": email, "password": password};
      final res = await _api.postApi(AppUrls.register, data);
      return ApiResponse.completed(res);
    } catch (e) {
      return ApiResponse.error('Registration failed');
    }
  }

  // ================== LOGIN ==================
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = {"email": email, "password": password};
      final res = await _api.postApi(AppUrls.login, data);
      return ApiResponse.completed(res);
    } catch (e) {
      return ApiResponse.error('Login failed');
    }
  }

  // ================== FORGOT PASSWORD ==================
  Future<ApiResponse<Map<String, dynamic>>> forgotPasswordVerify({
    required String email,
  }) async {
    try {
      final data = {"email": email};
      final res = await _api.postApi(AppUrls.forgotPassword, data);
      return ApiResponse.completed(res);
    } catch (e) {
      return ApiResponse.error('Failed to send verification');
    }
  }

  // ================== CONFIRM / RESET PASSWORD ==================
  Future<ApiResponse<Map<String, dynamic>>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = {
        "email": email,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };
      final res = await _api.postApi(AppUrls.confirmPassword, data);
      return ApiResponse.completed(res);
    } catch (e) {
      return ApiResponse.error('Failed to reset password');
    }
  }
}
