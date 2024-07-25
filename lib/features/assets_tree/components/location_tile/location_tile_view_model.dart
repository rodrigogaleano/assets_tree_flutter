import '../../../../support/enums/filters_enum.dart';
import '../../models/location.dart';
import '../asset_tile/asset_tile_view.dart';
import '../asset_tile/asset_tile_view_model.dart';
import 'location_tile_view.dart';

class LocationTileViewModel extends LocationTileViewModelProtocol {
  // MARK: - Init

  final int filterOption;
  final Location location;

  LocationTileViewModel({
    required this.location,
    required this.filterOption,
  });

  // MARK: - Public Getters

  @override
  String get title => location.name;

  @override
  List<AssetTileViewModelProtocol> get assetsViewModels {
    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return location.assets.where((asset) {
        return asset.subAssets.any((subAsset) {
              return subAsset.isEnergySensor;
            }) ||
            asset.isEnergySensor;
      }).map((asset) {
        return AssetTileViewModel(asset: asset, filterOption: filterOption);
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return location.assets.where((asset) {
        return asset.subAssets.any((subAsset) {
              return subAsset.isCriticalSensor;
            }) ||
            asset.isCriticalSensor;
      }).map((asset) {
        return AssetTileViewModel(asset: asset, filterOption: filterOption);
      }).toList();
    }

    return location.assets.map((asset) {
      return AssetTileViewModel(asset: asset, filterOption: filterOption);
    }).toList();
  }

  @override
  List<LocationTileViewModelProtocol> get subLocationsViewModels {
    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return location.subLocations.where((subLocation) {
        return subLocation.assets.any((asset) {
          return asset.isEnergySensor;
        });
      }).map((subLocation) {
        return LocationTileViewModel(
          location: subLocation,
          filterOption: filterOption,
        );
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return location.subLocations.where((subLocation) {
        return subLocation.assets.any((asset) {
          return asset.isCriticalSensor;
        });
      }).map((subLocation) {
        return LocationTileViewModel(
          location: subLocation,
          filterOption: filterOption,
        );
      }).toList();
    }

    return location.subLocations.map((subLocation) {
      return LocationTileViewModel(
        location: subLocation,
        filterOption: filterOption,
      );
    }).toList();
  }
}
