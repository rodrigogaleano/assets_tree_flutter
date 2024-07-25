import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

enum FiltersEnum {
  energy,
  critical;

  int get key {
    return switch (this) {
      FiltersEnum.energy => 1,
      FiltersEnum.critical => 2,
    };
  }

  String name(Localization l10n) {
    return switch (this) {
      FiltersEnum.energy => l10n.filterEnergyInputTitle,
      FiltersEnum.critical => l10n.filterCritialInputTitle,
    };
  }

  IconData get icon {
    return switch (this) {
      FiltersEnum.energy => Icons.flash_on_rounded,
      FiltersEnum.critical => Icons.warning_amber_rounded,
    };
  }

  static FiltersEnum? fromKey(int key) {
    return switch (key) {
      1 => FiltersEnum.energy,
      2 => FiltersEnum.critical,
      _ => null,
    };
  }
}
