import 'package:flutter_gen/gen_l10n/localization.dart';

import '../../support/enums/units_enum.dart';
import 'components/unit_item/unit_item_view.dart';
import 'components/unit_item/unit_item_view_model.dart';
import 'home_view_controller.dart';

class HomeViewModel extends HomeProtocol implements UnitItemDelegate {
  final Localization l10n;

  HomeViewModel({required this.l10n});

  // MARK: - Public Getters

  @override
  List<UnitItemViewModelProtocol> get unitsViewModels {
    return UnitsEnum.values.map((unit) {
      return UnitItemViewModel(
        unit: unit,
        l10n: l10n,
        delegate: this,
      );
    }).toList();
  }

  // MARK: - UnitItemDelegate

  @override
  void didTapUnit(UnitsEnum unit) {
    onTapUnit?.call(unit);
  }
}
