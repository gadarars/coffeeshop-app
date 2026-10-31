import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'MenuScreen.dart';
import 'sign_up_screen.dart';


void main() {
  runApp(const CoffeeShopApp());
}


class CoffeeShopApp extends StatefulWidget {
  const CoffeeShopApp({super.key});

  @override
  State<CoffeeShopApp> createState() => _CoffeeShopAppState();
}

class _CoffeeShopAppState extends State<CoffeeShopApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }


  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => StartScreen(onToggleTheme: _toggleTheme),
        routes: [
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: 'menu',
            builder: (context, state) => const MenuScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6F4E37); // coffee brown

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: seed),
      darkTheme: ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: colors.onPrimary,
                child: Icon(Icons.local_cafe, size: 44, color: colors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Coffee Shop',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Freshly brewed, just for you',
                style: TextStyle(color: colors.onPrimary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                child: const Text('Get Started'),
              ),
              TextButton(
                onPressed: onToggleTheme,
                child: Text(
                  'Toggle theme',
                  style: TextStyle(color: colors.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}