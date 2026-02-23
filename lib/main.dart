import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'core/di/dependence_injection.dart';

void main() {
  // Ensure framework is ready before accessing --dart-define variables
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(const MainApp());
}
