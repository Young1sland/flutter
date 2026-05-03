import 'dart:convert';

import 'package:either_type/product.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<Either<String,Product>> fetchEitherProduct(int id) async {
    try {
      final response = await http.get(Uri.https('dummyjson.com', '/products/$id'));     

      if (response.statusCode != 200) {
         throw 'Failed to fetch a product';
      } else {
        final json = jsonDecode(response.body);
        return Right(Product.fromJson(json));       
      } 
    } catch(e){
      return Left(e.toString());
    }
  }   
}