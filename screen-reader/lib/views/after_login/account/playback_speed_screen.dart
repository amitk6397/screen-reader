import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class PlaybackSpeedScreen extends StatefulWidget {
  const PlaybackSpeedScreen({super.key});

  @override
  State<PlaybackSpeedScreen> createState() => _PlaybackSpeedScreenState();
}

class _PlaybackSpeedScreenState extends State<PlaybackSpeedScreen> {
  double _selectedSpeed = 1.0;
  bool _rememberPerBook = true;
  bool _skipSilences = false;

  final List<double> _presets = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];

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
                  Text('Playback Speed',
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
                    // Speed Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.3), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${_selectedSpeed}x',
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedSpeed == 1.0
                                ? 'Normal Speed'
                                : _selectedSpeed < 1.0
                                ? 'Slower than Normal'
                                : 'Faster than Normal',
                            style: text13(
                              color: AppColors.textMuted(context),
                              context: context,
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Fine-tune slider
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.accent,
                                inactiveTrackColor: AppColors.navyLight(context),
                                thumbColor: AppColors.accent,
                                overlayColor: AppColors.accent.withOpacity(0.1),
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                              ),
                              child: Slider(
                                value: _selectedSpeed,
                                min: 0.5,
                                max: 3.0,
                                divisions: 50,
                                onChanged: (v) => setState(() =>
                                _selectedSpeed = double.parse(v.toStringAsFixed(2))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Preset Chips
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 10),
                      child: Text('PRESETS',
                          style: text12(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted(context),
                              context: context)),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presets.map((speed) {
                        final isSelected = _selectedSpeed == speed;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSpeed = speed),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent.withOpacity(0.15)
                                  : AppColors.navyMid(context),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.navyLight(context),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              '${speed}x',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textMuted(context),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
                      'Remember Per Book',
                      'Save different speeds for each book',
                      Icons.menu_book_rounded,
                      AppColors.coverBlue,
                      _rememberPerBook,
                          (v) => setState(() => _rememberPerBook = v),
                    ),
                    const SizedBox(height: 10),
                    _toggleTile(
                      'Skip Silences',
                      'Automatically skip silent pauses',
                      Icons.fast_forward_rounded,
                      AppColors.coverGreen,
                      _skipSilences,
                          (v) => setState(() => _skipSilences = v),
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
            activeColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withOpacity(0.3),
            inactiveTrackColor: AppColors.navyLight(context),
            inactiveThumbColor: AppColors.textMuted(context),
          ),
        ],
      ),
    );
  }
}
