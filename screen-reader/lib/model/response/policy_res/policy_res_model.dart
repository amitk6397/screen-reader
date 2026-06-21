class PolicyResModel {
  PolicyResModel({required this.success, required this.data});

  final bool success;
  final List<PolicyItem> data;

  factory PolicyResModel.fromJson(Map<String, dynamic> json) {
    return PolicyResModel(
      success: json['success'] ?? false,
      data: json['data'] == null
          ? []
          : List<PolicyItem>.from(
              json['data'].map((x) => PolicyItem.fromJson(x)),
            ),
    );
  }
}

class PolicyItem {
  PolicyItem({
    required this.id,
    required this.title,
    required this.description,
    this.isActive = true,
    this.version,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final bool isActive;
  final String? version;
  final DateTime? createdAt;

  factory PolicyItem.fromJson(Map<String, dynamic> json) {
    return PolicyItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? true,
      version: json['version'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
