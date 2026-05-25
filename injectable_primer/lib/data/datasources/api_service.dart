import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@singleton
class ApiService {
  //client를 외부에서 주입받으면 MockClient 주입 등 테스트에 용이. Flexibility, Resuability
  ApiService({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<String> getRandomAdvice() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.adviceslip.com/advice'),
      );

      final responseBody = jsonDecode(response.body);
      return responseBody['slip']['advice'];
    } catch (e) {
      rethrow;
    }
  }
}
