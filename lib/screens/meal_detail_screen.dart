import 'package:flutter/material.dart';

import '../models/meal_detail.dart';
import '../services/meal_api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String? mealTitle;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    this.mealTitle,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _apiService = MealApiService();

  bool _isLoading = true;
  String? _errorMessage;
  MealDetail? _mealDetail;

  @override
  void initState() {
    super.initState();
    _fetchMealDetail();
  }

  Future<void> _fetchMealDetail() async {
    try {
      final detail = await _apiService.getMealDetail(widget.mealId);
      setState(() {
        _mealDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mealTitle ?? 'Meal detail';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text('Error: $_errorMessage'))
          : _mealDetail == null
          ? const Center(child: Text('No data for this meal'))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final meal = _mealDetail!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                meal.thumbnailUrl,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            meal.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),
          const Divider(),

          const SizedBox(height: 8),
          Text(
            'Ingredients',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: meal.ingredients.map((ing) {
              final text = '${ing.name} - ${ing.measure}'.trim();
              return Chip(
                label: Text(text),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            'Instructions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meal.instructions,
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          if (meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'YouTube link',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              meal.youtubeUrl!,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ],
      ),
    );
  }

}
