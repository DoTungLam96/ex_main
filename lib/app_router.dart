import 'package:ex_module_core/ex_module_core.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Constants.homePage:
      String? data;
      if (settings.arguments is String?) {
        data = settings.arguments as String?;
      }
      return getPageRoute(HomePage(args: data), settings);

    default:
      return ModuleManagement().onGenerateRoute(settings);
  }
}
