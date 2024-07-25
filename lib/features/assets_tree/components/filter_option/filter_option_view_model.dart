import 'package:flutter/src/widgets/icon_data.dart';

import '../../../../support/enums/filters_enum.dart';
import 'filter_option_view.dart';

abstract class FilterOptionDelegate {
  void didChangeFilterOption(int selectedValue);
}

class FilterOptionViewModel extends FilterOptionViewModelProtocol {
  // MARK: - Init

  final int groupValue;
  final FiltersEnum filter;
  final FilterOptionDelegate delegate;

  FilterOptionViewModel({
    required this.filter,
    required this.delegate,
    required this.groupValue,
  });

  // MARK: - Public Getters

  @override
  String get text => filter.name;

  @override
  bool get isSelected => groupValue == filter.key;

  @override
  IconData get icon => filter.icon;

  // MARK - Public Methods

  @override
  void didChangeOption() {
    final value = groupValue == filter.key ? 0 : filter.key;

    delegate.didChangeFilterOption(value);
  }
}
