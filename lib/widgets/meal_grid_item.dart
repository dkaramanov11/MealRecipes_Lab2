import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorites_service.dart';

class MealGridItem extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealGridItem({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<MealGridItem> createState() => _MealGridItemState();
}

class _MealGridItemState extends State<MealGridItem> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = FavoritesService().isFavorite(widget.meal);
  }

  void _toggleFavorite() {
    setState(() {
      FavoritesService().toggleFavorite(widget.meal);
      _isFavorite = FavoritesService().isFavorite(widget.meal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.meal.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    widget.meal.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),


        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _toggleFavorite,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
