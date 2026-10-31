import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coffee_image.dart';
import 'drink.dart';
import 'favorites_screen.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Drink> drinks = [];
  Set<String> favoriteNames = {};
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const _favKey = 'favorite_drinks';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    fetchDrinks();
  }

  Future<void> _loadFavorites() async {
    final saved = await _prefs.getStringList(_favKey) ?? [];
    setState(() {
      favoriteNames = saved.toSet();
    });
  }

  Future<void> _toggleFavorite(String name) async {
    setState(() {
      if (favoriteNames.contains(name)) {
        favoriteNames.remove(name);
      } else {
        favoriteNames.add(name);
      }
    });
    await _prefs.setStringList(_favKey, favoriteNames.toList());
  }

  Future<void> fetchDrinks() async {
    try {
      final response = await Dio().get('https://api.sampleapis.com/coffee/hot');
      final List data = response.data as List;

      setState(() {
        drinks = data
            .map((e) => Drink.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget body;
    if (drinks.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          final d = drinks[index];
          final isFavorite = favoriteNames.contains(d.name);
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
                onPressed: () => _toggleFavorite(d.name),
              ),
            ),
          );
        },
      );
    }

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
                    savedDrinks: drinks
                        .where((d) => favoriteNames.contains(d.name))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }
}