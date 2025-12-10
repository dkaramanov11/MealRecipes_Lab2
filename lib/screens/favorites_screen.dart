import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import '../widgets/meal_grid_item.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService().favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite recipes yet."))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final meal = favorites[index];
          return MealGridItem(
            meal: meal,
            onTap: () {
              // исто како кај MealsByCategory
            },
          );
        },
      ),
    );
  }
}
