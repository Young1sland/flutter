import 'package:either_type/product_repository.dart';


void main(){
  fetchEitherProduct();
}

void fetchEitherProduct() async {
  try {
  final result = await ProductRepository().fetchEitherProduct(1000);
  result.fold(
    (error) => print(error),
    (product) => print(product)
  );
  } catch(e){
    print('Error: ${e.toString()}');
  }
}

