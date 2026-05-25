import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object> get props => [message]; //equable에 의해 두 Failure 객체의 message가 같으면 같은 걸로 취급

  @override
  String toString() => '${runtimeType.toString()}: $message';
  //runtimeType: 현재 객체의 실제 타입. => 'Failure' 이렇게도 됨. interpolation 시 자동 toString 호출 됨 '$runtimeType: $message'
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Please check your connection...'});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission for the request.',
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'The data requested not found'});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error has occured. Please try again later.',
  });
}
