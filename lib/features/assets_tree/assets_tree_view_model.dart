import 'package:flutter/material.dart';

import '../../support/enums/filters_enum.dart';
import '../../support/enums/units_enum.dart';
import '../../support/utils/debouncer.dart';
import 'assets_tree_view_controller.dart';
import 'components/asset_tile/asset_tile_view.dart';
import 'components/asset_tile/asset_tile_view_model.dart';
import 'components/filter_option/filter_option_view.dart';
import 'components/filter_option/filter_option_view_model.dart';
import 'components/location_tile/location_tile_view.dart';
import 'components/location_tile/location_tile_view_model.dart';
import 'models/asset.dart';
import 'models/location.dart';
import 'use_cases/get_assets_use_case.dart';
import 'use_cases/get_locations_use_case.dart';

class AssetsViewModel extends AssetsTreeProtocol implements FilterOptionDelegate {
  // MARK: - Private Properties

  bool _isAssetsLoading = false;
  bool _isLocationsLoading = false;
  int _selectedFilter = 0;
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
      _debouncer.run(() {
        _searchQuery = _searchBarController.text;
        notifyListeners();
      });
    });
  }

  // MARK: - Public Getters

  @override
  bool get isLoading => _isLocationsLoading || _isAssetsLoading;

  @override
  String get errorMessage => _errorMessage;

  @override
  List<LocationTileViewModelProtocol> get locationsViewModels {
    var filteredLocations = _locations;

    if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.energy) {
      filteredLocations = _filterLocationsByEnergySensor(filteredLocations);
    } else if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.critical) {
      filteredLocations = _filterLocationsByCriticalSensor(filteredLocations);
    }

    return filteredLocations.map((location) {
      return LocationTileViewModel(
        location: location,
        filterOption: _selectedFilter,
        lockExpansion: _isExpansionLocked,
      );
    }).toList();
  }

  @override
  List<AssetTileViewModelProtocol> get unlinkedAssetsViewModels {
    final unlinkedAssets = _assets.where((asset) {
      return asset.locationId == null && asset.parentId == null;
    }).toList();

    var filteredAssets = unlinkedAssets;

    if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.energy) {
      filteredAssets = _filterAssetsByEnergySensor(filteredAssets);
    } else if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.critical) {
      filteredAssets = _filterAssetsByCriticalSensor(filteredAssets);
    }

    return filteredAssets.map((asset) {
      return AssetTileViewModel(
        asset: asset,
        filterOption: _selectedFilter,
        lockExpansion: _isExpansionLocked,
      );
    }).toList();
  }

  @override
  TextEditingController get searchBarController => _searchBarController;

  @override
  List<FilterOptionViewModelProtocol> get filterOptionsViewModels {
    return FiltersEnum.values.map((filter) {
      return FilterOptionViewModel(
        filter: filter,
        delegate: this,
        groupValue: _selectedFilter,
      );
    }).toList();
  }

  // MARK: - Public Methods

  @override
  void loadContent() {
    _getLocations();
  }

  // MARK: - FilterOptionDelegate

  @override
  void didChangeFilterOption(int selectedValue) {
    _selectedFilter = selectedValue;

    notifyListeners();
  }

  // MARK: - Private Getters

  bool get _isExpansionLocked {
    return _selectedFilter != 0;
  }

  // MARK: - Private Methods

  // MARK: - Requests

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

  // MARK: - Combine Data

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

  // MARK: - Filters

  List<Location> _filterLocationsByEnergySensor(List<Location> locations) {
    bool hasEnergySensorInSubLocations(Location location) {
      // Verifica se alguma sublocalização ou suas sublocalizações tem o sensor de energia
      for (final subLocation in location.subLocations) {
        if (subLocation.assets.any((asset) => asset.isEnergySensor) || hasEnergySensorInSubLocations(subLocation)) {
          return true;
        }
      }
      return false;
    }

    return locations.where((location) {
      final hasEnergyAsset = location.assets.any((asset) => asset.isEnergySensor);
      final hasSubLocationWithEnergyAsset = hasEnergySensorInSubLocations(location);
      final hasAssetWithSubAssetEnergy =
          location.assets.any((asset) => asset.subAssets.any((subAsset) => subAsset.isEnergySensor));

      return hasEnergyAsset || hasSubLocationWithEnergyAsset || hasAssetWithSubAssetEnergy;
    }).toList();
  }

  List<Location> _filterLocationsByCriticalSensor(List<Location> locations) {
    bool hasCriticalSensorInSubLocations(Location location) {
      // Verifica se alguma sublocalização ou suas sublocalizações tem o sensor crítico
      for (final subLocation in location.subLocations) {
        if (subLocation.assets.any((asset) => asset.isCriticalSensor) || hasCriticalSensorInSubLocations(subLocation)) {
          return true;
        }
      }
      return false;
    }

    return locations.where((location) {
      final hasCriticalAsset = location.assets.any((asset) => asset.isCriticalSensor);
      final hasSubLocationWithCriticalAsset = hasCriticalSensorInSubLocations(location);
      final hasAssetWithSubAssetCritical =
          location.assets.any((asset) => asset.subAssets.any((subAsset) => subAsset.isCriticalSensor));

      return hasCriticalAsset || hasSubLocationWithCriticalAsset || hasAssetWithSubAssetCritical;
    }).toList();
  }

  List<Asset> _filterAssetsByEnergySensor(List<Asset> assets) {
    return assets.where((asset) => asset.isEnergySensor).toList();
  }

  List<Asset> _filterAssetsByCriticalSensor(List<Asset> assets) {
    return assets.where((asset) => asset.isCriticalSensor).toList();
  }

  // MARK: - Loading

  void _setLocationsLoading(bool isLoading) {
    _isLocationsLoading = isLoading;
    notifyListeners();
  }

  void _setAssetsLoading(bool isLoading) {
    _isAssetsLoading = isLoading;
    notifyListeners();
  }
}
