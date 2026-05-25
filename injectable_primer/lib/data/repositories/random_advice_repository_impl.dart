import 'package:injectable/injectable.dart';

import '../../domain/repositories/random_advice_repository.dart';
import '../datasources/api_service.dart';

@LazySingleton(as: RandomAdviceRepository)
class RandomAdviceRepositoryImpl implements RandomAdviceRepository {
  RandomAdviceRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<String> getRandomAdvice() async {
    return await _apiService.getRandomAdvice();
  }
}
