class ProfileResModel {
  ProfileResModel({required this.success, required this.message, this.data});

  final bool success;
  final String message;
  final ProfileData? data;

  factory ProfileResModel.fromJson(Map<String, dynamic> json) {
    return ProfileResModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    this.isActive = true,
    this.profileImage,
  });

  final int id;
  final String name;
  final String email;
  final bool isActive;
  final String? profileImage;

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}
