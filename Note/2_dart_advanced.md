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

## string 입력

인접한 문자열 leteral 자동 연결 됨. 가독성을 위해 자주 쓰임

```dart
super.message =
    'Network connection failed. '
    'Please check your internet connection';

실제로 저장되는 값은:
=> Network connection failed. Please check your internet connection

```

### map & where & asyncMap

```dart
//map
final numbers = [1, 2, 3];

final result = numbers.map((n) {
  return n * 2;
});

print(result);


//where: 필터링
final nums = [1, 2, 3, 4];
final even = nums.where((e) => e % 2 == 0);
//first, last는 Iterable<T>에 있는 프로퍼티. 각각 처음과 마지막을 가져온다.
print(even.first); //2
print(even.last) //4


//map: 데이터가 하나인경우에도 변환을 위해 사용되기도 한다.
stream.map((x) => x * 2)
asyncMap

//asyncMap: 비동기 변환
stream.asyncMap((x) async {
  return await api(x);
})
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
<https://pub.dev/packages/equatable>

```sh
dart pub add equatable
```

 `List<Object> get props`의 리스트에 들어간 값들 기준으로 비교함

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

//fold는 두 경우에 대해 값을 리턴하고자 할 때
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

## getter/setter

함수인데 변수처럼 접근가능하게 해주는 문법

### 1. Getter/Setter

```dart
class User {
  String _name = ''; //앞에 _ 붙으면 private field

  String get name => _name;

  set name(String value) {
    _name = value.trim();
  }
}

final user = User();

user.name = ' Gildong ';

print(user.name); //property처럼 사용 가능

```

- 변수 이름 앞에 `_`붙이면 자동으로 private field가 됨.
- dart에서 private의 기준은 class가 아니라 파일 기준으로 같은 파일안에서는 접근 가능

### 2. getter/setter 쓰는 이유

#### 1) 캡슐화

직접 접근 막고 로직 추가 가능.

#### 2) validation

```dart
set age(int value) {
  if (value < 0) {
    throw Exception();
  }

  _age = value;
}
```

#### 3) readonly property

getter만 만들면 읽기 전용. setter 없으면 수정 불가.

## getIt

Service Locator. 객체를 등록하고 찾아오는 방식

```dart

//보통 configure.dart/setup.dart/init.dart/di.dart 이름 사용
final getIt = GetIt.instance;

void configure(){
  //registerSingleton : 앱 전체에서 하나만 생성. 등록 즉시 생성
  getIt.registerSingleton<ApiService>(
  ApiService());

  //registerLazySingleton : 처음 요청 시 생성
  getIt.registerLazySingleton<ApiService1>(
  () => ApiService1());

  getIt.registerLazySingleton<Repository>(
  () => Repository(getIt<ApiService>()));

  // registerFactory: 매번 새 객체 생성
  getIt.registerFactory<AuthBloc>(
  () => AuthBloc());
  getIt.registerFactory<MyCubit>(
  () => MyCubit(getIt<Repository>));

}

void main() {
  configure();
  runApp(MyApp());
}

//When accessing dependencies
final myCubit = getIt<MyCubit>();


```

## injectable

injectable은 getIt 등록 코드를 code generation을 통해 자동으로 생성해주는 패키지  
개발자는 @injectable, @singleton, @lazySingleton 등의 annotation만 붙여주면 됨

|getIt Method|injectable Annotation|Annotation Type Comparison|
|--|--|--|
|registerSingleton|@singleton|@singleton == @Singleton()|
|registerLazySingleton|@lazySingleton|@lazySingleton == @LazySingleton()|
|registerFactory|@injectable|@injectable = @Injectable|

- flutter/dart annotation은 lowercase shorthand을 제공해 짧게 쓸 수 있게 해뒀다. @injectable도 되고 @Injectable()도 되고 둘은 같다.

### 1. Injectable의 `as` parameter를 사용한 느슨한 결합(Loose Coupling)

Clean Architecture에서는 구현체에 의존하지 말고 추상화(interface)에 의존  
구현체에 의존하지 않고 뭔지 몰라도 되도록 함.

```dart

//인터페이스 추상화 클래스. 이런 기능을 구현해야 한다를 정의
abstract class MyRepository {}
//구현체. 실제 구현.
class MyRepositoryImpl implements MyRepository {}
class MockRepository implements MyRepository {}

//MyRepository 타입 요청 시 MyRepositoryImpl을 주입하라는 뜻
@LazySingleton(as: MyRepository)
class MyRepositoryImpl implements MyRepository {}


