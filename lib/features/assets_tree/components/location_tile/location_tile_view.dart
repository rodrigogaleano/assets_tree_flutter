import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class LocationTileViewModelProtocol {
  String get title;
}

class LocationTileView extends StatelessWidget {
  final LocationTileViewModelProtocol viewModel;

  const LocationTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.lightBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.title,
              style: AppFonts.robotoRegular(16, AppColors.darkBlue),
            ),
          ),
        ],
      ),
    );
  }
}
