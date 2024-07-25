import 'package:flutter/material.dart';

import '../../../../support/style/app_assets.dart';
import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class AssetTileViewModelProtocol {
  String get title;
  bool get isComponent;
  bool get hasEnergySensor;
  bool get hasCriticalSensor;
  bool get isExpansionLocked;
  List<AssetTileViewModelProtocol> get subAssetsViewModels;
}

class AssetTileView extends StatelessWidget {
  final AssetTileViewModelProtocol viewModel;

  const AssetTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.subAssetsViewModels.isEmpty) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        title: _tileTitle,
      );
    }

    return ExpansionTile(
      initiallyExpanded: viewModel.isExpansionLocked,
      childrenPadding: const EdgeInsets.only(left: 16),
      title: ListTile(
        title: _tileTitle,
      ),
      children: viewModel.subAssetsViewModels.map((subAssetViewModel) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AssetTileView(viewModel: subAssetViewModel),
        );
      }).toList(),
    );
  }

  Widget get _tileTitle {
    final icon = viewModel.isComponent ? AppAssets.icComponent : AppAssets.icAsset;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            viewModel.title,
            softWrap: true,
            style: AppFonts.robotoRegular(14, AppColors.darkBlue),
          ),
        ),
        Visibility(
          visible: viewModel.hasEnergySensor,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.flash_on_rounded,
              size: 16,
              color: AppColors.green,
            ),
          ),
        ),
        Visibility(
          visible: viewModel.hasCriticalSensor,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
