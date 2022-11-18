// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field, unused_element, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:tmdb/domain/api_client/api_client_exception.dart';
import 'package:tmdb/ui/naviagation/main_navigation_action.dart';

abstract class AuthViewModelLoginProvider {
  Future<void> login(String login, String password);
}

class AuthViewModel extends ChangeNotifier {
  final MainNavigationAction mainNavigationAction;
  final AuthViewModelLoginProvider loginProvider;

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  AuthViewModel({
    required this.mainNavigationAction,
    required this.loginProvider,
  });

  Future<String?> _login(String login, String password) async {
    try {
      await loginProvider.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return _errorMessage =
              'Сервер недоступен. Проверте подключение к интернету';
        case ApiClientExceptionType.auth:
          return _errorMessage = 'Неправильный логин или пароль';
        case ApiClientExceptionType.other:
          return _errorMessage = 'Произошла ошибка, попробуйте еще раз';
        case ApiClientExceptionType.sessionExpired:
      }
    } catch (e) {
      return 'Произошла ошибка, попробуйте еще раз';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState('Заполните логин и пароль', false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if (errorMessage == null) {
      mainNavigationAction.resetNavigation(context);
    } else {
      _updateState(errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
