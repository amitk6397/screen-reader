class BookResModel {
  BookResModel({required this.success, required this.data});

  final bool success;
  final List<BookItem> data;

  factory BookResModel.fromJson(Map<String, dynamic> json) {
    return BookResModel(
      success: json['success'] ?? false,
      data: json['data'] == null
          ? []
          : List<BookItem>.from(
              json['data'].map((x) => BookItem.fromJson(x)),
            ),
    );
  }
}

class BookItem {
  BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.category,
    this.language,
    required this.pdfUrl,
    required this.imageUrl,
    this.isActive = true,
    this.isWeek = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final String? category;
  final String? language;
  final String pdfUrl;
  final String imageUrl;
  final bool isActive;
  final bool isWeek;
  final DateTime? createdAt;

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      language: json['language'],
      pdfUrl: json['pdf_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? true,
      isWeek: json['isWeek'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
