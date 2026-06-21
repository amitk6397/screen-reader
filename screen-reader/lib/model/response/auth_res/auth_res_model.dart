class OnboardingResModel {
  OnboardingResModel({required this.success, required this.data});

  final bool? success;
  final List<Onboarding> data;

  factory OnboardingResModel.fromJson(Map<String, dynamic> json) {
    return OnboardingResModel(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<Onboarding>.from(
              json["data"]!.map((x) => Onboarding.fromJson(x)),
            ),
    );
  }
}

class Onboarding {
  Onboarding({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,

    required this.isActive,
  });

  final int? id;
  final String? title;
  final String? description;
  final String? imageUrl;

  final bool? isActive;

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      imageUrl: json["image_url"],

      isActive: json["is_active"],
    );
  }
}
