import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static Connectivity connectivity = Connectivity();

  static Future<bool> CheckNetwork() async {
    List<ConnectivityResult> connections =
        await connectivity.checkConnectivity();
    bool isConnected = connections.contains(ConnectivityResult.wifi) ||
        connections.contains(ConnectivityResult.mobile);
    return isConnected;
  }
}
