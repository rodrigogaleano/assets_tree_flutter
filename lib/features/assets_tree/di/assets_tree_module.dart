import '../../../support/service_locator/app_module.dart';
import '../../../support/service_locator/service_locator.dart';
import '../assets_tree_view_controller.dart';
import '../assets_view_model.dart';

class AssetsTreeModule extends AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<AssetsTreeProtocol>(() {
      return AssetsViewModel();
    });
  }
}
