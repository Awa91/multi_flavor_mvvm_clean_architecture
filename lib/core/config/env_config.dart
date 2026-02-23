//1 Environment Configuration

/// Handles compile-time variables passed via --dart-define.
/// Constants are used to allow the compiler to perform tree-shaking
/// and constant folding for better security and performance.
///
class EnvConfig {
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static const String brand = String.fromEnvironment(
    'BRAND',
    defaultValue: 'alpha',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '[https://dev-api.default.com](https://dev-api.default.com)',
  );

  // Helper getters
  static bool get isProduction => env == 'prod';
  static bool get isStaging => env == 'staging';
  static bool get isDev => env == 'dev';

  static bool get isAlpha => brand == 'alpha';
  static bool get isBeta => brand == 'beta';
}

// class EnvConfig {
//   static const String env = String.fromEnvironment(
//     'ENV',
//     defaultValue: 'dev',
//   );
//
//   static const String brand = String.fromEnvironment(
//     'BRAND',
//     defaultValue: 'alpha',
//   );
//
//   static const String apiKey = String.fromEnvironment(
//     'API_KEY',
//     defaultValue: 'https://dev-api.default.com',
//   );
//
// // Helper getters
//   static bool get isProduction => env == 'prod';
//   static bool get isStaging => env == 'staging';
//   static bool get isDev => env == 'dev';
//
//   static bool get isAlpha => brand == 'alpha';
//   static bool get isBeta => brand == 'beta';
// }
