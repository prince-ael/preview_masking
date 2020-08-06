import 'package:camera_preview_overlay/camera_notifiers.dart';
import 'package:camera_preview_overlay/route_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'landing_screen.dart';

class RouteConfig {
  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.landingScreen:
        return loginScreen();
      default:
        return undefinedRoute(settings.name);
    }
  }

  MaterialPageRoute loginScreen() {
    return MaterialPageRoute(
      settings: RouteSettings(name: RouteNames.landingScreen),
      builder: (context) => MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => CameraNotifier())],
        child: LandingScreen(),
      ),
    );
  }

  MaterialPageRoute undefinedRoute(String routeName) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text("No Route Defined for $routeName"),
          ),
        ),
      );
}
