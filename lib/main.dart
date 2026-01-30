import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/routes/routes.dart';

import 'components/secure_storage.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
String route = await authenticateUser();

  runApp( MyApp(initialRoute: route));

}

class MyApp extends StatelessWidget{
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: Routes.pages,
      initialRoute:  initialRoute,
    );
  }
}

Future<String> authenticateUser() async {
  String? accessToken = await SecureStorage().getAccessToken();
  if(accessToken==null || accessToken.isEmpty){
  return Routes.login;
  }
  return Routes.home;
}