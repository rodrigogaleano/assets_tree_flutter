import 'package:flutter/material.dart';

import '../../support/style/app_colors.dart';
import '../../support/style/app_fonts.dart';

abstract class AssetsTreeViewModelProtocol with ChangeNotifier {}

class AssetsTreeView extends StatelessWidget {
  final AssetsTreeViewModelProtocol viewModel;

  const AssetsTreeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Assets',
                style: AppFonts.robotoBold(24, AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
