### Defining a Function
```dart
String sayHello(String name) {
  return "Hello $name nice to meet you!";
}
//람다식
String sayHello(String name) => "Hello $name nice to meet you!";
num plus(num a, num b) => a + b;

void main() {
  print(sayHello('nico'));
}
```

### Named Parameters
Named Parameters는 명시적으로 required로 표시되지 않는 선택사항 null이 될 수 있으므로 기본값을 명시하거나 required 키워드를 붙여 필수로 만들 수 있다.
```dart
String sayHello({String name="", int age=3, required String country}) {
  return "Hello $name, you are $age, and you come from $country";
}

void main() {
  print(sayHello(
    age: 19,
    name: 'wisdom',
    country: 'cuba',
  ));
}
```

### Optional Positional Parameters
```dart
//[]로 감싼 뒤 타입에 ?붙여 nullable로 만듦. default값 명시. 안하면 null
String sayHello(String name, int age, [String? country= 'cuba']) =>
    'Hello $name, you are $age years old from $country';

void main() {
  var results = sayHello('nico', 12);
  print(results);
}
```

### QQ Operator
- A ?? B : A가 null이면 B를 return
- A ??= 'v' : A가 null이면 값을 할당
```dart
String capitalizeName(String? name) {
    return name != null ? name.toUpperCase() : 'ANON';
}

//left ?? right (left가 null이면 right를 return)
//??사용. name이 null일 수 있으므로 ?도 붙여 줌.
String capitalizeName(String? name) => name?.toUpperCase() ?? 'ANON';

void main() {
  capitalizeName('wisdom');
  capitalizeName(null);
  //??= 사용
  String? name;
  name ??= 'wisdom'; //name이 null이면 값을 넣어줌  
}
```

### typedef
```dart
typedef ListOfInts = List<int>;
ListOfInts reverseListOfNumbers(ListOfInts list) {
  var reversed = list.reversed;
  return reversed.toList();
}
void main() {
  print(reverseListOfNumbers([1, 2, 3]));
}
```

