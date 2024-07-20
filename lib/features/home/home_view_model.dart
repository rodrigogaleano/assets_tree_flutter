import '../../support/enums/units_enum.dart';
import 'components/unit_item/unit_item_view.dart';
import 'components/unit_item/unit_item_view_model.dart';
import 'home_view_controller.dart';

class HomeViewModel extends HomeProtocol implements UnitItemDelegate {
  // MARK: - Public Getters

  @override
  List<UnitItemViewModelProtocol> get unitsViewModels {
    return UnitsEnum.values.map((unit) {
      return UnitItemViewModel(unit: unit, delegate: this);
    }).toList();
  }

  // MARK: - UnitItemDelegate

  @override
  void didTapUnit(UnitsEnum unit) {
    onTapUnit?.call(unit);
  }
}
