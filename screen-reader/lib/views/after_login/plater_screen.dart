import 'package:flutter/material.dart';

import '../../model/book_model.dart';
import '../../res/app_colors.dart';
import 'package:screen_reader/utils/textstyle.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  double _progress = 0.38;
  int _selectedSpeed = 2; // 1.25x

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<String> _speeds = ['0.75×', '1×', '1.25×', '1.5×', '2×'];

  // Sample book (replace with actual data passing later)
  final BookModel _book = sampleBooks[0];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(double ratio, int totalSec) {
    final seconds = (ratio * totalSec).toInt();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const totalSec = 2890;

    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textPrimary(context),
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'NOW PLAYING',
                    style: text14(
                      color: AppColors.textMuted(context),
                      fontWeight: FontWeight.w500,
                      context: context,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textPrimary(context),
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Album Art with Pulse Effect
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Transform.scale(
                      scale: _isPlaying ? _pulseAnim.value * 1.12 : 1.0,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _book.coverColor.withOpacity(0.06),
                        ),
                      ),
                    ),
                    // Inner glow
                    Transform.scale(
                      scale: _isPlaying ? _pulseAnim.value : 1.0,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _book.coverColor.withOpacity(0.12),
                        ),
                      ),
                    ),
                    // Main Cover
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.navyLight(context),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.headphones_rounded,
                            color: AppColors.accent,
                            size: 68,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 4,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Book Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _book.currentChapter,
                          style: text14(
                            color: AppColors.textMuted(context),
                            context: context,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _book.title,
                          style: text24(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(context),
                            context: context,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _book.author,
                          style: text16(
                            color: AppColors.textMuted(context),
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentDim,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Progress Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                      activeTrackColor: AppColors.accent,
                      inactiveTrackColor: AppColors.navyLight(context),
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: _progress,
                      onChanged: (value) => setState(() => _progress = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(_progress, totalSec),
                          style: text13(
                            color: AppColors.textMuted(context),
                            context: context,
                          ),
                        ),
                        Text(
                          _formatTime(1.0, totalSec),
                          style: text13(
                            color: AppColors.textMuted(context),
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Playback Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ctrlBtn(context, Icons.replay_10_rounded),
                  _ctrlBtn(context, Icons.skip_previous_rounded),
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 36,
                      ),
                    ),
                  ),
                  _ctrlBtn(context, Icons.skip_next_rounded),
                  _ctrlBtn(context, Icons.forward_10_rounded),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Speed Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_speeds.length, (i) {
                  final isSelected = i == _selectedSpeed;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSpeed = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accentDim
                            : AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.navyLight(context),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _speeds[i],
                        style: text14(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textMuted(context),
                          context: context,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _ctrlBtn(BuildContext context, IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.navyMid(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.navyLight(context), width: 1),
      ),
      child: Icon(icon, color: AppColors.textMuted(context), size: 24),
    );
  }
}
