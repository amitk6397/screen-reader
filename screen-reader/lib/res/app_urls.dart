class AppUrls {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String userBase = '$baseUrl/user';

  // ── Auth ──────────────────────────────────────────────
  static const String onboardingData = '$userBase/onboarding';
  static const String register = '$userBase/register';
  static const String login = '$userBase/login';
  static const String forgotPassword = '$userBase/forgot-password';
  static const String confirmPassword = '$userBase/confirm-password';

  // ── Books ─────────────────────────────────────────────
  static const String books = '$userBase/books';
  static const String weekBooks = '$userBase/books/week';

  // ── Policy ────────────────────────────────────────────
  static const String policy = '$userBase/policy';

  // ── Profile (requires Bearer token) ──────────────────
  static const String profile = '$userBase/profile';
  static const String uploadProfileImage = '$userBase/profile/upload-image';
}
