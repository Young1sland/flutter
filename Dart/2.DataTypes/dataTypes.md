### 타입은 Object다
- String, bool,int,double 등 모두 Object
- int,double은 num class를 상속받으며 num은 int,double 값 모두 가질 수 있음

### String
- 기본으로 `'`를 사용하고 문자열에 `'`를 포함해야 한다면 `"`를 사용하자.
- rawString은 escape 처리를 전부 무시하는 문자열
```dart
// 기본은 '
var title = 'Login';

// 문자열에 ' 포함 → "
var message = "It's done";

// 문자열에 " 포함 → '
var quote = 'He said "yes"';

//멀티라인 문자열
var text = """
Hello
World
""";

//rawString
print('C:\new\test'); //문제 발생: \n → 줄바꿈, \t → 탭

print(r'C:\new\test'); //C:\new\test


```

### list
```dart
var numbers = [1,2,3,4];
List<int> numbers = [1,2,3,4]; //명시적으로 선언
numbers.add(4);

var giveMeFive = true;
var numbers = [
  1,
  2,
  3,
  4,
  if (giveMeFive) 5,  //Collection if
  //끝에 쉼표 후 ;하면 세로로 줄을 나열해줌
];  
```

### String Interpolation
```dart
var name = 'wisdom';
var age = 10;
var greeting = "Hello everyone, my name is $name and I'm ${age+2}";
```

### Collection
```dart
var oldFriends = ['nico', 'lynn'];
var newFriends = [
  'lewis',
  'ralph',
  'darren',
  for (var friend in oldFriends) "new $friend", //Collection for
];
```

### Map
- Map 쓰는 경우: JSON 그대로 다룰 때, 구조가 자주 바뀔 때, 임시 데이터
- class 쓰는 경우 (권장): 비즈니스 로직, 타입 안정성 필요

```dart
var player = { //Map<String, Object>
    'name': 'nico',
    'xp': 19.99,
    'superpower': false,
  };

Map<int, bool> player = {
    1:true,
    2:true,
    3:true
};

var player1 = <String, int>{ //<String, int> 안 쓰면 Map<String, Object?>로 추론될 수 있음
  'math': 90,
  'english': 85,
};

Map<List<int>, bool> player = {
    [1,2,3,4]:true,
};

List<Map<String, Object>> players = [
    {'name': 'nico', 'xp': 1999},
    {'name': 'nico', 'xp': 1999}
];


//값이 null인 경우와 키가 없는 경우 구분 가능
if (map.containsKey('a')) {
  print(map['a']);
}

//반복(iteration)
map.forEach((key, value) {
  print('$key => $value');
});

for (final entry in map.entries) {
  print('${entry.key}: ${entry.value}');
}

//빈 Map
final map = <String, String>{};

// immutable Map
final map = const {
  'a': 1,
  'b': 2,
};
map['c'] = 3; // ❌ 런타임 에러
```

### Set
```dart
var numbers = {1, 2, 3, 4};
  //Set<int> numbers = {1, 2, 3, 4};
  numbers.add(1); //요소가 유니크하다. 추가해도 추가되지 않음
```








