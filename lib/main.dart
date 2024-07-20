import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

import 'localization/localize.dart';
import 'router/app_router.dart';
import 'support/service_locator/service_locator.dart';
import 'support/style/app_themes.dart';

void main() {
  initializeDependencies();

  runApp(
    MaterialApp.router(
      theme: AppThemes.theme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      supportedLocales: Localization.supportedLocales,
      localizationsDelegates: Localization.localizationsDelegates,
      onGenerateTitle: (context) => Localize.instance.of(context).appTitle,
    ),
  );
}
