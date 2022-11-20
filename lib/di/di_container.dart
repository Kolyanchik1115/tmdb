import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/domain/api_client/account_api_client.dart';
import 'package:tmdb/domain/api_client/auth_api_client.dart';
import 'package:tmdb/domain/api_client/movie_api_client.dart';
import 'package:tmdb/domain/api_client/network_client.dart';
import 'package:tmdb/domain/data_providers/session_data_provider.dart';
import 'package:tmdb/domain/library/app_http_client.dart';
import 'package:tmdb/domain/library/secure_storage.dart';
import 'package:tmdb/domain/services/auth_service.dart';
import 'package:tmdb/domain/services/movie_service.dart';
import 'package:tmdb/main.dart';
import 'package:tmdb/ui/loader/loader_view_model.dart';
import 'package:tmdb/ui/loader/loader_widget.dart';
import 'package:tmdb/ui/naviagation/main_navigation.dart';
import 'package:tmdb/ui/naviagation/main_navigation_action.dart';
import 'package:tmdb/ui/widgets/app/my_app.dart';
import 'package:tmdb/ui/widgets/auth/auth_model.dart';
import 'package:tmdb/ui/widgets/auth/auth_widget.dart';
import 'package:tmdb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:tmdb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:tmdb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:tmdb/ui/widgets/movie_list/movie_list_%20model.dart';
import 'package:tmdb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:tmdb/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:tmdb/ui/widgets/splash/splash_screen.dart';

AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = _DiContainer();

  _AppFactoryDefault();
  @override
  Widget makeApp() => MyApp(navigation: _diContainer._makeMyAppNavigation());
}

class _DiContainer {
  _DiContainer();

  //global
  final _mainNavigationAction = const MainNavigationAction();
  final SecureStorage _secureStorage = const SecureStorageDefault();
  final AppHttpClient _httpClient = AppHttpClientDefault();

  //not global

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);

  MyAppNavigation _makeMyAppNavigation() =>
      MainNavigation(_makeScreenFactory());

  SessionDataProvider _makeSessionDataProvider() =>
      SessionDataProviderDefault(_secureStorage);

  NetworkClient _makeNetworkClient() => NetworkClientDefault(_httpClient);

  AccountApiClient _makeAccountApiClient() =>
      AccountApiClientDefault(_makeNetworkClient());

  AuthApiClient _makeAuthApiClient() =>
      AuthApiClientDefault(_makeNetworkClient());

  AuthService _makeAuthService() => AuthService(
        accountApiClient: _makeAccountApiClient(),
        authApiClient: _makeAuthApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );

  MovieApiClient _makeMovieApiClient() =>
      MovieApiClientDefault(_makeNetworkClient());

  MovieService _makeMovieService() => MovieService(
        accountApiClient: _makeAccountApiClient(),
        movieApiClient: _makeMovieApiClient(),
        sessionDataProvider: _makeSessionDataProvider(),
      );

  AuthViewModel _makeAuthViewModel() => AuthViewModel(
        mainNavigationAction: _mainNavigationAction,
        loginProvider: _makeAuthService(),
      );

  LoaderViewModel makeLoaderViewModel(BuildContext context) => LoaderViewModel(
        authStatusProvider: _makeAuthService(),
        context: context,
      );

  MovieDetailsModel makeMovieDetailsModel(int movieId) => MovieDetailsModel(
        movieId,
        navigationAction: _mainNavigationAction,
        logoutProvider: _makeAuthService(),
        movieProvider: _makeMovieService(),
      );

  MovieListViewModel makeMovieListViewModel() =>
      MovieListViewModel(_makeMovieService());
}

//factory
class ScreenFactoryDefault implements ScreenFactory {
  final _DiContainer _diContainer;
  const ScreenFactoryDefault(
    this._diContainer,
  );
  @override
  Widget makeSplashScreen() {
    return SplashWidget(
      navigationAction: _diContainer._mainNavigationAction,
    );
  }

  @override
  Widget makeLoader() {
    return Provider(
      create: (context) => _diContainer.makeLoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  @override
  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeAuthViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget makeMainScreen() {
    return MainScreenWidget(
      screenFactory: this,
      sessionDataProvider: _diContainer._makeSessionDataProvider(),
      navigationAction: _diContainer._mainNavigationAction,
    );
  }

  @override
  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer.makeMovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  @override
  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(
      youtubeKey: youtubeKey,
    );
  }

  @override
  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer.makeMovieListViewModel(),
      child: const MovieListWidget(),
    );
  }
}
