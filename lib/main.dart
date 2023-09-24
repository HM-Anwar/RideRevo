import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/helper/init_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'views/theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: LightTheme().theme,
      initialRoute: RouteHelper.getInitialRoute,
      getPages: RouteHelper.routes,
      onInit: Controllers.initialize ,
      transitionDuration: const Duration(milliseconds: 0),
      title: 'Ride Revo',
    );
  }
}
