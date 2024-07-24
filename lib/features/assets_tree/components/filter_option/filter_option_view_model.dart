import '../../../../support/enums/filters_enum.dart';
import 'filter_option_view.dart';

abstract class FilterOptionDelegate {
  void didChangeFilterOption(int selectedValue);
}

class FilterOptionViewModel extends FilterOptionViewModelProtocol {
  final int groupValue;
  final FiltersEnum filter;
  final FilterOptionDelegate delegate;

  FilterOptionViewModel({
    required this.filter,
    required this.delegate,
    required this.groupValue,
  });

  @override
  String get text => filter.name;

  @override
  bool get isSelected => groupValue == filter.key;

  @override
  void didChangeOption() {
    final value = groupValue == filter.key ? 0 : filter.key;

    delegate.didChangeFilterOption(value);
  }
}
