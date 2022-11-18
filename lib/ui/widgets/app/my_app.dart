import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';
import 'package:tmdb/ui/theme/app_colors.dart';

abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoutes(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;

  const MyApp({Key? key, required this.navigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return MaterialApp(
      title: 'TheMovieDB',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', ''),
      ],
      routes: navigation.routes,
      initialRoute: MainNavigationRoutesNames.loaderWidget,
      onGenerateRoute: navigation.onGenerateRoutes,
    );
  }
}
