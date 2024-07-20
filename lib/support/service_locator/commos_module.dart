import '../../localization/localize.dart';
import 'app_module.dart';
import 'service_locator.dart';

class CommonsModule extends AppModule {
  @override
  void registerDependencies() {
    // MARK: - Singletons

    ServiceLocator.registerSingleton<LocalizeProtocol>(Localize.instance);
  }
}
