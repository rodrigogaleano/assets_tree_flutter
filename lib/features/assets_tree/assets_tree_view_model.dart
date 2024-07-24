import '../../support/enums/units_enum.dart';
import 'assets_tree_view_controller.dart';
import 'components/location_tile/location_tile_view.dart';
import 'components/location_tile/location_tile_view_model.dart';
import 'models/asset.dart';
import 'models/location.dart';
import 'use_cases/get_assets_use_case.dart';
import 'use_cases/get_locations_use_case.dart';

class AssetsViewModel extends AssetsTreeProtocol {
  // MARK: - Private Properties

  bool _isAssetsLoading = false;
  bool _isLocationsLoading = false;
  String _errorMessage = '';

  List<Asset> _assets = [];
  List<Location> _locations = [];

  // MARK: - Init

  final UnitsEnum unit;
  final GetAssetsUseCaseProtocol getAssetsUseCase;
  final GetLocationsUseCaseProtocol getLocationsUseCase;

  AssetsViewModel({
    required this.unit,
    required this.getAssetsUseCase,
    required this.getLocationsUseCase,
  });

  // MARK: - Public Getters

  @override
  List<LocationTileViewModelProtocol> get locationsViewModels {
    return _locations.map((location) {
      return LocationTileViewModel(location: location);
    }).toList();
  }

  // MARK: - Public Methods

  @override
  void loadContent() {
    _getLocations();
  }

  // MARK: - Private Methods

  void _getLocations() {
    _setLocationsLoading(true);
    getLocationsUseCase.execute(
      jsonPath: unit.locationsPath,
      success: (locations) {
        _locations = locations;
        _getAssets();
      },
      failure: (error) => _errorMessage = error,
      onComplete: () => _setLocationsLoading(false),
    );
  }

  void _getAssets() {
    _setAssetsLoading(true);
    getAssetsUseCase.execute(
      jsonPath: unit.assetsPath,
      success: (assets) {
        _assets = assets;
        _combineAssetsAndLocations();
      },
      failure: (error) => _errorMessage = error,
      onComplete: () => _setAssetsLoading(false),
    );
  }

  void _combineAssetsAndLocations() {
    final locationAssetsMap = <String, List<Asset>>{};

    for (final location in _locations) {
      locationAssetsMap[location.id] = [];
    }

    for (final asset in _assets) {
      if (locationAssetsMap.containsKey(asset.locationId)) {
        locationAssetsMap[asset.locationId]?.add(asset);
      }
    }

    for (final location in _locations) {
      location.assets = locationAssetsMap[location.id] ?? [];
    }
  }

  void _setLocationsLoading(bool isLoading) {
    _isLocationsLoading = isLoading;
    notifyListeners();
  }

  void _setAssetsLoading(bool isLoading) {
    _isAssetsLoading = isLoading;
    notifyListeners();
  }
}
