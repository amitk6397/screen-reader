import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_reader/utils/textstyle.dart';

import '../../res/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../view_model/before_login_ctr/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

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
                _BackButton(),
                const SizedBox(height: 32),
                Text(
                  'START FREE',
                  style: text20(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create your Account',
                  style: text26(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    context: context,
                  ),
                ),
                const SizedBox(height: 40),
                _buildLabel(context, 'FULL NAME'),
                const SizedBox(height: 8),
                _AuthField(
                  controller: controller.nameController,
                  hint: 'ex. Rahul Sharma',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if ((value?.trim() ?? '').isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel(context, 'EMAIL'),
                const SizedBox(height: 8),
                _AuthField(
                  controller: controller.emailController,
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 20),
                _buildLabel(context, 'PASSWORD'),
                const SizedBox(height: 8),
                Obx(
                  () => _AuthField(
                    controller: controller.passwordController,
                    hint: 'Min. 6 characters',
                    icon: Icons.lock_outline_rounded,
                    obscure: controller.obscurePassword.value,
                    validator: _passwordValidator,
                    suffixIcon: GestureDetector(
                      onTap: controller.togglePassword,
                      child: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => _SubmitButton(
                    title: 'Create Account',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.navyLight(context)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: text13(
                          color: AppColors.textMuted(context),
                          context: context,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.navyLight(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.offNamed(AppRoutes.login),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a member? ',
                        style: text14(
                          color: AppColors.textMuted(context),
                          context: context,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: text15(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _badge(context, Icons.shield_outlined, 'SSL Secured'),
                    const SizedBox(width: 20),
                    _badge(context, Icons.verified_outlined, 'Privacy First'),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

Widget _buildLabel(BuildContext context, String text) {
  return Text(
    text,
    style: text13(
      fontWeight: FontWeight.w500,
      color: AppColors.textMuted(context),
      context: context,
    ),
  );
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: text15(color: AppColors.textPrimary(context), context: context),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.navyMid(context),
        hintText: hint,
        hintStyle: text15(
          color: AppColors.textMuted(context),
          context: context,
        ),
        prefixIcon: Icon(icon, color: AppColors.textMuted(context), size: 22),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 16),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(minWidth: 38),
        border: _border(context),
        enabledBorder: _border(context),
        focusedBorder: _border(context, color: AppColors.accent),
        errorBorder: _border(context, color: AppColors.error),
        focusedErrorBorder: _border(context, color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
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

class _SubmitButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.title,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
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
                    title,
                    style: text16(
                      fontWeight: FontWeight.w600,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }
}

Widget _badge(BuildContext context, IconData icon, String label) {
  return Row(
    children: [
      Icon(icon, size: 16, color: AppColors.accent),
      const SizedBox(width: 6),
      Text(
        label,
        style: text11(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
          context: context,
        ),
      ),
    ],
  );
}

String? _emailValidator(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required';
  if (!GetUtils.isEmail(email)) return 'Enter a valid email';
  return null;
}

String? _passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}
