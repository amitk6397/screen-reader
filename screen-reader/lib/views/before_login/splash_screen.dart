import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_reader/utils/textstyle.dart';

import '../../res/app_colors.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _ringController;
  late AnimationController _loaderController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _ringScale;
  late Animation<double> _loaderValue;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Animations
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    _ringScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
    );

    _loaderValue = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _loaderController, curve: Curves.easeInOut),
    );

    _logoController.forward();

    // Navigate after splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Get.offNamed(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _ringController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with Pulse Rings
            AnimatedBuilder(
              animation: _ringController,
              builder: (_, __) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ring
                    _buildRing(scale: _ringScale.value * 1.65, opacity: 0.04),
                    // Middle Ring
                    _buildRing(scale: _ringScale.value * 1.32, opacity: 0.09),
                    // Inner Ring
                    _buildRing(scale: _ringScale.value, opacity: 0.16),

                    // Logo Container
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (_, __) => FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: AppColors.navyMid(context),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: AppColors.accent,
                                width: 2.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.headphones_rounded,
                              color: AppColors.accent,
                              size: 42,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // App Name
            FadeTransition(
              opacity: _textFade,
              child: Text(
                'Audiara',
                style: text24(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                  context: context,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            FadeTransition(
              opacity: _textFade,
              child: Text(
                'Read with your ears, not your eyes',
                style: text16(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted(context),
                  context: context,
                ),
              ),
            ),

            const SizedBox(height: 64),

            // Loading Indicator
            FadeTransition(
              opacity: _textFade,
              child: AnimatedBuilder(
                animation: _loaderController,
                builder: (_, __) {
                  return SizedBox(
                    width: 52,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          // Background track
                          Container(color: AppColors.navyLight(context)),
                          // Moving highlight
                          FractionallySizedBox(
                            alignment: Alignment(
                              _loaderValue.value.clamp(-1.0, 1.0),
                              0,
                            ),
                            widthFactor: 0.45,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for rings
  Widget _buildRing({required double scale, required double opacity}) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 138,
        height: 138,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.accent.withOpacity(opacity),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
