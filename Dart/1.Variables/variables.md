### Flutter 설치
- Mac에 설치
```shell
$ brew install flutter
$ flutter doctor
$ flutter --version
```
- VS 사용 시 flutter extension 설치
- DartPad 사용 : https://dartpad.dev/?
- 다트 문서 : https://dart.dev/guides
  
### 변수 선언
- var와 dynamic의 차이
  - var는 컴파일 타임에 타입을 추론하여 정해지면 고정, dynamic은 런타임까지 타입 체크하지 않음

```dart
var name = 'haha'; //관습적으로..함수나 메소드 내부에 지역 변수 선언할 때 var 사용
String name = 'hoho'; //class에서 변수나 property 선언할 때는 타입 지정
dynamic name = 'hihi'; //여러가지 타입을 가질 수 있는 변수 선언

var x = 'hello';
x = 'world';   // ✅ OK
x = 123;       // ❌ 컴파일 에러

dynamic y = 'hello';
y = 123;       // ✅ OK
y = true;      // ✅ OK
x.foo();       // ⚠️ 컴파일 OK, 런타임 에러



final name = 'hehe'; //변경 불가
final String name = 'hehe' //타입 같이 지정해도 됨

late final String name; //late 사용하면 데이터를 나중에 넣을 수 있음.
name = 'huhu';

//compile-time constant : 컴파일 타임에 알고 있는 변경 불가 값에 사용
const name = 'haha';

//사용자 입력으로 받거나 API호출로 받는 경우라면 final,var사용해야 함
const API = fetchAPI(); //X, final 또는 var 사용하자
```

### null safety
- 개발자가 null값을 참조할 수 없게 하는 것
- dartpad에서 `String?`과 같이 null safety 구문을 사용할 경우 에러가 나는 경우가 있다. 설정을 변경하거나 버전을 명시하자. //@dart=2.12
```dart
// @dart=2.12

String? name = 'haha'; //nullable한 경우 타입에 ? 붙임
name = null;
//print(name.length); 
if (name != null) { //nullable한 경우 변수가 null인지 확인 필요
    print(name.length);
}
print(name?.isNotEmpty); //null이 아니면 다음 연산 수행, null 출력 됨.
```


