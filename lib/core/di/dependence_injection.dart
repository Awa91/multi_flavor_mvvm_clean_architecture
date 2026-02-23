import 'package:get_it/get_it.dart';

import '../../features/font/connective_repository.dart';
import '../../features/font/font_view_model.dart';
import '../../features/invoice/data/repositories/invoice_repository.dart';
import '../../features/invoice/presentation/view_models/invoice_view_model.dart';

final locator = GetIt.instance;

/// Sets up the service locator for dependency injection.
/// [mockRepo] can be passed during unit or widget testing to override
/// the default production repository.
void setupLocator({InvoiceRepository? mockRepo}) {
  // Clear existing registrations if any
  locator.reset();

  // --- Data Layer ---
  locator.registerLazySingleton(() => ConnectivityRepository());

  // Register mock if provided, otherwise production repo
  locator.registerLazySingleton(() => mockRepo ?? InvoiceRepository());

  // --- Presentation Layer (ViewModels) ---
  locator.registerLazySingleton(
    () => FontViewModel(locator<ConnectivityRepository>()),
  );

  locator.registerFactory(
    () => InvoiceViewModel(locator<InvoiceRepository>()),
  );
}
