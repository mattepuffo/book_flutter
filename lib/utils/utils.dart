import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// https://www.flutterbeads.com/flutter-internet-connection-checker/

class Utils {
  static String basePath = 'https://www.mattepuffo.com/api/';
  static String basePathBook = '${basePath}book/';
  static String basePathAuthor = '${basePath}author/';
  static String basePathEditor = '${basePath}editor/';

  bool isMobile() {
    if (kIsWeb) {
      return false;
    } else {
      if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
        return true;
      }
    }
    return false;
  }

  bool isDesktop() {
    if (kIsWeb) {
      return false;
    } else {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return true;
      }
    }
    return false;
  }

  Future<ConnectivityResult> checkConnetcion() async {
    final Connectivity connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    ConnectivityResult connectionStatus = result;
    return connectionStatus;
  }

  List<Color> barColors = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
  ];
}
