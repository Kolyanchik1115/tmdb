// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tmdb/domain/api_client/account_api_client.dart';
import 'package:tmdb/domain/api_client/auth_api_client.dart';
import 'package:tmdb/domain/data_providers/session_data_provider.dart';
import 'package:tmdb/ui/loader/loader_view_model.dart';
import 'package:tmdb/ui/widgets/auth/auth_model.dart';
import 'package:tmdb/ui/widgets/movie_details/movie_details_model.dart';

class AuthService
    implements
        AuthViewModelLoginProvider,
        LoaderViewModelAuthStatusProvider,
        MovieDetailsModelLogoutProvider {
  final AccountApiClient accountApiClient;
  final SessionDataProvider sessionDataProvider;
  final AuthApiClient authApiClient;

  const AuthService({
    required this.accountApiClient,
    required this.sessionDataProvider,
    required this.authApiClient,
  });

  @override
  Future<bool> isAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  @override
  Future<void> login(String login, String password) async {
    final sessionId = await authApiClient.auth(
      username: login,
      password: password,
    );
    final accountId = await accountApiClient.getAccountInfo(sessionId);
    await sessionDataProvider.setSessionId(sessionId);
    await sessionDataProvider.setAccountId(accountId);
  }

  @override
  Future<void> logout() async {
    await sessionDataProvider.deleteSessionId();
    await sessionDataProvider.deleteAccountId();
  }
}
