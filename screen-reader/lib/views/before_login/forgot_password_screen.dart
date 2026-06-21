import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';
import '../../utils/textstyle.dart';
import '../../view_model/before_login_ctr/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.navyLight(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'RESET PASSWORD',
                  style: text20(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Recover your account',
                  style: text26(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Enter your email and we will send password reset instructions.',
                  style: text15(
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'EMAIL',
                  style: text13(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                  style: text15(
                    color: AppColors.textPrimary(context),
                    context: context,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.navyMid(context),
                    hintText: 'you@example.com',
                    hintStyle: text15(
                      color: AppColors.textMuted(context),
                      context: context,
                    ),
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: AppColors.textMuted(context),
                      size: 22,
                    ),
                    border: _border(context),
                    enabledBorder: _border(context),
                    focusedBorder: _border(context, color: AppColors.accent),
                    errorBorder: _border(context, color: AppColors.error),
                    focusedErrorBorder: _border(
                      context,
                      color: AppColors.error,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.navy(context),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Reset Link',
                                  style: text16(
                                    fontWeight: FontWeight.w600,
                                    context: context,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color ?? AppColors.navyLight(context),
        width: 1.5,
      ),
    );
  }
}

String? _emailValidator(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required';
  if (!GetUtils.isEmail(email)) return 'Enter a valid email';
  return null;
}
