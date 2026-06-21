import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_response.dart';
import '../../model/response/auth_res/auth_res_model.dart';
import '../../repo/auth_repo.dart';
import '../../routes/app_routes.dart';
import '../../utils/custom_snackbar.dart';

class OnboardingController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final PageController pageController = PageController();

  final Rx<ApiResponse<OnboardingResModel>> onboardingResponse =
      ApiResponse<OnboardingResModel>.loading().obs;
  final RxInt currentPage = 0.obs;

  List<Onboarding> get pages => onboardingResponse.value.data?.data ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchOnboarding();
  }

  Future<void> fetchOnboarding() async {
    onboardingResponse.value = ApiResponse<OnboardingResModel>.loading();
    onboardingResponse.value = await _authRepo.getOnboardingData();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (pages.isEmpty) return;
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(AppRoutes.register);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class LoginController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final response = await _authRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      final data = response.data;

      if (response.status == Status.completed && _isSuccess(data)) {
        // Persist token and user info
        final prefs = await SharedPreferences.getInstance();
        final userData = data?['data'] as Map<String, dynamic>?;
        if (userData != null) {
          await prefs.setString('token', userData['token'] ?? '');
          await prefs.setString('user_name', userData['name'] ?? '');
          await prefs.setString('user_email', userData['email'] ?? '');
          await prefs.setInt('user_id', userData['id'] ?? 0);
        }
        AppSnackbar.show(
          message: _message(data, fallback: 'Login successful'),
          type: SnackBarType.success,
        );
        Get.offAllNamed(AppRoutes.mySheel);
      } else {
        AppSnackbar.show(
          message: response.message ?? _message(data, fallback: 'Login failed'),
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(message: _errorMessage(e), type: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class RegisterController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final response = await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      final data = response.data;

      if (response.status == Status.completed && _isSuccess(data)) {
        // Persist token and user info
        final prefs = await SharedPreferences.getInstance();
        final userData = data?['data'] as Map<String, dynamic>?;
        if (userData != null) {
          await prefs.setString('token', userData['token'] ?? '');
          await prefs.setString('user_name', userData['name'] ?? '');
          await prefs.setString('user_email', userData['email'] ?? '');
          await prefs.setInt('user_id', userData['id'] ?? 0);
        }
        AppSnackbar.show(
          message: _message(data, fallback: 'Account created successfully'),
          type: SnackBarType.success,
        );
        Get.offAllNamed(AppRoutes.mySheel);
      } else {
        AppSnackbar.show(
          message: response.message ?? _message(data, fallback: 'Registration failed'),
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(message: _errorMessage(e), type: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class ForgotPasswordController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> sendResetLink() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final response = await _authRepo.forgotPasswordVerify(
        email: emailController.text.trim(),
      );
      final data = response.data;

      if (response.status == Status.completed && _isSuccess(data)) {
        AppSnackbar.show(
          message: _message(data, fallback: 'Reset link sent'),
          type: SnackBarType.success,
        );
      } else {
        AppSnackbar.show(
          message:
              response.message ??
              _message(data, fallback: 'Unable to send reset link'),
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(message: _errorMessage(e), type: SnackBarType.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

bool _isSuccess(Map<String, dynamic>? response) {
  if (response == null) return false;

  final success = response['success'];
  final status = response['status'];

  if (success is bool) return success;
  if (status is bool) return status;
  if (status is String) {
    return status.toLowerCase() == 'success' || status == '200';
  }
  if (status is num) return status >= 200 && status < 300;
  return false;
}

String _message(Map<String, dynamic>? response, {required String fallback}) {
  if (response == null) return fallback;

  final message = response['message'] ?? response['error'];
  if (message is String && message.trim().isNotEmpty) return message;
  return fallback;
}

String _errorMessage(Object error) {
  final text = error.toString().replaceFirst('Exception: ', '').trim();
  return text.isEmpty ? 'Something went wrong' : text;
}
