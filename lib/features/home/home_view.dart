import 'package:flutter/material.dart';

import '../../localization/localize.dart';
import '../../support/service_locator/service_locator.dart';
import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';
import 'components/unit_item/unit_item_view.dart';

abstract class HomeViewModelProtocol {
  List<UnitItemViewModelProtocol> get unitsViewModels;
}

class HomeView extends StatelessWidget {
  final HomeViewModelProtocol viewModel;

  const HomeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = ServiceLocator.get<LocalizeProtocol>().l10n;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                l10n.homeTitle,
                style: AppFonts.robotoBold(24, AppColors.white),
              ),
            ),
            SliverList.builder(
              itemCount: viewModel.unitsViewModels.length,
              itemBuilder: (_, index) {
                final currentViewModel = viewModel.unitsViewModels[index];

                return UnitItemView(viewModel: currentViewModel);
              },
            ),
          ],
        ),
      ),
    );
  }
}
