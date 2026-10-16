import 'package:flutter/material.dart';


const List<Map<String, String>> menuItems = [
  {'name': 'Espresso', 'category': 'Hot coffee'},
  {'name': 'Latte', 'category': 'Hot coffee'},
  {'name': 'Cappuccino', 'category': 'Hot coffee'},
  {'name': 'Mocha', 'category': 'Hot coffee'},
  {'name': 'Iced Coffee', 'category': 'Cold coffee'},
  {'name': 'Croissant', 'category': 'Bakery'},
];

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      appBar: AppBar(
        title: const Text('Our Menu'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.local_cafe),
                title: Text(item['name']!),
                subtitle: Text(item['category']!),
              ),
            );
          },
        ),
      ),
    );
  }
}