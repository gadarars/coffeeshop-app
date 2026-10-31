import 'package:flutter/material.dart';
import 'coffee_image.dart';
import 'drink.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Drink> savedDrinks;

  const FavoritesScreen({super.key, required this.savedDrinks});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SafeArea(
        child: savedDrinks.isEmpty
            ? const Center(child: Text('No favorites added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: savedDrinks.length,
                itemBuilder: (context, index) {
                  final d = savedDrinks[index];
                  return Card(
                    child: ListTile(
                      leading: CoffeeImage(url: d.imageUrl),
                      title: Text(d.name),
                      subtitle: Text(
                        d.ingredients,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
