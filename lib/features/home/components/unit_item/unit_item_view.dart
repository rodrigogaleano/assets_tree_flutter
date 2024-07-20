import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class UnitItemViewModelProtocol {
  String get name;

  void didTapUnit();
}

class UnitItemView extends StatelessWidget {
  final UnitItemViewModelProtocol viewModel;

  const UnitItemView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
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
        onPressed: viewModel.didTapUnit,
        child: Text(
          viewModel.name,
          style: AppFonts.robotoSemiBold(18, AppColors.white),
        ),
      ),
    );
  }
}
