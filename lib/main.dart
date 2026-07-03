import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/routes/routes.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:window_manager/window_manager.dart';

import 'components/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isWindows){
    await windowManager.ensureInitialized();

    windowManager.waitUntilReadyToShow(null, () async {
      // 1. Set the minimum size (Width, Height)
      // This prevents the "Login" card from ever being cut off.
      await windowManager.setMinimumSize(const Size(600, 800));

      // 2. Optional: Set a default starting size
      await windowManager.setSize(const Size(800, 700));

      // 3. Center and show
      await windowManager.center();
      await windowManager.show();
    });
  }
  await FMTCObjectBoxBackend().initialise();
  await FMTCStore('mapStore').manage.create();
  String route = await authenticateUser();

  runApp(MyApp(initialRoute: route));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        getPages: Routes.pages, initialRoute: initialRoute);
  }
}

Future<String> authenticateUser() async {
  String? accessToken = await SecureStorage().getAccessToken();
  if (accessToken == null || accessToken.isEmpty) {
    return Routes.login;
  }
  return Routes.home;
}
