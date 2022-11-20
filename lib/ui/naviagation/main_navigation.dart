import 'package:flutter/material.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';
import 'package:tmdb/ui/widgets/app/my_app.dart';

abstract class ScreenFactory {
  Widget makeSplashScreen();
  Widget makeLoader();
  Widget makeAuth();
  Widget makeMainScreen();
  Widget makeMovieDetails(int movieId);
  Widget makeMovieTrailer(String youtubeKey);
  Widget makeMovieList();
  Widget makeTVShowList();
}

class MainNavigation implements MyAppNavigation {
  final ScreenFactory screenFactory;

  const MainNavigation(this.screenFactory);

  @override
  Map<String, Widget Function(BuildContext)> get routes => {
        MainNavigationRoutesNames.splashScreen: (_) =>
            screenFactory.makeSplashScreen(),
        MainNavigationRoutesNames.loaderWidget: (_) =>
            screenFactory.makeLoader(),
        MainNavigationRoutesNames.auth: (_) => screenFactory.makeAuth(),
        MainNavigationRoutesNames.mainScreen: (_) =>
            screenFactory.makeMainScreen(),
      };

  @override
  Route<Object> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutesNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => screenFactory.makeMovieDetails(movieId),
        );
      case MainNavigationRoutesNames.movieTrailerWidget:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => screenFactory.makeMovieTrailer(youtubeKey),
        );
      default:
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}
