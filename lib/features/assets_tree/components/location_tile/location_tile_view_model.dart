import '../../models/location.dart';
import '../asset_tile/asset_tile_view.dart';
import '../asset_tile/asset_tile_view_model.dart';
import 'location_tile_view.dart';

class LocationTileViewModel extends LocationTileViewModelProtocol {
  // MARK: - Init

  final Location location;

  LocationTileViewModel({required this.location});

  // MARK: - Public Getters

  @override
  String get title => location.name;

  @override
  List<AssetTileViewModelProtocol> get assetsViewModels {
    return location.assets.map((asset) {
      return AssetTileViewModel(asset: asset);
    }).toList();
  }

  @override
  List<LocationTileViewModelProtocol> get subLocationsViewModels {
    return location.subLocations.map((subLocation) {
      return LocationTileViewModel(location: subLocation);
    }).toList();
  }
}
