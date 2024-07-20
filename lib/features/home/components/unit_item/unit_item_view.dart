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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          backgroundColor: AppColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: viewModel.didTapUnit,
        child: Row(
          children: [
            const Icon(Icons.storage, color: AppColors.white),
            const SizedBox(width: 16),
            Text(
              viewModel.name,
              style: AppFonts.robotoSemiBold(18, AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
