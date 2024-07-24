import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/assets_tree/assets_tree_view_controller.dart';
import '../features/home/home_view_controller.dart';
import '../support/enums/units_enum.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  static const String homeRoute = '/home';
  static const String assetsTreeRoute = 'assets-tree';

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: homeRoute,
        name: homeRoute,
        builder: (_, __) => const HomeViewController(),
        routes: [
          GoRoute(
            path: assetsTreeRoute,
            name: assetsTreeRoute,
            builder: (_, state) {
              final unit = state.extra as UnitsEnum;

              return AssetsTreeViewController(unit: unit);
            },
          ),
        ],
      ),
    ],
  );
}
