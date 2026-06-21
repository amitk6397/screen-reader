import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class VoiceSettingsScreen extends StatefulWidget {
  const VoiceSettingsScreen({super.key});

  @override
  State<VoiceSettingsScreen> createState() => _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends State<VoiceSettingsScreen> {
  String _selectedVoice = 'Aria';
  double _pitch = 1.0;
  double _volume = 0.8;
  bool _enhanceAudio = true;
  bool _noiseCancellation = false;

  final List<Map<String, dynamic>> _voices = [
    {'name': 'Aria', 'type': 'Female • Warm', 'color': AppColors.coverPurple},
    {'name': 'James', 'type': 'Male • Deep', 'color': AppColors.coverBlue},
    {'name': 'Priya', 'type': 'Female • Clear', 'color': AppColors.coverTeal},
    {'name': 'Liam', 'type': 'Male • Neutral', 'color': AppColors.coverGreen},
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
                  Text('Voice Settings',
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
                    // Voice Selection
                    _sectionLabel(context, 'Select Voice'),
                    const SizedBox(height: 8),
                    ...List.generate(_voices.length, (i) {
                      final v = _voices[i];
                      final isSelected = _selectedVoice == v['name'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedVoice = v['name']),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent.withOpacity(0.08)
                                : AppColors.navyMid(context),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.navyLight(context),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: (v['color'] as Color).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.record_voice_over_rounded,
                                    color: v['color'] as Color, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(v['name'],
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.accent
                                              : AppColors.textPrimary(context),
                                        )),
                                    Text(v['type'],
                                        style: text11(
                                          color: AppColors.textMuted(context),
                                          context: context,
                                        )),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded,
                                    color: AppColors.accent, size: 20),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Pitch
                    _sectionLabel(context, 'Voice Pitch'),
                    const SizedBox(height: 8),
                    _sliderCard(
                      icon: Icons.graphic_eq_rounded,
                      color: AppColors.coverPurple,
                      value: _pitch,
                      min: 0.5,
                      max: 2.0,
                      label: _pitch.toStringAsFixed(1) + 'x',
                      onChanged: (v) => setState(() => _pitch = v),
                    ),

                    const SizedBox(height: 14),

                    // Volume
                    _sectionLabel(context, 'Volume'),
                    const SizedBox(height: 8),
                    _sliderCard(
                      icon: Icons.volume_up_rounded,
                      color: AppColors.coverBlue,
                      value: _volume,
                      min: 0.0,
                      max: 1.0,
                      label: ((_volume * 100).round()).toString() + '%',
                      onChanged: (v) => setState(() => _volume = v),
                    ),

                    const SizedBox(height: 20),

                    // Toggles
                    _sectionLabel(context, 'Audio Enhancements'),
                    const SizedBox(height: 8),
                    _toggleCard('Enhance Audio Quality', Icons.auto_awesome_rounded,
                        AppColors.coverTeal, _enhanceAudio,
                            (v) => setState(() => _enhanceAudio = v)),
                    const SizedBox(height: 10),
                    _toggleCard('Noise Cancellation', Icons.noise_control_off_rounded,
                        AppColors.coverGreen, _noiseCancellation,
                            (v) => setState(() => _noiseCancellation = v)),

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

  Widget _sliderCard({
    required IconData icon,
    required Color color,
    required double value,
    required double min,
    required double max,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navyLight(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.navyLight(context),
                thumbColor: AppColors.accent,
                overlayColor: AppColors.accent.withOpacity(0.1),
                trackHeight: 3,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          Text(label,
              style: text13(
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
                context: context,
              )),
        ],
      ),
    );
  }

  Widget _toggleCard(String label, IconData icon, Color color, bool value,
      ValueChanged<bool> onChanged) {
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: text14(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                  context: context,
                )),
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
