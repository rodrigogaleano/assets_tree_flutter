import '../../../support/enums/units_enum.dart';
import '../../../support/service_locator/app_module.dart';
import '../../../support/service_locator/service_locator.dart';
import '../assets_tree_view_controller.dart';
import '../assets_tree_view_model.dart';
import '../use_cases/get_locations_use_case.dart';

class AssetsTreeModule extends AppModule {
  @override
  void registerDependencies() {
    // MARK: - Use Cases

    ServiceLocator.registerFactory<GetLocationsUseCaseProtocol>(() {
      return GetLocationsUseCase();
    });

    // MARK: AssetsViewModel

    ServiceLocator.registerFactoryParam<AssetsTreeProtocol, UnitsEnum>((unit) {
      return AssetsViewModel(
        unit: unit,
        getLocationsUseCase: ServiceLocator.get<GetLocationsUseCaseProtocol>(),
      );
    });
  }
}
