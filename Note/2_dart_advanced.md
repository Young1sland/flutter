# Dart

## parameter

### 1. 기본: positional parameter (위치 기반 파라미터)
순서대로 들어감. 기본적으로 모두 필수(required)
```dart
void add(a, b) {
  print(a + b);
}

add(10, 5); // OK
add(10);    // ❌ 에러 (b 없음)
```

### 2. optional positional parameter ([])
[]로 감싸면 선택값(optional) 됨. 값 안 넣으면 자동으로 기본값 사용

```dart
void add(a, [b]) {
  print(a + b);
}

add(10);     // b = null
add(10, 5);  // b = 5


void add1(a, [b = 5]) {
  print(a + b);
}

add1(10);     // 10 + 5
add1(10, 6);  // 10 + 6
```

### 3. named parameter ({})
순서 상관 없음. 이름으로 전달해야 함
```dart
void add({a, b = 5}) {
  print(a + b);
}

add(b: 10); // a = null, b = 10
```

### 4. required named parameter
반드시 넣어야 함
```dart
void add({required a, required b}) {
  print(a + b);
}

add(a: 10, b: 5); // OK
add(a: 10);       // ❌ 에러
```

### 5. 실전 포인트
실전에서는 named parameter를 표준처럼 사용
```dart
void createUser({
  required String name,
  int age = 20,
}) {}
```

## const
- 컴파일 타임에 생성됨. immutable (절대 변경 불가). 같은 값이면 동일 객체(shared instance)
- Flutter는 UI를 계속 rebuild 하는 구조이기 때문에 const 없으면 build 때마다 객체 새로 생성하여 성능 낭비
- const 있으면 이미 만들어진 객체 재사용하여 rebuild 비용 감소
```dart
//a와 b는 같은 객체 (== true)
const a = Text('hello');
const b = Text('hello');

// 서로 다른 객체 (매번 새로 생성됨)
final a = Text('hello');
final b = Text('hello');
```

## const constructor와 class 비교
- 해당 클래스는 “컴파일 타임에 생성 가능한 불변 객체”가 된다. 모든 필드가 immutable이어야 const 가능
- dart는 메모리의 주소가 다르면 다른 객체로 인식하는데 const로 생성되면 같다.
```dart
class MyWidget {
  const MyWidget();
}
const a = MyWidget();
const b = MyWidget();
print('${a.hashCode} / ${b.hashCode}') //같음

//const 생성자 가능
class Person {
  final String name;

  const Person(this.name);
}

//const 생성자 불가능
class Test {
  int count; // ❌ mutable

  const Test(this.count); // 에러
}
```
- mutable한 값이 존재하여 const 생성자 사용 불가한 경우 필드값이 같을 때 같다고 정의하도록 ==와 hashCode 구하는 함수를 override한다.
- dart class generator extension을 사용하면 쉽게 생성 가능
```dart
class Person {
  Person({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Person &&
      other.id == id &&
      other.name == name &&
      other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}

```

### Equatable
==,hashCode override 없이 Dart에서 객체 비교를 값 기준으로 쉽게 해주는 라이브러리
https://pub.dev/packages/equatable
```sh
dart pub add equatable
```
 List<Object> get props의 리스트에 들어간 값들 기준으로 비교함
```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;

  const User(this.name);

  @override
  List<Object> get props => [name]; // name 기준으로 비교
}
void main() {
  final a = User('kim');
  final b = User('kim');

  print(a == b); // ✅ true
}

```

## Dot Shorthand Syntax (Dart 3.10+)
이미 타입이 명확한 문맥에서는 클래스 이름을 반복하지 않고 .으로 시작하는 생성자 또는 static 메서드 호출을 허용
Dart 3.10부터 dot shorthand syntax가 기본 활성화

```dart
//3.9 이하
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
  ),
),

//3.10 이상 dotshorthand 적용
theme: ThemeData(
  colorScheme: .fromSeed(
    seedColor: Colors.deepPurple,
  ),
),
```

## Callable Classes
```dart
import 'dart:math';

void main(){
  print(mayBeFun?.call(1));
}

String Function(int) fun = (n) => '$n';
String Function(int)? mayBeFun = Random().nextBool() ? fun : null;
```
- dart에서는 함수가 객체이다.
  fun(1)은 사실 내부적으로 fun.call(1) 이렇게 호출함.
- dart에서 하기와 같이 접근하며 둘을 동시에 쓰는 것이 허용되지 않으므로 mayBeFun?.(1)이 아니라 mayBeFun?.call(1) 이렇게 호출한다.
  - ?. → 메서드 / 프로퍼티 접근용
  - () → 함수 호출 문법

```dart
void main(){
  final callableClass = CallableClass();
  callableClass('minsu'); //Hello minsu
}

class CallableClass {
  void call(String name){
    print('Hello ${name}');
  }
}

```
- Callable Class : class가 call메소드가 있다면 dart는 그 클래스의 인스턴스를 function처럼 사용할 수 있게 해준다. 

## Code Generation (코드 생성) + JSON Serialization
json_serializable과 build_runner를 사용해 JSON ↔ 객체 변환 코드를 자동 생성하는 패턴

### 핵심 구성 요소
- Annotation: 이 클래스는 코드 생성 대상이다고 표시
  ```dart
  @JsonSerializable()
  ```
- Factory Constructor (직접 작성) : 자동 생성된 함수와 연결하는 인터페이스
  ```dart
  factory Product.fromJson(Map<String, dynamic> json)
  => _$ProductFromJson(json);
  ```
- part 키워드: 이 파일에 생성 코드가 연결 됨
  ```dart
  part 'product.g.dart';
  ```
- build_runner
  ```sh
  # 코드 자동 생성 실행
  dart run build_runner build -d
  ```
### 예시
product.dart
```dart
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart'; //생성될 코드 위치

@JsonSerializable(createToJson: false) //fromJson만 만들고 ToJson은 만들지 않음
class Product {
  final int id;
  final String title;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  String toString() => 'Product(id: $id, title: $title, description: $description)';
}
```

product.g.dart: 자동 생성된 코드
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
);

```

## Either
성공 또는 실패를 타입으로 표현
- Either<Error, Data> 
- Left → 보통 에러/실패, Right → 보통 성공/정상값
- fpdart 설치 필요

### fpdart
Dart에서 함수형 프로그래밍(Functional Programming)을 쉽게 쓰게 해주는 라이브러리
```sh
# 설치
dart pub add fpdart
```
fpdart 쓰면 에러/성공을 명확하게 분리
- match: 행동 실행
- fold: 값을 리턴

```dart
Either<String, int> divide(int a, int b) {
  if (b == 0) {
    return Left("division by zero");
  }
  return Right(a ~/ b);
}

Either<String, int> result = divide(10, 2);

//match는 두 경우에 대해 어떤 행동을 실행하고자 할 때 사용
result.match(
  (error) => print('Error: $error'),
  (value) => print('Result: $value'),
);  

//fold는 두 경에 대해 값을 리턴하고자 할 때
final text = result.fold(
  (error) => 'Error: $error',
  (value) => 'Value: $value',
);
print(text);
```
### 예시
```dart
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

/* 
......
......
......
*/

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

```