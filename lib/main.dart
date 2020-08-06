import 'package:camera_preview_overlay/route_config.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routeConfig = RouteConfig();

    return MaterialApp(
      title: 'Camera Preview Overlay',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routeConfig.routes,
    );
  }
}
