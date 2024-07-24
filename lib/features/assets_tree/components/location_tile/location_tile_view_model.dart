import '../../models/location.dart';
import 'location_tile_view.dart';

class LocationTileViewModel extends LocationTileViewModelProtocol {
  // MARK: - Init

  final Location location;

  LocationTileViewModel({required this.location});

  // MARK: - Public Getters

  @override
  String get title => location.name;
}
