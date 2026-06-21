import 'package:get/get.dart';
import 'package:screen_reader/views/after_login/book_reader_screen.dart';
import 'package:screen_reader/views/after_login/home_screen.dart';
import 'package:screen_reader/views/before_login/forgot_password_screen.dart';
import 'package:screen_reader/views/before_login/login_screen.dart';
import 'package:screen_reader/views/before_login/onboarding_screen.dart';
import 'package:screen_reader/views/before_login/register_screen.dart';
import 'package:screen_reader/views/before_login/splash_screen.dart';

import '../main.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // auth page
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    // after auth pages
    GetPage(name: AppRoutes.mySheel, page: () => const MainShell()),

    // GetPage(
    //   name: AppRoutes.bookReader,
    //   page: () => const BookReaderScreen(book: book),
    // ),
  ];
}
