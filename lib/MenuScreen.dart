import 'package:flutter/material.dart';
import 'coffee_image.dart';
import 'favorites_screen.dart';
import 'menu_view_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuViewModel _viewModel = MenuViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    savedDrinks: _viewModel.drinks
                        .where((d) => _viewModel.favoriteNames.contains(d.name))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.drinks.isEmpty && _viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_viewModel.drinks.isEmpty && _viewModel.error != null) {
              return Center(child: Text('Error: ${_viewModel.error}'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _viewModel.drinks.length,
              itemBuilder: (context, index) {
                final d = _viewModel.drinks[index];
                final isFavorite = _viewModel.favoriteNames.contains(d.name);
                return Card(
                  child: ListTile(
                    leading: CoffeeImage(url: d.imageUrl),
                    title: Text(d.name),
                    subtitle: Text(
                      d.ingredients,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? colors.secondary : Colors.grey,
                      ),
                      onPressed: () => _viewModel.toggleFavorite(d.name),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
