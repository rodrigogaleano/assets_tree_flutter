import '../../../../support/enums/units_enum.dart';
import 'unit_item_view.dart';

abstract class UnitItemDelegate {
  void didTapUnit(UnitsEnum unit);
}

class UnitItemViewModel extends UnitItemViewModelProtocol {
  // MARK: - Init

  final UnitsEnum unit;
  final UnitItemDelegate delegate;

  UnitItemViewModel({
    required this.unit,
    required this.delegate,
  });

  // MARK: - Public Getters

  @override
  String get name => unit.name;

  // MARK: - Public Methods

  @override
  void didTapUnit() {
    delegate.didTapUnit(unit);
  }
}
