import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemes {
  static final ThemeData theme = ThemeData(
    // MARK: - Scaffold

    scaffoldBackgroundColor: AppColors.white,

    // MARK: - AppBar

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBlue,
      iconTheme: IconThemeData(color: AppColors.white),
    ),

    // - MARK - Expansion Tile

    dividerColor: AppColors.transparent,
  );
}
