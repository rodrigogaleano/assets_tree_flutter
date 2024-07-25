import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

import '../../../support/style/app_colors.dart';
import '../../../support/style/app_fonts.dart';
import 'filter_option/filter_option_view.dart';

class AssetTreeAppBar extends StatelessWidget {
  final Localization l10n;
  final TextEditingController searchBarController;
  final List<FilterOptionViewModelProtocol> filterOptionsViewModels;

  const AssetTreeAppBar({
    required this.l10n,
    required this.searchBarController,
    required this.filterOptionsViewModels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                controller: searchBarController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGray,
                  focusColor: AppColors.darkBlue,
                  hintText: l10n.assetsSearchBarHintText,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: filterOptionsViewModels.map((filter) {
                  return FilterOption(viewModel: filter);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
