class Category {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      thumbnailUrl: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }
}
