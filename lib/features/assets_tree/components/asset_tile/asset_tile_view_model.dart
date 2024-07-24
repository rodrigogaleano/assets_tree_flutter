import '../../models/asset.dart';
import 'asset_tile_view.dart';

class AssetTileViewModel extends AssetTileViewModelProtocol {
  // MARK: - Init

  final Asset asset;

  AssetTileViewModel({required this.asset});

  // MARK: - Public Getters

  @override
  bool get isComponent {
    return asset.sensorType != null;
  }

  @override
  String get title => asset.name;

  @override
  List<AssetTileViewModelProtocol> get subAssetsViewModels {
    return asset.subAssets.map((subAsset) {
      return AssetTileViewModel(asset: subAsset);
    }).toList();
  }
}
