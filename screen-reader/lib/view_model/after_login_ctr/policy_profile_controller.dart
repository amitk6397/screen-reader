import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_response.dart';
import '../../model/response/policy_res/policy_res_model.dart';
import '../../model/response/profile_res/profile_res_model.dart';
import '../../repo/policy_repo.dart';
import '../../repo/profile_repo.dart';
import '../../utils/custom_snackbar.dart';

/// Controller for the Privacy Policy screen.
class PolicyController extends GetxController {
  final PolicyRepo _policyRepo = PolicyRepo();

  final Rx<ApiResponse<PolicyResModel>> policyResponse =
      ApiResponse<PolicyResModel>.loading().obs;

  List<PolicyItem> get policies => policyResponse.value.data?.data ?? [];
  bool get isLoading => policyResponse.value.status == Status.loading;
  bool get hasError => policyResponse.value.status == Status.error;
  String get errorMessage => policyResponse.value.message ?? 'Failed to load policy';

  @override
  void onInit() {
    super.onInit();
    fetchPolicies();
  }

  Future<void> fetchPolicies() async {
    policyResponse.value = ApiResponse<PolicyResModel>.loading();
    policyResponse.value = await _policyRepo.getPolicies();
  }
}

/// Controller for the Profile screen — fetches and updates user profile.
class ProfileController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();

  final Rx<ApiResponse<ProfileResModel>> profileResponse =
      ApiResponse<ProfileResModel>.loading().obs;

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString profileImage = ''.obs;
  final RxBool isUpdating = false.obs;

  ProfileData? get profile => profileResponse.value.data;
  bool get isLoading => profileResponse.value.status == Status.loading;
  bool get hasError => profileResponse.value.status == Status.error;
  String get errorMessage => profileResponse.value.message ?? 'Failed to load profile';

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final savedName = prefs.getString('user_name') ?? '';
    final savedEmail = prefs.getString('user_email') ?? '';

    // Show cached data immediately while fetching
    if (savedName.isNotEmpty) userName.value = savedName;
    if (savedEmail.isNotEmpty) userEmail.value = savedEmail;

    if (token.isNotEmpty) {
      await fetchProfile(token: token);
    } else {
      profileResponse.value = ApiResponse<ProfileResModel>.error(
        'Not logged in — please log in again',
      );
    }
  }

  Future<void> fetchProfile({required String token}) async {
    profileResponse.value = ApiResponse<ProfileResModel>.loading();
    profileResponse.value = await _profileRepo.getProfile(token: token);

    if (profileResponse.value.status == Status.completed) {
      final data = profileResponse.value.data?.data;
      if (data != null) {
        userName.value = data.name;
        userEmail.value = data.email;
        profileImage.value = data.profileImage ?? '';
      }
    }
  }

  Future<void> updateName(String newName) async {
    if (newName.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      AppSnackbar.show(message: 'Session expired', type: SnackBarType.error);
      return;
    }

    isUpdating.value = true;
    try {
      final res = await _profileRepo.updateProfile(token: token, name: newName);
      if (res.status == Status.completed && (res.data?.success ?? false)) {
        userName.value = newName;
        AppSnackbar.show(message: 'Profile updated', type: SnackBarType.success);
      } else {
        AppSnackbar.show(
          message: res.message ?? 'Update failed',
          type: SnackBarType.error,
        );
      }
    } finally {
      isUpdating.value = false;
    }
  }
}
