import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'connective_repository.dart';



class FontViewModel extends ChangeNotifier {
  final ConnectivityRepository _repository;
  bool _isWifi = false;
  bool _isLoading = true;
  late final Future<void> initializationDone;

  bool get isWifi => _isWifi;
  bool get isLoading => _isLoading;

  FontViewModel(this._repository) {
    initializationDone = _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final initialStatus = await _repository.isCurrentlyOnWifi();
      _isWifi = initialStatus;
    } catch (e) {
      _isWifi = false;
    } finally {
      _isLoading = false;
      GoogleFonts.config.allowRuntimeFetching = _isWifi;
      notifyListeners();
    }

    _repository.onWifiStream.listen(_updateWifiStatus);
  }

  void _updateWifiStatus(bool status) {
    if (_isWifi != status) {
      _isWifi = status;
      GoogleFonts.config.allowRuntimeFetching = _isWifi;
      notifyListeners();
    }
  }
}