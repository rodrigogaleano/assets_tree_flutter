import 'package:flutter/material.dart';

import '../../support/enums/units_enum.dart';
import '../../support/service_locator/service_locator.dart';
import 'assets_tree_view.dart';

abstract class AssetsTreeProtocol extends AssetsTreeViewModelProtocol {}

class AssetsTreeViewController extends StatefulWidget {
  final UnitsEnum unit;

  const AssetsTreeViewController({required this.unit, super.key});

  @override
  State<AssetsTreeViewController> createState() => _AssetsTreeViewControllerState();
}

class _AssetsTreeViewControllerState extends State<AssetsTreeViewController> {
  late AssetsTreeProtocol viewModel;

  // MARK: - Lifecycle

  @override
  void initState() {
    super.initState();
    viewModel = ServiceLocator.get<AssetsTreeProtocol>(param: widget.unit);
  }

  @override
  Widget build(BuildContext context) {
    return AssetsTreeView(viewModel: viewModel);
  }
}
