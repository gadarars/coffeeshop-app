/*
| | SharedPreferencesAsync | SharedPreferencesWithCache |
| getStringList return type | Future<List<String>?> (must await) | List<String>? (already in memory) |
| Reading a key not in allowList | returns null | throws an error |
| When it reads from disk | every read | once at create(), then from memory |
*/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    final cached = await DBHelper.getCachedDrinks();
    if (drinks.isEmpty && cached.isNotEmpty) {
      drinks = cached;
      notifyListeners();
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
      await DBHelper.cacheDrinks(fetchedDrinks);
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
