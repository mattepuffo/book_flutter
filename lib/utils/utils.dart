import 'dart:io' show Platform;

import 'package:connectivity_plus/connectivity_plus.dart';

// https://www.flutterbeads.com/flutter-internet-connection-checker/

class Utils {
  static String basePath = 'https://www.mattepuffo.com/api/';
  static String basePathBook = '${basePath}book/';
  static String basePathAuthor = '${basePath}author/';
  static String basePathEditor = '${basePath}editor/';

   bool isMobile() {
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      return true;
    }
    return false;
  }

  Future<void> checkConnetcion() async {
    final Connectivity connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    ConnectivityResult connectionStatus = result;
    print(connectionStatus);
  }
}
