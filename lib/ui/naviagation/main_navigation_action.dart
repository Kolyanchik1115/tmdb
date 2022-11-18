import 'package:flutter/cupertino.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';

class MainNavigationAction {
  const MainNavigationAction();

  void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRoutesNames.loaderWidget,
      (route) => false,
    );
  }
}
