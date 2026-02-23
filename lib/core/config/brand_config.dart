//2 Brand Strategy

import 'package:flutter/material.dart';
import '../theme/alpha_theme.dart';
import '../theme/beta_theme.dart';
import 'env_config.dart';

/// Orchestrates which theme and brand assets to use based on the BRAND define.
class BrandConfig {
  final String appTitle;
  final ThemeData themeData;
  final String logoPath;
  final String fontName; // Use the font name as a string

  BrandConfig({
    required this.appTitle,
    required this.themeData,
    required this.logoPath,
    required this.fontName,

  });

  factory BrandConfig.current() {
    switch (EnvConfig.brand) {
      case 'beta':
        return BrandConfig(
          appTitle: 'Beta Professional ${EnvConfig.env.toUpperCase()}',
          themeData: BetaTheme.dark,
          logoPath: 'assets/current_brand/logo.png',
          fontName: 'Montserrat',

        );
      case 'alpha':
      default:
        return BrandConfig(
          appTitle: 'Alpha Creative ${EnvConfig.env.toUpperCase()}',
          themeData: AlphaTheme.light,
          logoPath: 'assets/current_brand/logo.png',
          fontName: 'Poppins',
        );
    }
  }
}
