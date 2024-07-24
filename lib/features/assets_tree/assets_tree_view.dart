import 'package:flutter/material.dart';

import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';
import 'components/location_tile/location_tile_view.dart';

abstract class AssetsTreeViewModelProtocol with ChangeNotifier {
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
                SliverList.builder(
                  itemCount: viewModel.locationsViewModels.length,
                  itemBuilder: (_, index) {
                    return LocationTileView(
                      viewModel: viewModel.locationsViewModels[index],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
