import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

import '../../localization/localize.dart';
import '../../support/service_locator/service_locator.dart';
import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';
import 'components/asset_tile/asset_tile_view.dart';
import 'components/asset_tree_app_bar.dart';
import 'components/filter_option/filter_option_view.dart';
import 'components/location_tile/location_tile_view.dart';

abstract class AssetsTreeViewModelProtocol with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;
  TextEditingController get searchBarController;
  List<LocationTileViewModelProtocol> get locationsViewModels;
  List<AssetTileViewModelProtocol> get unlinkedAssetsViewModels;
  List<FilterOptionViewModelProtocol> get filterOptionsViewModels;
}

class AssetsTreeView extends StatelessWidget {
  final AssetsTreeViewModelProtocol viewModel;

  const AssetsTreeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = ServiceLocator.get<LocalizeProtocol>().l10n;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return CustomScrollView(
              slivers: [
                AssetTreeAppBar(
                  l10n: l10n,
                  searchBarController: viewModel.searchBarController,
                  filterOptionsViewModels: viewModel.filterOptionsViewModels,
                ),
                ..._bodySlivers(l10n),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _bodySlivers(Localization l10n) {
    if (viewModel.isLoading) {
      return [
        const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.darkBlue),
          ),
        ),
      ];
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Text(
              viewModel.errorMessage,
              style: AppFonts.robotoRegular(16, AppColors.darkBlue),
            ),
          ),
        ),
      ];
    }

    if (viewModel.locationsViewModels.isEmpty && viewModel.unlinkedAssetsViewModels.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Text(
              l10n.assetsNoResultsLabel,
              style: AppFonts.robotoRegular(16, AppColors.darkBlue),
            ),
          ),
        ),
      ];
    }

    return [
      SliverList.builder(
        itemCount: viewModel.locationsViewModels.length,
        itemBuilder: (_, index) {
          return LocationTileView(
            viewModel: viewModel.locationsViewModels[index],
          );
        },
      ),
      SliverList.builder(
        itemCount: viewModel.unlinkedAssetsViewModels.length,
        itemBuilder: (_, index) {
          return AssetTileView(viewModel: viewModel.unlinkedAssetsViewModels[index]);
        },
      ),
    ];
  }
}
