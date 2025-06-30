import 'package:go_router/go_router.dart';
import 'package:expenses_app/presentation/screens/overview/overview_screen.dart';
import 'package:expenses_app/presentation/screens/categories/category_management_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OverviewScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoryManagementScreen(),
    ),
  ],
);
