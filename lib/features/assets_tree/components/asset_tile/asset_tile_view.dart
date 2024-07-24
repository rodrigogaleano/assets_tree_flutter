import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class AssetTileViewModelProtocol {
  String get title;
  List<AssetTileViewModelProtocol> get subAssetsViewModels;
}

class AssetTileView extends StatelessWidget {
  final AssetTileViewModelProtocol viewModel;

  const AssetTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.subAssetsViewModels.isEmpty) {
      return ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.widgets_outlined,
              color: AppColors.lightBlue,
            ),
            const SizedBox(width: 8),
            Text(
              viewModel.title,
              style: AppFonts.robotoRegular(14, AppColors.darkBlue),
            ),
          ],
        ),
      );
    }

    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 16),
      title: ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.widgets_outlined,
              color: AppColors.lightBlue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.title,
                style: AppFonts.robotoRegular(14, AppColors.darkBlue),
              ),
            ),
          ],
        ),
      ),
      children: viewModel.subAssetsViewModels.map((subAssetViewModel) {
        return AssetTileView(viewModel: subAssetViewModel);
      }).toList(),
    );
  }
}
