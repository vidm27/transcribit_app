import 'package:go_router/go_router.dart';
import 'package:transcribit_app/features/features.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MenuScreen(),
    ),
  ],
);
