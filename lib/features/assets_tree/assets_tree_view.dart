import 'package:flutter/material.dart';

abstract class AssetsTreeViewModelProtocol {}

class AssetsTreeView extends StatelessWidget {
  final AssetsTreeViewModelProtocol viewModel;

  const AssetsTreeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
