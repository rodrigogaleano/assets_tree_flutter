import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class LocationTileViewModelProtocol {
  String get title;
  List<String> get assetsTitles;
}

class LocationTileView extends StatelessWidget {
  final LocationTileViewModelProtocol viewModel;

  const LocationTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.assetsTitles.isEmpty) {
      return ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.lightBlue,
            ),
            const SizedBox(width: 8),
            Text(
              viewModel.title,
              style: AppFonts.robotoRegular(16, AppColors.darkBlue),
            ),
          ],
        ),
      );
    }

    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 16),
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
      children: viewModel.assetsTitles.map((assetTitle) {
        return ListTile(
          title: Row(
            children: [
              const Icon(
                Icons.widgets_outlined,
                color: AppColors.lightBlue,
              ),
              const SizedBox(width: 8),
              Text(
                assetTitle,
                style: AppFonts.robotoRegular(14, AppColors.darkBlue),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
