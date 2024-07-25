import 'package:flutter/material.dart';

import '../../../../support/style/app_assets.dart';
import '../../../../support/style/app_colors.dart';
import '../../../../support/style/app_fonts.dart';

abstract class AssetTileViewModelProtocol {
  String get title;
  bool get isComponent;
  bool get isEnergySensor;
  bool get isCriticalSensor;
  List<AssetTileViewModelProtocol> get subAssetsViewModels;
}

class AssetTileView extends StatelessWidget {
  final AssetTileViewModelProtocol viewModel;

  const AssetTileView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final icon = viewModel.isComponent ? AppAssets.icComponent : AppAssets.icAsset;

    if (viewModel.subAssetsViewModels.isEmpty) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 16),
        title: Row(
          children: [
            Image.asset(icon),
            const SizedBox(width: 8),
            Text(
              viewModel.title,
              style: AppFonts.robotoRegular(14, AppColors.darkBlue),
            ),
            Visibility(
              visible: viewModel.isEnergySensor || viewModel.isCriticalSensor,
              child: Icon(
                viewModel.isEnergySensor ? Icons.flash_on_rounded : Icons.warning_rounded,
                color: viewModel.isEnergySensor ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      );
    }

    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 16),
      title: ListTile(
        title: Row(
          children: [
            Image.asset(icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.title,
                style: AppFonts.robotoRegular(14, AppColors.darkBlue),
              ),
            ),
            Visibility(
              visible: viewModel.isEnergySensor || viewModel.isCriticalSensor,
              child: Icon(
                viewModel.isEnergySensor ? Icons.flash_on_rounded : Icons.warning_rounded,
                color: viewModel.isEnergySensor ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
      children: viewModel.subAssetsViewModels.map((subAssetViewModel) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AssetTileView(viewModel: subAssetViewModel),
        );
      }).toList(),
    );
  }
}
