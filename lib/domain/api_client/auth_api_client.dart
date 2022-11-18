// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tmdb/config/configuration.dart';
import 'package:tmdb/domain/api_client/network_client.dart';

abstract class AuthApiClient {
  Future<String> auth({
    required String username,
    required String password,
  });
}

class AuthApiClientDefault implements AuthApiClient {
  final NetworkClient networkClient;

  const AuthApiClientDefault(this.networkClient);

  @override
  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await makeToken();
    final validToken = await validateUser(
      username: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<String> makeToken() async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = networkClient.get(
      '/authentication/token/new',
      parser,
      <String, dynamic>{'api_key': Configuration.apiKey},
    );
    return result;
  }

  Future<String> validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final result = networkClient.post(
      '/authentication/token/validate_with_login',
      parameters,
      parser,
      <String, dynamic>{'api_key': Configuration.apiKey},
    );
    return result;
  }

  Future<String> makeSession({
    required String requestToken,
  }) async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final result = networkClient.post(
      '/authentication/session/new',
      parameters,
      parser,
      <String, dynamic>{'api_key': Configuration.apiKey},
    );
    return result;
  }
}
