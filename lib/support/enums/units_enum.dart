import 'package:flutter_gen/gen_l10n/localization.dart';

import '../style/app_assets.dart';

enum UnitsEnum {
  jaguar,
  tobias,
  apex;

  String name(Localization l10n) {
    return switch (this) {
      UnitsEnum.jaguar => l10n.jaguarUnitName,
      UnitsEnum.tobias => l10n.tobiasUnitName,
      UnitsEnum.apex => l10n.apexUnitName,
    };
  }

  String get assetsPath {
    return switch (this) {
      UnitsEnum.jaguar => AppAssets.jaguarAssets,
      UnitsEnum.tobias => AppAssets.tobiasAssets,
      UnitsEnum.apex => AppAssets.apexAssets,
    };
  }

  String get locationsPath {
    return switch (this) {
      UnitsEnum.jaguar => AppAssets.jaguarLocations,
      UnitsEnum.tobias => AppAssets.tobiasLocations,
      UnitsEnum.apex => AppAssets.apexLocations,
    };
  }
}
