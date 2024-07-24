import 'package:flutter/material.dart';

import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';
import 'components/asset_tile/asset_tile_view.dart';
import 'components/location_tile/location_tile_view.dart';

abstract class AssetsTreeViewModelProtocol with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;

  List<AssetTileViewModelProtocol> get aloneAssetsViewModels;
  List<LocationTileViewModelProtocol> get locationsViewModels;
}

class AssetsTreeView extends StatelessWidget {
  final AssetsTreeViewModelProtocol viewModel;

  const AssetsTreeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    'Assets',
                    style: AppFonts.robotoBold(24, AppColors.white),
                  ),
                ),
                ..._bodySlivers,
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> get _bodySlivers {
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
        itemCount: viewModel.aloneAssetsViewModels.length,
        itemBuilder: (_, index) {
          return AssetTileView(viewModel: viewModel.aloneAssetsViewModels[index]);
        },
      ),
    ];
  }
}
