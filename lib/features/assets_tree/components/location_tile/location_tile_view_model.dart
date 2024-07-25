import '../../../../support/enums/filters_enum.dart';
import '../../models/asset.dart';
import '../../models/location.dart';
import '../asset_tile/asset_tile_view.dart';
import '../asset_tile/asset_tile_view_model.dart';
import 'location_tile_view.dart';

class LocationTileViewModel extends LocationTileViewModelProtocol {
  // MARK: - Init

  final int filterOption;
  final Location location;
  final bool lockExpansion;

  LocationTileViewModel({
    required this.location,
    required this.filterOption,
    required this.lockExpansion,
  });

  // MARK: - Public Getters

  @override
  bool get isExpansionLocked => lockExpansion;

  @override
  String get title => location.name;

  @override
  List<AssetTileViewModelProtocol> get assetsViewModels {
    bool hasSensor(Asset asset, bool Function(Asset) sensorCheck) {
      return sensorCheck(asset) || asset.subAssets.any(sensorCheck);
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return location.assets
          .where((asset) => hasSensor(asset, (a) {
                return a.isEnergySensor;
              }))
          .map((asset) {
        return AssetTileViewModel(
          asset: asset,
          filterOption: filterOption,
          lockExpansion: lockExpansion,
        );
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return location.assets
          .where((asset) => hasSensor(asset, (a) {
                return a.isCriticalSensor;
              }))
          .map((asset) {
        return AssetTileViewModel(
          asset: asset,
          filterOption: filterOption,
          lockExpansion: lockExpansion,
        );
      }).toList();
    }

    return location.assets.map((asset) {
      return AssetTileViewModel(
        asset: asset,
        filterOption: filterOption,
        lockExpansion: lockExpansion,
      );
    }).toList();
  }

  bool _hasSensorInSubLocations(Location location, bool Function(Asset) sensorCheck) {
    for (final subLocation in location.subLocations) {
      if (subLocation.assets.any(sensorCheck) || _hasSensorInSubLocations(subLocation, sensorCheck)) {
        return true;
      }
    }

    return false;
  }

  @override
  List<LocationTileViewModelProtocol> get subLocationsViewModels {
    bool hasEnergySensor(Location location) {
      return location.assets.any((asset) => asset.isEnergySensor) ||
          _hasSensorInSubLocations(location, (a) => a.isEnergySensor);
    }

    bool hasCriticalSensor(Location location) {
      return location.assets.any((asset) => asset.isCriticalSensor) ||
          _hasSensorInSubLocations(location, (a) => a.isCriticalSensor);
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return location.subLocations.where(hasEnergySensor).map((subLocation) {
        return LocationTileViewModel(
          location: subLocation,
          filterOption: filterOption,
          lockExpansion: lockExpansion,
        );
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return location.subLocations.where(hasCriticalSensor).map((subLocation) {
        return LocationTileViewModel(
          location: subLocation,
          filterOption: filterOption,
          lockExpansion: lockExpansion,
        );
      }).toList();
    }

    return location.subLocations.map((subLocation) {
      return LocationTileViewModel(
        location: subLocation,
        filterOption: filterOption,
        lockExpansion: lockExpansion,
      );
    }).toList();
  }
}
