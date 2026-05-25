import 'package:equatable/equatable.dart';

import '../errors/failures.dart';
import 'package:fpdart/fpdart.dart';

//UseCase 추상 인터페이스. 모든 UseCase 구조를 통일
abstract interface class UseCase<ReturnType, ParamsType> {
  //UseCase<ReturnType, ParamsType> 출력, 입력 Generic Type
  //call() dart 특수 메소드. 객체를 useCase(params)처럼 함수처럼 호출 가능하게 함
  Future<Either<Failure, ReturnType>> call(ParamsType params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
