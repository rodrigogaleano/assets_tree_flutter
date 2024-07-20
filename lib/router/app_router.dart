import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_view_controller.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static const String homeRoute = '/home';

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: homeRoute,
        name: homeRoute,
        builder: (_, __) => const HomeViewController(),
      ),
    ],
  );
}
