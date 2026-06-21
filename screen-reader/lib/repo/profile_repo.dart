import 'package:screen_reader/data/api_response.dart';
import 'package:screen_reader/data/network/network_api_service.dart';
import 'package:screen_reader/model/response/profile_res/profile_res_model.dart';
import 'package:screen_reader/res/app_urls.dart';

class ProfileRepo {
  final _api = NetworkApiService();

  // ================== GET PROFILE ==================
  Future<ApiResponse<ProfileResModel>> getProfile({required String token}) async {
    try {
      _api.setToken(token);
      final res = await _api.getApi(AppUrls.profile);
      return ApiResponse.completed(ProfileResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to fetch profile');
    }
  }

  // ================== UPDATE PROFILE ==================
  Future<ApiResponse<ProfileResModel>> updateProfile({
    required String token,
    required String name,
  }) async {
    try {
      _api.setToken(token);
      final data = {"name": name};
      final res = await _api.putApi(AppUrls.profile, data);
      return ApiResponse.completed(ProfileResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to update profile');
    }
  }
}
