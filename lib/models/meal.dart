class Meal {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String? category;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.category,
  });

  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnailUrl: json['strMealThumb'] ?? '',
    );
  }

  factory Meal.fromSearchJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnailUrl: json['strMealThumb'] ?? '',
      category: json['strCategory'],
    );
  }
}
