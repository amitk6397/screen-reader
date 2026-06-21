// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import 'package:screen_reader/res/app_colors.dart';
import 'package:screen_reader/routes/app_pages.dart';
import 'package:screen_reader/routes/app_routes.dart';
import 'package:screen_reader/utils/textstyle.dart';
import 'package:screen_reader/view_model/global_controller/theme_controller.dart';

import 'package:screen_reader/views/after_login/account/profile_screen.dart';
import 'package:screen_reader/views/after_login/home_screen.dart';
import 'package:screen_reader/views/after_login/library_screen.dart';
import 'package:screen_reader/views/after_login/plater_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Register ThemeProvider
  Get.put(ThemeProvider());

  runApp(const MyApp());
}

/// ─────────────────────────────────────────────────────────
/// APP ROOT
/// ─────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeProvider>();

    return AnimatedBuilder(
      animation: themeProvider,
      builder: (_, __) {
        return GetMaterialApp(
          title: 'Screen Reader',
          debugShowCheckedModeBanner: false,

          /// THEMES
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeMode: themeProvider.themeMode,

          /// ROUTES
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// DARK THEME
/// ─────────────────────────────────────────────────────────
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F1724),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFC8A96E),
    surface: Color(0xFF1A2435),
  ),

  fontFamily: 'DMSans',
);

/// ─────────────────────────────────────────────────────────
/// LIGHT THEME
/// ─────────────────────────────────────────────────────────
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF4F6FB),

  colorScheme: const ColorScheme.light(
    primary: Color(0xFFC8A96E),
    surface: Color(0xFFFFFFFF),
  ),

  fontFamily: 'DMSans',
);

/// ─────────────────────────────────────────────────────────
/// MAIN BOTTOM NAVIGATION SHELL
/// ─────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LibraryScreen(),
    PlayerScreen(),
    ProfileScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),

    _NavItem(
      Icons.auto_stories_rounded,
      Icons.auto_stories_outlined,
      'Library',
    ),

    _NavItem(
      Icons.headphones_rounded,
      Icons.headphones_outlined,
      'Player',
    ),

    _NavItem(
      Icons.person_rounded,
      Icons.person_outline_rounded,
      'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,

        systemNavigationBarColor: AppColors.navyMid(context),

        systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
      ),

      child: Scaffold(
        backgroundColor: AppColors.navy(context),

        /// BODY
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),

          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,

          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },

          child: KeyedSubtree(
            key: ValueKey(_currentIndex),
            child: _screens[_currentIndex],
          ),
        ),

        /// BOTTOM NAV BAR
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.navyMid(context),

            border: Border(
              top: BorderSide(
                color: AppColors.navyLight(context),
                width: 1,
              ),
            ),

            boxShadow: isDark
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),

          child: SafeArea(
            child: SizedBox(
              height: 62,

              child: Row(
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final selected = i == _currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      onTap: () {
                        HapticFeedback.lightImpact();

                        setState(() {
                          _currentIndex = i;
                        });
                      },

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),

                            width: 44,
                            height: 36,

                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.accentDim
                                  : Colors.transparent,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Icon(
                              selected
                                  ? item.activeIcon
                                  : item.icon,

                              color: selected
                                  ? AppColors.accent
                                  : AppColors.textMuted(context),

                              size: 22,
                            ),
                          ),

                          const SizedBox(height: 3),

                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),

                            style: text10(
                              context: context,

                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,

                              color: selected
                                  ? AppColors.accent
                                  : AppColors.textMuted(context),
                            ),

                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// NAV ITEM MODEL
/// ─────────────────────────────────────────────────────────
class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;

  const _NavItem(
      this.activeIcon,
      this.icon,
      this.label,
      );
}