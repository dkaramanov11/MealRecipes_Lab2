import '../models/meal.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final List<Meal> _favorites = [];

  List<Meal> get favorites => _favorites;

  bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
  }
}
