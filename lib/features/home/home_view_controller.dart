import 'package:flutter/material.dart';

import '../../support/enums/units_enum.dart';
import '../../support/service_locator/service_locator.dart';
import 'home_view.dart';

abstract class HomeProtocol extends HomeViewModelProtocol {
  void Function(UnitsEnum)? onTapUnit;
}

class HomeViewController extends StatefulWidget {
  const HomeViewController({super.key});

  @override
  State<HomeViewController> createState() => _HomeViewControllerState();
}

class _HomeViewControllerState extends State<HomeViewController> {
  final viewModel = ServiceLocator.get<HomeProtocol>();

  // MARK: - Life Cycle

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(viewModel: viewModel);
  }

  // MARK: - Bind

  void _bind() {
    viewModel.onTapUnit = (unit) {
      // TODO: Navegar para a tela de detalhes da unidade
      print('Tapped on unit: $unit');
    };
  }
}
