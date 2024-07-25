import '../../../../support/enums/filters_enum.dart';
import '../../models/asset.dart';
import 'asset_tile_view.dart';

class AssetTileViewModel extends AssetTileViewModelProtocol {
  // MARK: - Init

  final Asset asset;
  final int filterOption;
  final bool expandedTile;

  AssetTileViewModel({
    required this.asset,
    required this.filterOption,
    required this.expandedTile,
  });

  // MARK: - Public Getters

  @override
  bool get isComponent {
    return asset.sensorType != null;
  }

  @override
  bool get hasEnergySensor {
    return asset.isEnergySensor;
  }

  @override
  bool get isExpansionLocked => expandedTile;

  @override
  bool get hasCriticalSensor => asset.isCriticalSensor;

  @override
  String get title => asset.name;

  @override
  List<AssetTileViewModelProtocol> get subAssetsViewModels {
    bool hasEnergySensor(Asset asset) {
      return asset.isEnergySensor || _hasSensorInSubAssets(asset, (a) => a.isEnergySensor);
    }

    bool hasCriticalSensor(Asset asset) {
      return asset.isCriticalSensor || _hasSensorInSubAssets(asset, (a) => a.isCriticalSensor);
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return asset.subAssets.where(hasEnergySensor).map((subAsset) {
        return AssetTileViewModel(
          asset: subAsset,
          filterOption: filterOption,
          expandedTile: expandedTile,
        );
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return asset.subAssets.where(hasCriticalSensor).map((subAsset) {
        return AssetTileViewModel(
          asset: subAsset,
          filterOption: filterOption,
          expandedTile: expandedTile,
        );
      }).toList();
    }

    return asset.subAssets.map((subAsset) {
      return AssetTileViewModel(
        asset: subAsset,
        filterOption: filterOption,
        expandedTile: expandedTile,
      );
    }).toList();
  }

  // MARK: - Private Methods

  bool _hasSensorInSubAssets(Asset asset, bool Function(Asset) sensorCheck) {
    for (final subAsset in asset.subAssets) {
      if (sensorCheck(subAsset) || _hasSensorInSubAssets(subAsset, sensorCheck)) {
        return true;
      }
    }

    return false;
  }
}
