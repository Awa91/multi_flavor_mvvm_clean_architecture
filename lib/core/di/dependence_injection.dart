import 'package:get_it/get_it.dart';

import '../../features/font/connective_repository.dart';
import '../../features/font/font_view_model.dart';
import '../../features/invoice/data/repositories/invoice_repository.dart';
import '../../features/invoice/presentation/view_models/invoice_view_model.dart';

final locator = GetIt.instance;

// void setupLocator() {
//   locator.registerLazySingleton(() => ConnectivityRepository());
//   locator.registerFactory(() => FontViewModel(locator<ConnectivityRepository>()));
// }

/// Sets up the service locator for dependency injection.
///
/// [mockRepo] can be passed during unit or widget testing to override
/// the default production repository.
void setupLocator({InvoiceRepository? mockRepo}) {
  // Clear existing registrations if any (useful for testing resets)
  locator.reset();

  // --- Data Layer ---
  locator.registerLazySingleton(() => ConnectivityRepository());

  // Register the mock if provided, otherwise register the production repository
  locator.registerLazySingleton(() => mockRepo ?? InvoiceRepository());

  // --- Presentation Layer (ViewModels) ---

  // FontViewModel is a LazySingleton because it manages global app state (WiFi/Fonts)
  locator.registerLazySingleton(
      () => FontViewModel(locator<ConnectivityRepository>()));

  // InvoiceViewModel is registered as a Factory because we usually want a
  // fresh instance when entering the Invoice screen or to allow manual disposal.
  locator.registerFactory(() => InvoiceViewModel(locator<InvoiceRepository>()));
}
