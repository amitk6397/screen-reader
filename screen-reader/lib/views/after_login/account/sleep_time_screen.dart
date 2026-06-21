import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class SleepTimerScreen extends StatefulWidget {
  const SleepTimerScreen({super.key});

  @override
  State<SleepTimerScreen> createState() => _SleepTimerScreenState();
}

class _SleepTimerScreenState extends State<SleepTimerScreen> {
  int? _selectedMinutes = 30;
  bool _fadeOut = true;
  bool _endOfChapter = false;

  final List<Map<String, dynamic>> _presets = [
    {'label': '5 min', 'minutes': 5},
    {'label': '10 min', 'minutes': 10},
    {'label': '15 min', 'minutes': 15},
    {'label': '20 min', 'minutes': 20},
    {'label': '30 min', 'minutes': 30},
    {'label': '45 min', 'minutes': 45},
    {'label': '1 hour', 'minutes': 60},
    {'label': '90 min', 'minutes': 90},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  Text('Sleep Timer',
                      style: text24(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                          context: context)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timer Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.coverPurple.withOpacity(0.3), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.coverPurple.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.coverPurple.withOpacity(0.4),
                                  width: 2),
                            ),
                            child: const Icon(Icons.nightlight_round,
                                color: AppColors.coverPurple, size: 36),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _selectedMinutes == null
                                ? 'Off'
                                : _selectedMinutes! >= 60
                                ? '${_selectedMinutes! ~/ 60}h ${_selectedMinutes! % 60 == 0 ? '' : '${_selectedMinutes! % 60}m'}'
                                : '$_selectedMinutes min',
                            style: text40(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary(context),
                              context: context,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedMinutes == null
                                ? 'Sleep timer is off'
                                : 'Playback will stop after this time',
                            style: text12(
                              color: AppColors.textMuted(context),
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Presets
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 10),
                      child: Text('DURATION',
                          style: text12(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted(context),
                              context: context)),
                    ),

                    // Off option
                    GestureDetector(
                      onTap: () => setState(() => _selectedMinutes = null),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: _selectedMinutes == null
                              ? AppColors.danger.withOpacity(0.1)
                              : AppColors.navyMid(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedMinutes == null
                                ? AppColors.danger
                                : AppColors.navyLight(context),
                            width: _selectedMinutes == null ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Turn Off',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _selectedMinutes == null
                                  ? AppColors.danger
                                  : AppColors.textMuted(context),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: _presets.length,
                      itemBuilder: (_, i) {
                        final preset = _presets[i];
                        final isSelected = _selectedMinutes == preset['minutes'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedMinutes = preset['minutes']),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.coverPurple.withOpacity(0.15)
                                  : AppColors.navyMid(context),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.coverPurple
                                    : AppColors.navyLight(context),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                preset['label'],
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.coverPurple
                                      : AppColors.textMuted(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Options
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 10),
                      child: Text('OPTIONS',
                          style: text12(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted(context),
                              context: context)),
                    ),
                    _toggleTile(
                      'Fade Out Audio',
                      'Gradually reduce volume before stopping',
                      Icons.volume_down_rounded,
                      AppColors.coverTeal,
                      _fadeOut,
                          (v) => setState(() => _fadeOut = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Stop at End of Chapter',
                      'Finish current chapter before stopping',
                      Icons.auto_stories_rounded,
                      AppColors.coverGreen,
                      _endOfChapter,
                          (v) => setState(() => _endOfChapter = v),
                    ),

                    const SizedBox(height: 24),

                    // Start Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coverPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          _selectedMinutes == null ? 'Timer Off' : 'Start Timer',
                          style: text15(
                            fontWeight: FontWeight.w700,
                            context: context,
                          ),
                        ),
                      ),
                    ),
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
            activeColor: AppColors.coverPurple,
            activeTrackColor: AppColors.coverPurple.withOpacity(0.3),
            inactiveTrackColor: AppColors.navyLight(context),
            inactiveThumbColor: AppColors.textMuted(context),
          ),
        ],
      ),
    );
  }
}
