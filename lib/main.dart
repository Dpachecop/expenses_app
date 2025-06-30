import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app/config/di/service_locator.dart';
import 'package:expenses_app/config/router/app_router.dart';
import 'package:expenses_app/config/theme/app_theme.dart';
import 'package:expenses_app/presentation/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(false),
      darkTheme: AppTheme().getTheme(true),
      themeMode: themeProvider.themeMode,
    );
  }
}
