import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class ScreenReaderScreen extends StatefulWidget {
  const ScreenReaderScreen({super.key});

  @override
  State<ScreenReaderScreen> createState() => _ScreenReaderScreenState();
}

class _ScreenReaderScreenState extends State<ScreenReaderScreen> {
  bool _screenReader = false;
  bool _announceChapters = true;
  bool _hapticFeedback = true;
  bool _highContrast = false;
  String _navigationMode = 'Swipe';

  final List<String> _navModes = ['Swipe', 'Tap', 'Buttons'];

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
                  Text('Screen Reader',
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
                    // Main Toggle Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: AppColors.info.withOpacity(0.3), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.accessibility_new_rounded,
                                color: AppColors.info, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Screen Reader',
                                    style: text15(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary(context),
                                      context: context,
                                    )),
                                const SizedBox(height: 2),
                                Text('Read UI elements aloud',
                                    style: text12(
                                      color: AppColors.textMuted(context),
                                      context: context,
                                    )),
                              ],
                            ),
                          ),
                          Switch(
                            value: _screenReader,
                            onChanged: (v) => setState(() => _screenReader = v),
                            activeColor: AppColors.info,
                            activeTrackColor: AppColors.info.withOpacity(0.3),
                            inactiveTrackColor: AppColors.navyLight(context),
                            inactiveThumbColor: AppColors.textMuted(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Reader Settings'),
                    const SizedBox(height: 8),

                    _toggleTile(
                      'Announce Chapters',
                      'Read chapter titles when they begin',
                      Icons.auto_stories_rounded,
                      AppColors.coverTeal,
                      _announceChapters,
                          (v) => setState(() => _announceChapters = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Haptic Feedback',
                      'Vibrate on interactions',
                      Icons.vibration_rounded,
                      AppColors.coverGreen,
                      _hapticFeedback,
                          (v) => setState(() => _hapticFeedback = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'High Contrast Mode',
                      'Increase visual contrast',
                      Icons.contrast_rounded,
                      AppColors.coverPurple,
                      _highContrast,
                          (v) => setState(() => _highContrast = v),
                    ),

                    const SizedBox(height: 20),

                    _sectionLabel(context, 'Navigation Mode'),
                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.navyLight(context)),
                      ),
                      child: Column(
                        children: _navModes.asMap().entries.map((e) {
                          final i = e.key;
                          final mode = e.value;
                          final isSelected = _navigationMode == mode;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _navigationMode = mode),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 13),
                                  child: Row(
                                    children: [
                                      Text(mode,
                                          style: text14(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? AppColors.info
                                                : AppColors.textPrimary(context),
                                            context: context,
                                          )),
                                      const Spacer(),
                                      if (isSelected)
                                        const Icon(Icons.check_rounded,
                                            color: AppColors.info, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              if (i < _navModes.length - 1)
                                Divider(
                                    height: 1, color: AppColors.navyLight(context)),
                            ],
                          );
                        }).toList(),
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
}
