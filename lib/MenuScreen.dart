import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'coffee_image.dart';
import 'drink.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Drink> drinks = [];

  @override
  void initState() {
    super.initState();
    fetchDrinks();
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
      );
    }

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SafeArea(child: body),
    );
  }
}