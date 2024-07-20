import '../../../localization/localize.dart';
import '../../../support/service_locator/app_module.dart';
import '../../../support/service_locator/service_locator.dart';
import '../home_view_controller.dart';
import '../home_view_model.dart';

class HomeModule extends AppModule {
  @override
  void registerDependencies() {
    ServiceLocator.registerFactory<HomeProtocol>(() {
      return HomeViewModel(l10n: ServiceLocator.get<LocalizeProtocol>().l10n);
    });
  }
}