class LoginUseCase {
  final MyRepository repository;

  LoginUseCase(this.repository);
}
```

```dart
이 경우
@LazySingleton(as: MyRepository)
class MyRepositoryImpl implements MyRepository {}

=> injectable에 의해 대충 이런 코드 생성됨

getIt.registerLazySingleton<MyRepository>(
  () => MyRepositoryImpl(),
);

즉 실제 사용은
final repo = getIt<MyRepository>();

해도, 실제로는 MyRepositoryImpl instance 반환됨.


as: MyRepository 안 쓰면 injectable은 MyRepositoryImpl 타입으로만 등록함.
즉, getIt<MyRepositoryImpl>()만 가능.
```

### 2. @module

외부 객체(external dependency)를 DI에 등록하기 위한 annotation.

- @injectable은 constructor 생성 가능한 클래스를 자동 등록함.
- 그러나 supabase.instance.client처럼 생성자를 직접 호출하지 않는 외부 SDK 관리 객체는 @module로 수동 등록

```dart
//@module : 이 클래스 안의 getter/provider들을 DI 등록 대상으로 사용해라
@module
abstract class RegisterModule {

  @singleton //실제 lifecycle 결정 singleton
  SupabaseClient get supabaseClient =>
      Supabase.instance.client;
}
```

## constructor forwarding 문법

부모 constructor의 parameter를 자동으로 forwarding하는 최신 Dart 축약 문법

```dart
abstract class Failures {
  Failures({
    required this.message,
  });
  //Failures({ required String message}) : message=message;의 축약 형태

  final String message;
}


class ServerFailure extends Failures {
  ServerFailure({
    required super.message,
  });
}

=> 하기와 같으며 Dart 축약 문법
class ServerFailure extends Failures {
  ServerFailure({
    required String message,
  }) : super(message: message);
}

//호출
ServerFailure(
  message: 'Server error',
)
```

## Stream

시간이 지나면서 여러 개의 값을 전달하는 비동기 데이터 흐름

- `Future<String>`: 결과 1번만 전달, 예) API 요청 결과. 파일 읽기 완료
- `Stream<String>`: 값을 여러 번 계속 전달 예) 채팅 메시지, 로그인 상태 변화, 주식 가격

### 예시1

```dart
Stream<int> numbers() async* {
  yield 1;
  yield 2;
  yield 3;
}

void main() async {
  await for (final n in numbers()) {
    print(n);
  }
}
//출력
1
2
3

```

- async* : Stream 만드는 함수
- yield : 값 하나 stream으로 내보냄

### 예시2

```dart
Stream<int> stockPrice() async* {
  yield 1000;

  await Future.delayed(
    Duration(seconds: 1),
  );

  yield 1010;

  await Future.delayed(
    Duration(seconds: 1),
  );

  yield 980;
}

사용:

stockPrice().listen((price) {
  print(price);
});

출력:

1000
1010
980
```

- listen 의미: 값 올 때마다 실행

## factory 생성자

factory는 Dart에서 사용하는 팩토리 생성자(factory constructor). 객체를 생성하는 특별한 생성자.

### 1. 일반 생성자 vs factory 생성자

```dart
일반 생성자
class User {
  final String name;

  User(this.name);
}


factory 생성자
factory User.fromJson(Map<String, dynamic> json) {
  return User(json['name']);
}
```

- 객체를 가공해서 만들 수 있음
- 다른 객체를 반환 가능하며 기존 객체 재사용 가능
- 생성 전에 로직 수행 가능

```dart
//예시
//Supabase SDK의 User 객체를 앱 내부에서 사용하는 UserModel로 변환
factory UserModel.fromSUpabaseUser(User user) {}
```

## try on catch

```dart
try {
  // 에러 발생 가능 코드
}
on ExceptionType catch (e) {
  // ExceptionType의 특정 타입 에러만 잡아 처리
}
catch (e) {
  // 그 외 모든 에러 처리
}
finally {
  // 성공/실패 상관없이 항상 실행
}
```

예시1

```dart
try {
  // 코드
}
on FormatException {
  print('형식 오류');
}
on TimeoutException {
  print('시간 초과');
}
catch (e) {
  print('기타 에러: $e');
}

```

예시2

```dart
try {
  await api.login();
}
on AuthException catch (e) {
  throw AuthenticationException(message: e.message);
}
catch (e) {
  throw Exception('알 수 없는 오류');
}
finally {
  loading = false;
}
```

- AuthException 예외 발생하면 AuthenticationException 예외 throw
