import 'package:flutter/material.dart';

import '../../support/enums/units_enum.dart';
import '../../support/utils/debouncer.dart';
import 'assets_tree_view_controller.dart';
import 'components/asset_tile/asset_tile_view.dart';
import 'components/asset_tile/asset_tile_view_model.dart';
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
  String _searchQuery = '';
  String _errorMessage = '';

  List<Asset> _assets = [];
  List<Location> _locations = [];

  final _debouncer = Debouncer(milliseconds: 1500);
  final _searchBarController = TextEditingController();

  // MARK: - Init

  final UnitsEnum unit;
  final GetAssetsUseCaseProtocol getAssetsUseCase;
  final GetLocationsUseCaseProtocol getLocationsUseCase;

  AssetsViewModel({
    required this.unit,
    required this.getAssetsUseCase,
    required this.getLocationsUseCase,
  }) {
    _searchBarController.addListener(() {
      _searchQuery = _searchBarController.text;
      if (_searchQuery.isNotEmpty) {
        _debouncer.run(_searchItems);
      }
      notifyListeners();
    });
  }

  // MARK: - Public Getters

  @override
  bool get isLoading => _isLocationsLoading || _isAssetsLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  List<LocationTileViewModelProtocol> get locationsViewModels {
    return _locations.map((location) {
      return LocationTileViewModel(location: location);
    }).toList();
  }

  @override
  List<AssetTileViewModelProtocol> get aloneAssetsViewModels {
    final aloneAssets = _assets.where((asset) {
      return asset.locationId == null && asset.parentId == null;
    }).toList();

    return aloneAssets.map((asset) {
      return AssetTileViewModel(asset: asset);
    }).toList();
  }

  @override
  TextEditingController get searchBarController => _searchBarController;

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
        _combineSubAssetsAndAssets();
      },
      failure: (error) => _errorMessage = error,
      onComplete: () => _setAssetsLoading(false),
    );
  }

  void _combineSubAssetsAndAssets() {
    final subAssets = <Asset>[];
    final assetMap = <String, Asset>{
      for (final asset in _assets) asset.id: asset,
    };

    for (final asset in _assets) {
      if (asset.parentId != null && assetMap.containsKey(asset.parentId)) {
        assetMap[asset.parentId]?.subAssets.add(asset);
        subAssets.add(asset);
      }
    }

    _assets.removeWhere((asset) => subAssets.contains(asset));
    _combineAssetsAndLocations();
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

    _combineSubLocationsAndLocations();
  }

  void _combineSubLocationsAndLocations() {
    final subLocations = <Location>[];
    final locationMap = <String, Location>{
      for (final location in _locations) location.id: location,
    };

    for (final location in _locations) {
      if (location.parentId != null && locationMap.containsKey(location.parentId)) {
        locationMap[location.parentId]?.subLocations.add(location);
        subLocations.add(location);
      }
    }

    _locations.removeWhere((location) => subLocations.contains(location));
  }

  void _setLocationsLoading(bool isLoading) {
    _isLocationsLoading = isLoading;
    notifyListeners();
  }

  void _setAssetsLoading(bool isLoading) {
    _isAssetsLoading = isLoading;
    notifyListeners();
  }

  void _searchItems() {
    // TODO: Filtrar itens
  }
}
