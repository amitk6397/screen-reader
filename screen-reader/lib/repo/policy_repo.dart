import 'package:screen_reader/data/api_response.dart';
import 'package:screen_reader/data/network/network_api_service.dart';
import 'package:screen_reader/model/response/policy_res/policy_res_model.dart';
import 'package:screen_reader/res/app_urls.dart';

class PolicyRepo {
  final _api = NetworkApiService();

  // ================== GET ACTIVE POLICIES ==================
  Future<ApiResponse<PolicyResModel>> getPolicies() async {
    try {
      final res = await _api.getApi(AppUrls.policy);
      return ApiResponse.completed(PolicyResModel.fromJson(res));
    } catch (e) {
      return ApiResponse.error('Failed to fetch policies');
    }
  }
}
