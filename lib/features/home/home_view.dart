import 'package:flutter/material.dart';

import '../../support/enums/units_enum.dart';
import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';

abstract class HomeViewModelProtocol with ChangeNotifier {}

class HomeView extends StatelessWidget {
  final HomeViewModelProtocol viewModel;

  const HomeView({required this.viewModel, super.key});

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
                  centerTitle: true,
                  backgroundColor: AppColors.darkBlue,
                  // TODO: Substituir pela logo da empresa
                  title: Text(
                    'TRACTIAN',
                    style: AppFonts.robotoBold(24, AppColors.white),
                  ),
                ),
                SliverList.builder(
                  itemCount: UnitsEnum.values.length,
                  itemBuilder: (_, index) {
                    final currentUnit = UnitsEnum.values[index];

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(24),
                          backgroundColor: AppColors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          currentUnit.name,
                          style: AppFonts.robotoSemiBold(18, AppColors.white),
                        ),
                      ),
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
