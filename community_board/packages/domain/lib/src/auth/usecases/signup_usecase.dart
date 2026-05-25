import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/repositories.dart';

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });
  final String email;
  final String password;
  final String username;

  @override
  List<Object> get props => [email, password, username];
}

class SignupUseCase implements UseCase<void, SignUpParams> {
  SignupUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await _authRepository.signup(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}
