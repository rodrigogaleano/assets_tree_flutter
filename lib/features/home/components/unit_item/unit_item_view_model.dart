import 'package:flutter_gen/gen_l10n/localization.dart';

import '../../../../support/enums/units_enum.dart';
import 'unit_item_view.dart';

abstract class UnitItemDelegate {
  void didTapUnit(UnitsEnum unit);
}

class UnitItemViewModel extends UnitItemViewModelProtocol {
  // MARK: - Init

  final UnitsEnum unit;
  final Localization l10n;
  final UnitItemDelegate delegate;

  UnitItemViewModel({
    required this.l10n,
    required this.unit,
    required this.delegate,
  });

  // MARK: - Public Getters

  @override
  String get name => unit.name(l10n);

  // MARK: - Public Methods

  @override
  void didTapUnit() {
    delegate.didTapUnit(unit);
  }
}
