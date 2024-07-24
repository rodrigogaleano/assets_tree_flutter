import '../../models/location.dart';
import 'location_tile_view.dart';

class LocationTileViewModel extends LocationTileViewModelProtocol {
  // MARK: - Init

  final Location location;

  LocationTileViewModel({required this.location});

  // MARK: - Public Getters

  @override
  String get title => location.name;

  @override
  List<String> get assetsTitles {
    return location.assets.map((asset) {
      return asset.name;
    }).toList();
  }

  @override
  List<LocationTileViewModelProtocol> get subLocationsViewModels {
    return location.subLocations.map((subLocation) {
      return LocationTileViewModel(location: subLocation);
    }).toList();
  }
}
