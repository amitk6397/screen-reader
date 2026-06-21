import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';
import '../../../view_model/after_login_ctr/policy_profile_controller.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final PolicyController _policyCtrl = Get.put(PolicyController());
  bool _shareActivity = false;
  bool _personalizedAds = false;
  bool _analytics = true;
  bool _crashReports = true;
  bool _publicProfile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.navyLight(context)),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textMuted(context), size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Privacy',
                      style: text24(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                          context: context)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.shield_outlined,
                              color: AppColors.info, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your data is encrypted and never sold to third parties.',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── API Policy Section ─────────────────────
                    Obx(() {
                      if (_policyCtrl.isLoading) {
                        return Column(
                          children: [
                            _sectionLabel(context, 'Policies'),
                            const SizedBox(height: 8),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.navyMid(context),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      if (_policyCtrl.hasError) {
                        return Column(
                          children: [
                            _sectionLabel(context, 'Policies'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.navyMid(context),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.danger.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.wifi_off_rounded,
                                      color: AppColors.danger, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _policyCtrl.errorMessage,
                                      style: text13(
                                          color: AppColors.textMuted(context),
                                          context: context),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _policyCtrl.fetchPolicies,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('Retry',
                                          style: text12(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              context: context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      if (_policyCtrl.policies.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel(context, 'App Policies'),
                          const SizedBox(height: 8),
                          ...List.generate(_policyCtrl.policies.length, (i) {
                            final p = _policyCtrl.policies[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PolicyCard(
                                  title: p.title, description: p.description),
                            );
                          }),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),

                    _sectionLabel(context, 'Profile'),
                    const SizedBox(height: 8),
                    _toggleTile(
                      'Public Profile',
                      'Let others find and view your profile',
                      Icons.person_outline_rounded,
                      AppColors.coverTeal,
                      _publicProfile,
                          (v) => setState(() => _publicProfile = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Share Reading Activity',
                      'Show your reading progress to followers',
                      Icons.bar_chart_rounded,
                      AppColors.coverBlue,
                      _shareActivity,
                          (v) => setState(() => _shareActivity = v),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Data & Analytics'),
                    const SizedBox(height: 8),
                    _toggleTile(
                      'Usage Analytics',
                      'Help improve the app with anonymous data',
                      Icons.analytics_outlined,
                      AppColors.coverGreen,
                      _analytics,
                          (v) => setState(() => _analytics = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Crash Reports',
                      'Automatically send crash logs',
                      Icons.bug_report_outlined,
                      AppColors.coverPurple,
                      _crashReports,
                          (v) => setState(() => _crashReports = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Personalized Ads',
                      'Show ads based on your interests',
                      Icons.ads_click_rounded,
                      AppColors.textMuted(context),
                      _personalizedAds,
                          (v) => setState(() => _personalizedAds = v),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Legal'),
                    const SizedBox(height: 8),
                    _linkTile('Privacy Policy', Icons.privacy_tip_outlined,
                        AppColors.info),
                    const SizedBox(height: 10),
                    _linkTile('Terms of Service', Icons.gavel_rounded,
                        AppColors.coverTeal),
                    const SizedBox(height: 10),
                    _linkTile('Data Deletion Request',
                        Icons.delete_forever_outlined, AppColors.danger,
                        danger: true),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 2),
    child: Text(text.toUpperCase(),
        style: text12(
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted(context),
            context: context)),
  );

  Widget _toggleTile(String title, String subtitle, IconData icon, Color color,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyLight(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: text14(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary(context),
                      context: context,
                    )),
                Text(subtitle,
                    style: text11(
                      color: AppColors.textMuted(context),
                      context: context,
                    )),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            activeTrackColor: color.withOpacity(0.3),
            inactiveTrackColor: AppColors.navyLight(context),
            inactiveThumbColor: AppColors.textMuted(context),
          ),
        ],
      ),
    );
  }

  Widget _linkTile(String label, IconData icon, Color color,
      {bool danger = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyLight(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: text14(
                  fontWeight: FontWeight.w500,
                  color: danger ? AppColors.danger : AppColors.textPrimary(context),
                  context: context,
                )),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted(context), size: 18),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Policy Card — expandable widget for each policy
// ─────────────────────────────────────────────────
class _PolicyCard extends StatefulWidget {
  final String title;
  final String description;
  const _PolicyCard({required this.title, required this.description});

  @override
  State<_PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<_PolicyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navyMid(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded
                ? AppColors.accent.withOpacity(0.4)
                : AppColors.navyLight(context),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.policy_outlined,
                      color: AppColors.info, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                      context: context,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textMuted(context), size: 20),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: text13(
                  color: AppColors.textMuted(context),
                  context: context,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
