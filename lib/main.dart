import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

import 'localization/localize.dart';
import 'router/app_router.dart';
import 'support/style/app_themes.dart';

void main() {
  runApp(
    MaterialApp.router(
      theme: AppThemes.theme,
      routerConfig: AppRouter.router,
      supportedLocales: Localization.supportedLocales,
      localizationsDelegates: Localization.localizationsDelegates,
      onGenerateTitle: (context) => Localize.instance.of(context).appTitle,
    ),
  );
}
