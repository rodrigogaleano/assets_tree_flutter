import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';

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

  final _debouncer = Debouncer(milliseconds: 500);
  final _searchBarController = TextEditingController();

  // MARK: - Init

  final UnitsEnum unit;
  final Localization l10n;
  final GetAssetsUseCaseProtocol getAssetsUseCase;
  final GetLocationsUseCaseProtocol getLocationsUseCase;

  AssetsViewModel({
    required this.l10n,
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
  TextEditingController get searchBarController => _searchBarController;

  @override
  List<FilterOptionViewModelProtocol> get filterOptionsViewModels {
    return FiltersEnum.values.map((filter) {
      return FilterOptionViewModel(
        l10n: l10n,
        filter: filter,
        delegate: this,
        groupValue: _selectedFilter,
      );
    }).toList();
  }

  @override
  List<LocationTileViewModelProtocol> get locationsViewModels {
    var filteredLocations = _locations;

    if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.energy) {
      filteredLocations = _filterLocationsByEnergySensor(filteredLocations);
    } else if (FiltersEnum.fromKey(_selectedFilter) == FiltersEnum.critical) {
      filteredLocations = _filterLocationsByCriticalSensor(filteredLocations);
    }

    if (_searchQuery.isNotEmpty) {
      filteredLocations = _filterLocationsBySearchQuery(filteredLocations, _searchQuery);
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

    if (_searchQuery.isNotEmpty) {
      filteredAssets = _filterAssetsBySearchQuery(filteredAssets, _searchQuery);
    }

    return filteredAssets.map((asset) {
      return AssetTileViewModel(
        asset: asset,
        filterOption: _selectedFilter,
        lockExpansion: _isExpansionLocked,
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
    return _selectedFilter != 0 || _searchQuery.isNotEmpty;
  }

  // MARK: - Private Methods

  // Requests

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

  // Combine Data

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

  // Filters

  List<Location> _filterLocationsByEnergySensor(List<Location> locations) {
    bool hasEnergySensorInSubLocations(Location location) {
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

  List<Location> _filterLocationsBySearchQuery(List<Location> locations, String query) {
    bool matchesQuery(String name, String query) {
      return name.toLowerCase().contains(query.toLowerCase());
    }

    bool hasMatchingAssetInSubLocations(Location location, String query) {
      for (final subLocation in location.subLocations) {
        if (subLocation.assets.any((asset) => matchesQuery(asset.name, query)) ||
            hasMatchingAssetInSubLocations(subLocation, query)) {
          return true;
        }
      }
      return false;
    }

    return locations.where((location) {
      final hasMatchingAsset = location.assets.any((asset) => matchesQuery(asset.name, query));
      final hasSubLocationWithMatchingAsset = hasMatchingAssetInSubLocations(location, query);
      final hasAssetWithSubAssetMatching =
          location.assets.any((asset) => asset.subAssets.any((subAsset) => matchesQuery(subAsset.name, query)));

      return hasMatchingAsset || hasSubLocationWithMatchingAsset || hasAssetWithSubAssetMatching;
    }).toList();
  }

  List<Asset> _filterAssetsBySearchQuery(List<Asset> assets, String query) {
    return assets.where((asset) {
      final hasMatchingSubAsset =
          asset.subAssets.any((subAsset) => subAsset.name.toLowerCase().contains(query.toLowerCase()));
      return asset.name.toLowerCase().contains(query.toLowerCase()) || hasMatchingSubAsset;
    }).toList();
  }

  List<Asset> _filterAssetsByEnergySensor(List<Asset> assets) {
    return assets.where((asset) => asset.isEnergySensor).toList();
  }

  List<Asset> _filterAssetsByCriticalSensor(List<Asset> assets) {
    return assets.where((asset) => asset.isCriticalSensor).toList();
  }

  // Loading

  void _setLocationsLoading(bool isLoading) {
    _isLocationsLoading = isLoading;
    notifyListeners();
  }

  void _setAssetsLoading(bool isLoading) {
    _isAssetsLoading = isLoading;
    notifyListeners();
  }
}
