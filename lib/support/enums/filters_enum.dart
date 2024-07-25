import 'package:flutter/material.dart';

enum FiltersEnum {
  energy,
  critical;

  int get key {
    return switch (this) {
      FiltersEnum.energy => 1,
      FiltersEnum.critical => 2,
    };
  }

  String get name {
    return switch (this) {
      FiltersEnum.energy => 'Sensor de Energia',
      FiltersEnum.critical => 'Crítico',
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
