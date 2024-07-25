import 'package:flutter/material.dart';

import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class FilterOptionViewModelProtocol {
  String get text;
  IconData get icon;
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
    final iconColor = viewModel.isSelected ? AppColors.white : AppColors.gray;
    final borderColor = viewModel.isSelected ? AppColors.lightBlue : AppColors.gray;
    final backgroundColor = viewModel.isSelected ? AppColors.lightBlue : AppColors.white;
    final textStyle = viewModel.isSelected
        ? AppFonts.robotoSemiBold(14, AppColors.white)
        : AppFonts.robotoRegular(14, AppColors.gray);

    return GestureDetector(
      onTap: viewModel.didChangeOption,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              viewModel.icon,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Text(
              viewModel.text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
