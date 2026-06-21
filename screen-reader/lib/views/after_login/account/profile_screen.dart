// lib/views/after_login/account/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_reader/views/after_login/account/privacy_policy_screen.dart';
import 'package:screen_reader/views/after_login/account/profile_edit.dart';
import 'package:screen_reader/views/after_login/account/sleep_time_screen.dart';
import 'package:screen_reader/views/after_login/account/voice_setting_scrren.dart';
import 'package:screen_reader/view_model/global_controller/theme_controller.dart';

import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';
import 'notification_screen.dart';
import 'playback_speed_screen.dart';
import 'screen_reader_screen.dart';
import 'font_size_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: Row(
                  children: [
                    Text('Profile',
                        style: text24(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(context),
                            context: context)),
                    const Spacer(),

                    // Theme toggle button
                    GestureDetector(
                      onTap: () => themeProvider.toggle(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.navyMid(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.navyLight(context)),
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                          color: AppColors.accent,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Settings button
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.navyLight(context)),
                      ),
                      child: Icon(Icons.settings_outlined,
                          color: AppColors.textMuted(context), size: 18),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Profile card ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.navyLight(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('R',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F1724),
                              )),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rohan Sharma',
                                style: text20(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary(context),
                                    context: context)),
                            const SizedBox(height: 2),
                            Text('rohan@example.com',
                                style: text12(
                                    color: AppColors.textMuted(context),
                                    context: context)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accentDim,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Pro Member',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.accent,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                        child: Icon(Icons.edit_outlined,
                            color: AppColors.textMuted(context), size: 18),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Stats ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _statBox(context, '47', 'Books Read'),
                    const SizedBox(width: 10),
                    _statBox(context, '128h', 'Listened'),
                    const SizedBox(width: 10),
                    _statBox(context, '12', 'Day Streak'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Menu ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    _menuSection(context, isDark, 'Preferences', [
                      _MenuItem(Icons.mic_none_rounded, 'Voice Settings', AppColors.coverGreen,
                          route: const VoiceSettingsScreen()),
                      _MenuItem(Icons.speed_rounded, 'Playback Speed', AppColors.coverBlue,
                          route: const PlaybackSpeedScreen()),
                      _MenuItem(Icons.nightlight_round, 'Sleep Timer', AppColors.coverPurple,
                          route: const SleepTimerScreen()),
                    ]),
                    const SizedBox(height: 12),
                    _menuSection(context, isDark, 'Accessibility', [
                      _MenuItem(Icons.accessibility_new_rounded, 'Screen Reader', AppColors.info,
                          route: const ScreenReaderScreen()),
                      _MenuItem(Icons.text_fields_rounded, 'Font Size', AppColors.coverTeal,
                          route: const FontSizeScreen()),
                    ]),
                    const SizedBox(height: 12),
                    _menuSection(context, isDark, 'Account', [
                      _MenuItem(Icons.brightness_6_rounded, 'Appearance', AppColors.coverPurple,
                          isThemeToggle: true),
                      _MenuItem(Icons.notifications_outlined, 'Notifications', AppColors.warning,
                          route: const NotificationsScreen()),
                      _MenuItem(Icons.privacy_tip_outlined, 'Privacy', AppColors.textMuted(context),
                          route: const PrivacyScreen()),
                      _MenuItem(Icons.logout_rounded, 'Log Out', AppColors.danger, danger: true),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.navyLight(context), width: 1),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                )),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted(context),
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                )),
          ],
        ),
      ),
    );
  }

  Widget _menuSection(
      BuildContext context, bool isDark, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2),
          child: Text(title.toUpperCase(),
              style: text12(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted(context),
                  context: context)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navyMid(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.navyLight(context), width: 1),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.isThemeToggle) {
                        Get.find<ThemeProvider>().toggle();
                      } else if (item.danger) {
                        showLogoutDialog(context, onConfirm: () {});
                      } else if (item.route != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => item.route!));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon, color: item.color, size: 17),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(item.label,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: item.danger
                                      ? AppColors.danger
                                      : AppColors.textPrimary(context),
                                )),
                          ),
                          // Inline toggle for theme row
                          if (item.isThemeToggle)
                            _ThemeSwitch(isDark: isDark)
                          else
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.textMuted(context), size: 18),
                        ],
                      ),
                    ),
                  ),
                  if (i < items.length - 1)
                    Divider(height: 1, color: AppColors.navyLight(context), indent: 60),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Animated pill toggle ─────────────────────────────────────────────────────
class _ThemeSwitch extends StatelessWidget {
  final bool isDark;
  const _ThemeSwitch({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 52,
      height: 28,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF243047) : AppColors.accent.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.navyLight(context) : AppColors.accent.withOpacity(0.5),
        ),
      ),
      child: Stack(
        children: [
          // Sun icon (left)
          const Positioned(
            left: 6,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(Icons.light_mode_rounded,
                  size: 13, color: AppColors.accent),
            ),
          ),
          // Moon icon (right)
          Positioned(
            right: 6,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(Icons.dark_mode_rounded,
                  size: 13, color: AppColors.textMuted(context)),
            ),
          ),
          // Sliding thumb
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isDark ? 26 : 2,
            top: 2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDark ? AppColors.accent : AppColors.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 13,
                color: const Color(0xFF0F1724),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ───────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final bool danger;
  final bool isThemeToggle;
  final Widget? route;

  const _MenuItem(this.icon, this.label, this.color,
      {this.danger = false, this.isThemeToggle = false, this.route});
}

// ── Logout dialog (unchanged logic) ─────────────────────────────────────────
void showLogoutDialog(BuildContext context, {required VoidCallback onConfirm}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) => _LogoutDialog(onConfirm: onConfirm),
  );
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.danger.withOpacity(0.25), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.danger.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 28),
            ),
            const SizedBox(height: 18),
            Text('Log Out?',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                )),
            const SizedBox(height: 8),
            Text(
              'You will be signed out of your account. Your reading progress and settings will be saved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                color: AppColors.textMuted(context),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.navyLight(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.navyLight(context)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('Log Out',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
