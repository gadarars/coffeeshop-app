import 'package:flutter/material.dart';
import 'MenuScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_cafe, size: 80),
              const SizedBox(height: 16),
              Text(
                'Welcome, $name!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text('Your next coffee is waiting'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                },
                child: const Text('Browse Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}