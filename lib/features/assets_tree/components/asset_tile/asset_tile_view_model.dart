import '../../../../support/enums/filters_enum.dart';
import '../../models/asset.dart';
import 'asset_tile_view.dart';

class AssetTileViewModel extends AssetTileViewModelProtocol {
  // MARK: - Init

  final Asset asset;
  final int filterOption;

  AssetTileViewModel({
    required this.asset,
    required this.filterOption,
  });

  // MARK: - Public Getters

  @override
  bool get isComponent {
    return asset.sensorType != null;
  }

  @override
  bool get isEnergySensor {
    return asset.isEnergySensor;
  }

  @override
  bool get isCriticalSensor => asset.isCriticalSensor;

  @override
  String get title => asset.name;

  @override
  List<AssetTileViewModelProtocol> get subAssetsViewModels {
    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.energy) {
      return asset.subAssets.where((subAsset) {
        if (subAsset.subAssets.isEmpty) {
          return subAsset.isEnergySensor;
        }

        return subAsset.subAssets.any((subAsset) {
          return subAsset.isEnergySensor;
        });
      }).map((subAsset) {
        return AssetTileViewModel(asset: subAsset, filterOption: filterOption);
      }).toList();
    }

    if (FiltersEnum.fromKey(filterOption) == FiltersEnum.critical) {
      return asset.subAssets.where((subAsset) {
        if (subAsset.subAssets.isEmpty) {
          return subAsset.isCriticalSensor;
        }

        return subAsset.subAssets.any((subAsset) {
          return subAsset.isCriticalSensor;
        });
      }).map((subAsset) {
        return AssetTileViewModel(asset: subAsset, filterOption: filterOption);
      }).toList();
    }

    return asset.subAssets.map((subAsset) {
      return AssetTileViewModel(asset: subAsset, filterOption: filterOption);
    }).toList();
  }
}
