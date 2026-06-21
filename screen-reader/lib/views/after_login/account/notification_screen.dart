import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _newReleases = true;
  bool _readingReminder = true;
  bool _weeklyDigest = false;
  bool _promotions = false;
  bool _streakAlert = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.navyMid(context),
          ),
        ),
        child: child!,
      ),
    );
    if (t != null) setState(() => _reminderTime = t);
  }

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
                  Text('Notifications',
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
                    // Master Toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _pushEnabled
                            ? AppColors.warning.withOpacity(0.08)
                            : AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _pushEnabled
                              ? AppColors.warning.withOpacity(0.4)
                              : AppColors.navyLight(context),
                          width: _pushEnabled ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_active_rounded,
                                color: AppColors.warning, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Push Notifications',
                                    style: text15(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary(context),
                                      context: context,
                                    )),
                                const SizedBox(height: 2),
                                Text('Enable all notifications',
                                    style: text12(
                                      color: AppColors.textMuted(context),
                                      context: context,
                                    )),
                              ],
                            ),
                          ),
                          Switch(
                            value: _pushEnabled,
                            onChanged: (v) => setState(() => _pushEnabled = v),
                            activeColor: AppColors.warning,
                            activeTrackColor: AppColors.warning.withOpacity(0.3),
                            inactiveTrackColor: AppColors.navyLight(context),
                            inactiveThumbColor: AppColors.textMuted(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Activity'),
                    const SizedBox(height: 8),

                    _notifTile(
                      'New Releases',
                      'When authors you follow release new books',
                      Icons.new_releases_outlined,
                      AppColors.accent,
                      _newReleases,
                          (v) => setState(() => _newReleases = v),
                    ),
                    const SizedBox(height: 10),
                    _notifTile(
                      'Streak Alert',
                      'Reminder to keep your reading streak',
                      Icons.local_fire_department_outlined,
                      AppColors.coverGreen,
                      _streakAlert,
                          (v) => setState(() => _streakAlert = v),
                    ),
                    const SizedBox(height: 10),
                    _notifTile(
                      'Weekly Digest',
                      'Weekly summary of your progress',
                      Icons.summarize_outlined,
                      AppColors.coverBlue,
                      _weeklyDigest,
                          (v) => setState(() => _weeklyDigest = v),
                    ),
                    const SizedBox(height: 10),
                    _notifTile(
                      'Promotions',
                      'Special deals and discounts',
                      Icons.local_offer_outlined,
                      AppColors.coverTeal,
                      _promotions,
                          (v) => setState(() => _promotions = v),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Reading Reminder'),
                    const SizedBox(height: 8),

                    _notifTile(
                      'Daily Reminder',
                      'Remind me to read every day',
                      Icons.alarm_rounded,
                      AppColors.coverPurple,
                      _readingReminder,
                          (v) => setState(() => _readingReminder = v),
                    ),

                    if (_readingReminder) ...[
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.navyMid(context),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.navyLight(context)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  color: AppColors.textMuted(context), size: 18),
                              const SizedBox(width: 12),
                              Text('Reminder Time',
                                  style: text14(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary(context),
                                    context: context,
                                  )),
                              const Spacer(),
                              Text(
                                _reminderTime.format(context),
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded,
                                  color: AppColors.textMuted(context), size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],

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

  Widget _notifTile(String title, String subtitle, IconData icon, Color color,
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
            value: value && _pushEnabled,
            onChanged: _pushEnabled ? onChanged : null,
            activeColor: color,
            activeTrackColor: color.withOpacity(0.3),
            inactiveTrackColor: AppColors.navyLight(context),
            inactiveThumbColor: AppColors.textMuted(context),
          ),
        ],
      ),
    );
  }
}
