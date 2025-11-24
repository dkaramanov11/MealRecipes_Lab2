import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';


class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$_baseUrl/categories.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data['categories'] ?? [];
      return categoriesJson
          .map((jsonItem) => Category.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Error loading categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse('$_baseUrl/filter.php?c=$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'] ?? [];
      return mealsJson
          .map((jsonItem) => Meal.fromFilterJson(jsonItem))
          .toList();
    } else {
      throw Exception('Error loading meals for the categories $category');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('$_baseUrl/search.php?s=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List? mealsJson = data['meals'];

      if (mealsJson == null) {
        return [];
      }

      return mealsJson
          .map((jsonItem) => Meal.fromSearchJson(jsonItem))
          .toList();
    } else {
      throw Exception('Error searching meals');
    }
  }

  Future<MealDetail> getMealDetail(String id) async {
    final url = Uri.parse('$_baseUrl/lookup.php?i=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'] ?? [];

      if (mealsJson.isEmpty) {
        throw Exception('Error finding recipe with $id');
      }

      return MealDetail.fromJson(mealsJson[0]);
    } else {
      throw Exception('Error loading recipe');
    }
  }

  Future<MealDetail> getRandomMeal() async {
    final url = Uri.parse('$_baseUrl/random.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'] ?? [];

      if (mealsJson.isEmpty) {
        throw Exception('Error finding random recipe');
      }

      return MealDetail.fromJson(mealsJson[0]);
    } else {
      throw Exception('Error loading random recipe');
    }
  }

}
