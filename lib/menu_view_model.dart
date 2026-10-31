/*
| Feature | SharedPreferencesAsync | SharedPreferencesWithCache |
| :--- | :--- | :--- |
| **Returns list** | It returns a Future that you must await because it reads from the disk. | It returns the list immediately because it is already loaded in memory. |
| **Missing key in allowList** | It returns null or the default value. | It throws an error if you try to read a key not in the allowList. |
| **Disk read timing** | It reads from the disk every time you call a read method. | It reads from the disk only once when create() is called, then uses memory. |
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';
import 'drink.dart';

class MenuViewModel extends ChangeNotifier {
  List<Drink> drinks = [];
  Set<String> favoriteNames = {};
  bool isLoading = false;
  String? error;

  SharedPreferencesWithCache? _prefs;
  static const _favKey = 'favorite_drinks';

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    await loadFavorites();
    await loadCachedDrinks();
    await fetchDrinks();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: {_favKey}),
    );
    final saved = _prefs!.getStringList(_favKey) ?? [];
    favoriteNames = saved.toSet();
    notifyListeners();
  }

  Future<void> loadCachedDrinks() async {
    if (kIsWeb) return;
    try {
      final cached = await DBHelper.getCachedDrinks();
      if (drinks.isEmpty && cached.isNotEmpty) {
        drinks = cached;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load cached drinks: $e');
    }
  }

  Future<void> fetchDrinks() async {
    try {
      final response = await Dio().get('https://api.sampleapis.com/coffee/hot');
      final List data = response.data as List;

      final fetchedDrinks = data
          .map((e) => Drink.fromJson(e as Map<String, dynamic>))
          .toList();

      drinks = fetchedDrinks;
      error = null;
      notifyListeners();
      if (!kIsWeb) {
        await DBHelper.cacheDrinks(fetchedDrinks);
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  void toggleFavorite(String name) {
    if (favoriteNames.contains(name)) {
      favoriteNames.remove(name);
    } else {
      favoriteNames.add(name);
    }
    _prefs?.setStringList(_favKey, favoriteNames.toList());
    notifyListeners();
  }
}
