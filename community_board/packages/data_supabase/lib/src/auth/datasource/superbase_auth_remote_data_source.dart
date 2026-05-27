import 'dart:io';

import 'package:core/errors.dart';
import 'package:core/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseAuthRemoteDataSource({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;
  final SupabaseClient _supabaseClient;

  @override
  Stream<UserModel?> get onAuthStateChaned {
    return _supabaseClient.auth.onAuthStateChange.map((AuthState state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSUpabaseUser(user);
    });
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'role': Roles.user},
      );

      final User? user = response.user;

      if (user == null) {
        throw const AuthenticationException(
          message:
              'Registration was successful, '
              'but user information could not be retreived. (User is null)',
        );
      }
      return UserModel.fromSUpabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occured while signup: ${e.toString()}',
      );
    }
    //AuthException인 예외만 잡아서 catch. 다시 throw throw AuthenticationException(message: e.message); 이렇게 하는 이유는 clean architecture 때문으로 외부 라이브러리 예외를 앱 전체에 퍼뜨리지 않으려고.
    // 그 외 AuthenticationException면 rethrow, SocketException이면 NetworkException throw, 그 외 UnknownException
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);
      final User? user = response.user;

      if (user == null) {
        throw const AuthenticationException(
          message:
              'Sign in was successful, '
              'but user information could not be retrieved. (User is null)',
        );
      }
      return UserModel.fromSUpabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message:
            'An unexpected error occured while logging in: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownException(
        message:
            'An unexpected error occured while logging out: ${e.toString()}',
      );
    }
  }
}
