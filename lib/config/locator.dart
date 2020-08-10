import 'package:get_it/get_it.dart';
import 'package:try_notification_2/services/navigationService.dart';

import '../notification.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => PushNotificationService());
}
