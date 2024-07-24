import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class FilterOptionViewModelProtocol {
  String get text;
  bool get isSelected;

  void didChangeOption();
}

class FilterOption extends StatelessWidget {
  final FilterOptionViewModelProtocol viewModel;

  const FilterOption({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewModel.didChangeOption,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: viewModel.isSelected ? AppColors.lightBlue : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: viewModel.isSelected ? AppColors.lightBlue : AppColors.gray,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flash_on_outlined,
              color: viewModel.isSelected ? AppColors.white : AppColors.gray,
            ),
            Text(
              viewModel.text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get textStyle {
    if (viewModel.isSelected) {
      return AppFonts.robotoSemiBold(14, AppColors.white);
    }
    return AppFonts.robotoRegular(14, AppColors.gray);
  }
}
