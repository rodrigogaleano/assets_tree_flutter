import 'package:flutter/material.dart';

import '../../localization/localize.dart';
import '../../support/service_locator/service_locator.dart';
import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';
import 'components/asset_tile/asset_tile_view.dart';
import 'components/filter_option/filter_option_view.dart';
import 'components/location_tile/location_tile_view.dart';

abstract class AssetsTreeViewModelProtocol with ChangeNotifier {
  bool get isLoading;
  String get errorMessage;

  TextEditingController get searchBarController;

  List<AssetTileViewModelProtocol> get aloneAssetsViewModels;
  List<LocationTileViewModelProtocol> get locationsViewModels;
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
                SliverAppBar(
                  title: Text(
                    l10n.assetsTitle,
                    style: AppFonts.robotoBold(24, AppColors.white),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(150),
                    child: Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: viewModel.searchBarController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightGray,
                              focusColor: AppColors.darkBlue,
                              hintText: 'Buscar Ativo ou Local',
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              FilterOption(
                                text: 'Sensor de Energia',
                                isSelected: true,
                              ),
                              FilterOption(
                                text: 'Crítico',
                                isSelected: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
