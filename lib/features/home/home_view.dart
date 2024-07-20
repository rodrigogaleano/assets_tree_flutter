import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: AppColors.darkBlue,
              // TODO: Substituir pela logo da empresa
              title: Text(
                'TRACTIAN',
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
