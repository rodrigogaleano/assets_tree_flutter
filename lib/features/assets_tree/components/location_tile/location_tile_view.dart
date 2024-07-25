import 'package:flutter/material.dart';

import '../../../../support/style/app_assets.dart';
import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';
import '../asset_tile/asset_tile_view.dart';

abstract class LocationTileViewModelProtocol {
  String get title;
  bool get isExpansionLocked;
  List<AssetTileViewModelProtocol> get assetsViewModels;
  List<LocationTileViewModelProtocol> get subLocationsViewModels;
}

class LocationTileView extends StatelessWidget {
  final LocationTileViewModelProtocol viewModel;

  const LocationTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.assetsViewModels.isEmpty && viewModel.subLocationsViewModels.isEmpty) {
      return ListTile(title: _tileTitle);
    }

    return ExpansionTile(
      initiallyExpanded: viewModel.isExpansionLocked,
      childrenPadding: const EdgeInsets.only(left: 16),
      title: _tileTitle,
      children: [
        ...viewModel.subLocationsViewModels.map((subLocationViewModel) {
          return LocationTileView(viewModel: subLocationViewModel);
        }),
        ...viewModel.assetsViewModels.map((assetViewModel) {
          return AssetTileView(viewModel: assetViewModel);
        }),
      ],
    );
  }

  Widget get _tileTitle {
    return Row(
      children: [
        Image.asset(AppAssets.icLocation),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            viewModel.title,
            style: AppFonts.robotoRegular(16, AppColors.darkBlue),
          ),
        ),
      ],
    );
  }
}
