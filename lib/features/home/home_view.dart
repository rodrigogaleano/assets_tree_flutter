import 'package:flutter/material.dart';

abstract class HomeViewModelProtocol with ChangeNotifier {}

class HomeView extends StatelessWidget {
  final HomeViewModelProtocol viewModel;

  const HomeView({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
