import '../../support/enums/units_enum.dart';
import 'assets_tree_view_controller.dart';
import 'components/location_tile/location_tile_view.dart';
import 'components/location_tile/location_tile_view_model.dart';
import 'models/location.dart';
import 'use_cases/get_locations_use_case.dart';

class AssetsViewModel extends AssetsTreeProtocol {
  // MARK: - Private Properties

  bool _isLoading = false;
  String _errorMessage = '';
  List<Location> _locations = [];

  // MARK: - Init

  final UnitsEnum unit;
  final GetLocationsUseCaseProtocol getLocationsUseCase;

  AssetsViewModel({required this.unit, required this.getLocationsUseCase});

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
    _setLoading(true);
    getLocationsUseCase.execute(
      jsonPath: unit.locationsPath,
      success: (locations) => _locations = locations,
      failure: (error) => _errorMessage = error,
      onComplete: () => _setLoading(false),
    );
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
