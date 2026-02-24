import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onWifiStream => _connectivity.onConnectivityChanged.map(
    (results) => results.contains(ConnectivityResult.wifi),
  );

  Future<bool> isCurrentlyOnWifi() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }
}
