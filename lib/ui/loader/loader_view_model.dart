import 'package:flutter/cupertino.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';

abstract class LoaderViewModelAuthStatusProvider {
  Future<bool> isAuth();
}

class LoaderViewModel {
  final BuildContext context;
  final LoaderViewModelAuthStatusProvider authStatusProvider;

  LoaderViewModel({
    required this.context,
    required this.authStatusProvider,
  }) {
    asyncInit();
  }
  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth = await authStatusProvider.isAuth();
    final nextScreen = isAuth
        ? MainNavigationRoutesNames.mainScreen
        : MainNavigationRoutesNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
