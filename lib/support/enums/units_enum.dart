import '../style/app_assets.dart';

enum UnitsEnum {
  jaguar,
  tobias,
  apex;

  String get name {
    return switch (this) {
      UnitsEnum.jaguar => 'Jaguar Unit',
      UnitsEnum.tobias => 'Tobias Unit',
      UnitsEnum.apex => 'Apex Unit',
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
