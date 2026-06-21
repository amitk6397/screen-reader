import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_response.dart';
import '../../model/response/auth_res/auth_res_model.dart';
import '../../res/app_colors.dart';
import '../../utils/textstyle.dart';
import '../../view_model/before_login_ctr/auth_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Obx(() {
          final response = controller.onboardingResponse.value;

          if (response.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (response.status == Status.error) {
            return _ErrorState(
              message: response.message ?? 'Unable to load onboarding',
              onRetry: controller.fetchOnboarding,
            );
          }

          final pages = controller.pages;
          if (pages.isEmpty) {
            return _ErrorState(
              message: 'No onboarding data found',
              onRetry: controller.fetchOnboarding,
            );
          }

          final currentPage = controller.currentPage.value.clamp(
            0,
            pages.length - 1,
          );

          return Column(
            children: [
              Expanded(
                flex: 5,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: pages.length,
                  itemBuilder: (_, i) => _OnboardPage(data: pages[i]),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        children: List.generate(
                          pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 7),
                            height: 4,
                            width: i == currentPage ? 22 : 8,
                            decoration: BoxDecoration(
                              color: i == currentPage
                                  ? AppColors.accent
                                  : AppColors.navyLight(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Text(
                          pages[currentPage].title ?? '',
                          key: ValueKey('title$currentPage'),
                          style: text26(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(context),
                            context: context,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Text(
                          pages[currentPage].description ?? '',
                          key: ValueKey('sub$currentPage'),
                          style: text16(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMuted(context),
                            context: context,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            currentPage == pages.length - 1
                                ? 'Get Started'
                                : 'Continue',
                            style: text16(
                              fontWeight: FontWeight.w600,
                              context: context,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final Onboarding data;

  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final imageUrl = data.imageUrl;

    return Container(
      color: AppColors.navyMid(context),
      child: Center(
        child: imageUrl == null || imageUrl.isEmpty
            ? _FallbackIcon()
            : Image.network(
                imageUrl,
                width: 190,
                height: 190,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _FallbackIcon(),
              ),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withOpacity(0.13),
      ),
      child: const Icon(
        Icons.headphones_rounded,
        size: 58,
        color: AppColors.accent,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 44),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text15(
                color: AppColors.textPrimary(context),
                context: context,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
