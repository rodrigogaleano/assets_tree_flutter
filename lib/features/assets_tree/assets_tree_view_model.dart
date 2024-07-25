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
    // final filteredLocations = _locations.where((location) {
    //   return location.name.toLowerCase().contains(_searchQuery.toLowerCase());
    // }).toList();

    if (_selectedFilter == 1) {
      final filteredLocations = _locations.where((location) {
        final temAssetEnergia = location.assets.any((asset) => asset.isEnergySensor);

        final temSubLocationComAssetEnergia = location.subLocations.any((subLocation) {
          return subLocation.assets.any((asset) => asset.isEnergySensor);
        });

        final temAssetComSubAssetEnergia = location.assets.any((asset) {
          return asset.subAssets.any((subAsset) => subAsset.isEnergySensor);
        });

        return temAssetEnergia || temSubLocationComAssetEnergia || temAssetComSubAssetEnergia;
      });

      return filteredLocations.map((location) {
        return LocationTileViewModel(
          location: location,
          filterOption: _selectedFilter,
        );
      }).toList();
    }

    if (_selectedFilter == 2) {
      return _locations.where((location) {
        final temAssetCritico = location.assets.any((asset) => asset.isCriticalSensor);

        // Verifica se alguma subLocation tem um Asset com isCriticalSensor como true
        final temSubLocationComAssetCritico = location.subLocations.any((subLocation) {
          return subLocation.assets.any((asset) => asset.isCriticalSensor);
        });

        // Verifica se algum Asset tem um subAsset com isCriticalSensor como true
        final temAssetComSubAssetCritico = location.assets.any((asset) {
          return asset.subAssets.any((subAsset) => subAsset.isCriticalSensor);
        });

        // Retorna true se qualquer uma das condições acima for verdadeira
        return temAssetCritico || temSubLocationComAssetCritico || temAssetComSubAssetCritico;
      }).map((location) {
        return LocationTileViewModel(
          location: location,
          filterOption: _selectedFilter,
        );
      }).toList();
    }

    return _locations.map((location) {
      return LocationTileViewModel(
        location: location,
        filterOption: _selectedFilter,
      );
    }).toList();
  }

  @override
  List<AssetTileViewModelProtocol> get unlinkedAssetsViewModels {
    final unlinkedAssets = _assets.where((asset) {
      return asset.locationId == null && asset.parentId == null;
    }).toList();

    if (_selectedFilter == 1) {
      return unlinkedAssets.where((asset) {
        return asset.isEnergySensor;
      }).map((asset) {
        return AssetTileViewModel(asset: asset, filterOption: _selectedFilter);
      }).toList();
    }

    if (_selectedFilter == 2) {
      return unlinkedAssets.where((asset) {
        return asset.isCriticalSensor;
      }).map((asset) {
        return AssetTileViewModel(asset: asset, filterOption: _selectedFilter);
      }).toList();
    }

    return unlinkedAssets.map((asset) {
      return AssetTileViewModel(asset: asset, filterOption: _selectedFilter);
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
