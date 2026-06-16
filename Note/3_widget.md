# Widget

| 디자인 시스템          | 회사     | 플랫폼     |
| ---------------- | ------ | ------- |
| Material Design  | Google | Android |
| Cupertino Design | Apple  | iOS     |

## StatelessWidget Lifecycle

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

```text
생명주기: 

생성
 ↓
build()
 ↓
화면 표시
 ↓
제거

끝.
```

- 상태(State), setState(), initState(), dispose() 없음

## StatefulWidget Lifecycle

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

```text
생명주기:

Widget 생성
 ↓
createState()
 ↓
field 변수 초기화
 ↓
생성자 호출
 ↓
initState()
 ↓
build()
 ↓
화면 표시
 ↓
setState()
 ↓
build()
 ↓
setState()
 ↓
build()
 ↓
dispose()
 ↓
제거
```

### 1. initState()

```dart
@override
void initState() {
  super.initState();
}
```

- 호출 시점: 화면 생성 직후 딱 1번
- 사용 목적: Controller 생성, Listener 등록, API 호출, Animation 초기화

### 2. setState()에 대한 이해

핵심역할은 상태 변경 알림 + rebuild 요청

```dart
void _toggleObscureText() {
setState(() {
  _obscureText = false;
});
}

위와 똑같이 동작함
void _toggleObscureText() {
  _obscureText = false;

  setState(() {});
}
```

- setState가 값을 변경한다고 오해할 수 있지마 실제로는 `_obscureText = false`가 값을 변경.
- setState는 값이 변경되었으니 build 다시하라고 알려주는 역할

### 3. build()

```dart
@override
Widget build(BuildContext context) {
  return Scaffold();
}
```

- 호출 시점: 최초 생성, setState() 후 다시 호출 됨
- setState() 시 호출되므로 build() 안에는 API 호출, Listener 등록 등의 동작은 넣으면 안됨

### 4. dispose()

```dart
@override
void dispose() {
  super.dispose();
}
```

- 호출 시점: 화면 제거 직전 딱 1번
- 사용 목적: Controller 정리, Listener 제거, Animation 정리, Timer/Stream 종료

```dart
실제 예시
class UsernameScreen extends StatefulWidget {
  @override
  State<UsernameScreen> createState() =>
      _UsernameScreenState();
}

class _UsernameScreenState
    extends State<UsernameScreen> {

  final controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    print("initState");

    controller.addListener(() {
      print(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return Scaffold(
      body: TextField(
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    print("dispose");

    controller.dispose();

    super.dispose(); //모든 dispose동작 끝에 super.dispose() 호출해준다.
  }
}
```

```text
실행 흐름

화면 진입

createState
initState
build

사용자 입력

hello

리스너 실행

hello

setState()

setState(() {});

출력

build

뒤로가기

dispose
```

## BuildContext

현재 Widget이 Widget Tree에서 어디에 위치하는지 알려주는 객체

```dart
Theme.of(context)
Navigator.of(context)
MediaQuery.of(context)
ScaffoldMessenger.of(context)
```

-StatefulWidget에서 context를 바로 쓰는 이유

- `State<T>` 객체는 Flutter가 제공하는 context 프로퍼티를 가지고 있어서 어디서든 사용 가능

```dart
BuildContext get context;
```

- StatelessWidget은 context를 저장하지 않기 때문에 build나 함수 매개변수로 전달받아야 한다.

## Scaffold

화면의 기본 레이아웃 뼈대를 만들어주는 위젯

- AppBar (상단 바): 상단 헤더 영역
- Body (메인 화면): 실제 콘텐츠
- FloatingActionButton (둥둥 버튼): 오른쪽 아래 동그란 버튼
- Drawer (사이드 메뉴): 왼쪽에서 나오는 메뉴
- BottomNavigationBar (하단 탭): 하단 네비게이션
- SnackBar (알림 메시지)

## Container

여러 UI 속성을 한 번에 처리하는 종합 위젯.
여러 위젯을 한 번에 쓰는 편의용으로 성능 최적화할 때는 Padding, SizedBox 등으로 쪼개는 게 더 좋음

대표 기능들

- 크기 설정 (width, height)
- 색상 (color)
- 여백 (padding, margin)
- 정렬 (alignment)
- 테두리 (decoration)
- 자식 위젯 포함 (child)

```dart
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16), //안쪽 여백
  margin: EdgeInsets.all(10), //외부 여백
  alignment: Alignment.center, //가운데 정렬된 텍스트
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12), //둥근 모서리
  ),
  child: Text('Hello'),
)
```

## AnimatedContainer

Container의 속성이 변경될 때 자동으로 부드럽게 애니메이션을 적용해주는 Container

- 참고: child에게는 animation 효과가 적용되지 않음

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color:
        selected
          ? Colors.blue
          : Colors.grey.shade300,
    borderRadius:
        BorderRadius.circular(
          selected ? 20 : 8,
        ),
    //child에는 animation 효과 적용X. 
    //AnimatedDefaultTextStyle: Text에 animation 효과 주기 위함.
    child: const AnimatedDefaultTextStyle(
      duration: Duration(microseconds: 500),
      style: TextStyle(
         color: selected
                  ? Colors.grey.shade400
                  : Colors.white,
        fontWeight: FontWeight.w600,
      ),
      child: Text(
        'Next',
        textAlign: TextAlign.center,
      ),
    ), 
  ),
)
```

## Padding & Margin

padding = 내부 여백 (안쪽 공간). 컨텐츠와 테두리 사이 거리
margin = 외부 여백 (바깥 공간). 다른 요소와의 거리

## Color 설정

- Color(0xFFF5F5F5): 직접 색사 지정
- Colors.grey.shade100 : shade는 밝기. 숫자가 작을수록 밝음.
- backgroundColor & foregroundColor
  - backgroundColor: 배경색
  - foregroundColor: 사용자에게 보이는 콘텐츠(글자, 아이콘, 전경 요소)의 색

```dart
AppBar(
  foregroundColor: Colors.red,
)

=> 하기 요소에 red색 적용 됨
  - title 텍스트
  - 뒤로가기 버튼
  - 메뉴 아이콘
  - 액션 아이콘
```

## Expanded

Row나 Column 안에서 남는 공간을 차지하도록 만드는 위젯

```dart
화면 너비가 400이라면:
    Row(
      children: [
        Container(
          width: 100,
          color: Colors.red,
        ),
        Container(
          width: 100,
          color: Colors.blue,
        ),
      ],
    )
=> | RED 100 | BLUE 100 | 남는공간 200 |

Expanded 사용
    Row(
      children: [
        Container(
          width: 100,
          color: Colors.red,
        ),
        Expanded(
          child: Container(
            color: Colors.blue,
          ),
        ),
      ],
    )

=> | RED 100 |      BLUE 300      |
   남은 공간을 전부 가져감.


여러 개의 Expanded
    Row(
      children: [
        Expanded(
          child: Container(color: Colors.red),
        ),
        Expanded(
          child: Container(color: Colors.blue),
        ),
      ],
    )

=> | RED 50% | BLUE 50% |


flex로 비율 조절 가능
    Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(color: Colors.red),
        ),
        Expanded(
          flex: 2,
          child: Container(color: Colors.blue),
        ),
      ],
    )

=> | RED 33% |      BLUE 67%      |
   1 : 2 비율

실무에서 엄청 자주 쓰는 예: 입력창 + 버튼
    Row(
      children: [
        Expanded(
          child: TextField(),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('검색'),
        ),
      ],
    )

=> |------TextField------|[검색]|
   TextField가 남는 공간을 모두 먹음.
```

## SafeArea

노치(Notch), 상태바(Status Bar), 홈 인디케이터(Home Indicator) 같은 시스템 UI 영역을 피해서 화면을 그려주는 위젯  

```dart
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( //없을 경우 상태바를 덮어버리지만 사용할 경우 상태바 밑에 생성됨.
        child: Column(children: const [
          Text("Sign up for TikTok"),        
        ]),
      ),
    );
  }
}
```

## mainAxisAlignment & crossAxisAlignment

`mainAxisAlignment`: Row의 주축(Main Axis)은 가로 방향이고 Column은 세로 방향. mainAxisAlignment는 주축 방향의 정렬을 정함.  

`crossAxisAlignment`: Row의 주축은 가로이고 crossAxis는 세로방향이다. 즉 Row에서 설정하면 세로뱡항 정렬을 정하는 것임.

- Start: 왼쪽 정렬
- Center: 가운데 정렬
- End: 오른쪽 정렬
- spaceBetween: 전체 공간에서 구성요소의 실제 크기를 계산하고 아이템들 사이에 남는 공간을 균등 분배. 쉽게 말하면 첫 번째는 왼쪽 끝, 마지막은 오른쪽 끝으로 보내고 중간 간격을 자동으로 채운다

```dart
//center: Row의 주축 방향 가로 방향으로 가운데 정렬   
// |      A B      |
Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [
    Text('A'),
    Text('B'),
  ],
)

//spaceBetween: 
// |A           B           C|

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('A'),
    Text('B'),
    Text('C'),
  ],
)

```

## FactionallySizedBox

부모의 크기에 비례해서 크기를 정하게 해주는 위젯. widthFactor가 1이면 부모 크기와 같음. 0.5면 절반.

```dart
 @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(..,),
    );
  }
```

## Stack,Row, Column

- Row,Column은 각각 행(가로방향)과 열(세로방향)로 Widget을 쌓아 배치할 수 있게 함.
- Stack은 위로, 즉 Widget을 겹치게 배치할 수 있게 함.
- Align은 Stack안에서 개별적으로 정렬할 Widget이 있을 경우 사용

```dart
//icon과 text를 Stack으로 겹치게 배치하여 서로의 위치에 영향을 받지 않도록 함.
//Align으로 icon만 왼쪽으로 보냄
 Stack(
    alignment: Alignment.center,
    children: [
        Align(
            alignment: Alignment.centerLeft, //centerLeft: 세로는 가운데(center), 가로는 왼쪽(left)
            child: icon,
        ),
        Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
            ),
        ),
    ],
 ),
```
- Center는 child를 부모 영역의 가운데에 놓는 위젯
```dart
Scaffold(
  body: Center(
    child: CircularProgressIndicator(),
  ),
)
```

## TextField

사용자가 텍스트를 입력하는 위젯이야.

### TextField 구조

```text
TextField(
  controller: controller,
  decoration: InputDecoration(),
  keyboardType: TextInputType.text,
  obscureText: false,
  onChanged: (value) {},
)
```

```dart

final usernameController = TextEditingController();

TextField(
  decoration: InputDecoration(    
    hintText: 'Username', //입력힌트
    prefixIcon: Icon(Icons.person), //👤 Username
    suffixIcon: Icon(Icons.clear), //Username ✖
    enabledBorder: OutlineInputBorder( //평상시
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder( //
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
  ),
  controller: usernameController, //입력값을 읽을 때 사용
  onChanged: (value) { //입력할 때마다 호출
    print(value);
  },
  onEditingComplete: _onSubmit, //keyboard의 Done을 누르는 경우
  //onSubmitted: _onSubmit
  //obscureText: true, 비밀번호용. 입력이 ***표시 됨
  autocorrect: false, //오타 자동 보정 
  keyboardType: TextInputType.emailAddress, //키보드 종류 변경
  cursorColor: Colors.red, //커서 color
)

```

onEditingComplete & onSubmitted

- onEditingComplete은 값이 없음
- onSubmitted는 값을 전달 함.

```dart
//onEditingComplete은 값 없음. 현재 값을 읽으려면 _xxxController.text로 직접 읽어야 함.
onEditingComplete: () {
  _submit();
}

//onSubmitted은 값을 전달. value에 현재 입력값이 들어옴.
onSubmitted: (value) {
  print(value);
}

```

```dart
실무에서 가장 많이 쓰는 패턴
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    TextField(
      controller: emailController,
    )

    TextField(
      controller: passwordController,
      obscureText: true,
    )

    ElevatedButton(
      onPressed: () {
        print(emailController.text);
        print(passwordController.text);
      },
      child: const Text('Login'),
    )
```

```dart
예시2.
    TextField(
      decoration: InputDecoration(
        hintText: "Username", //입력창에 나오는 힌트
        //입력 필드의 언더라인에 포커스가 갔을 때도 색변화없이 동일하게 하기 위함
        //평소 언더라인
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        //focus가 갔을 때 언더라인
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
      cursorColor: Theme.of(context).primaryColor, //커서색깔
    )
```

### TextEditingController

TextEditingValue를 사용하면 TextField의 상태를 직접 제어 가능하다.

- 사용하는 경우: 전화번호 자동 포맷팅, 주민번호 포맷팅, 커서 위치 유지, 자동 완성, 텍스트 치환, 커스텀 에디터

```dart
text 사용. 보통 text만 변경하는 경우
    controller.text = "hello"; //hello로 text가 변경되고 커서가 hello 뒤로 간다.

TextEditingValue 사용
    controller.value = TextEditingValue(
      text: "hello",
      selection: TextSelection.collapsed(
        offset: 0,
      ),
    );
=> 커서를 맨 앞으로 보내는 등 TextField의 상태를 직접 제어할 수 있다.
```

## Focus Tree

Flutter에는 Focus Tree가 있고 일반적으로 하나의 FocusScope 안에서는 동시에 하나의 위젯만 Primary Focus를 가질 수 있다.

- FocusScope는 현재 화면의 Focus 관리자라고 생각하면 됨
- Primary Focus: 현재 가장 활성화된 Focus

```dart
FocusScope.of(context).unfocus(); //현재 Focus를 잃게 한다.

//현재 Focus 확인
print(
  FocusManager.instance.primaryFocus,
);

//현재 Focus 제거
FocusManager.instance.primaryFocus?.unfocus();

//다른 TextField로 이동
passwordFocusNode.requestFocus();
  예를 들어 로그인 화면에서:
  Username 입력 완료
    ↓
  Next 버튼
    ↓
 Password TextField로 Focus 이동 가능

```

## Icon & FaIcon

Icon (Flutter 기본), FaIcon (Font Awesome), IconButton (클릭 가능한 아이콘)만 알면 거의 해결된다.

### 1. Icon

Flutter 기본 제공 아이콘.

```dart
Icon(
  Icons.favorite,
  size: 30,
  color: Colors.red,
)

자주 쓰는 아이콘
검색
Icon(Icons.search)
뒤로가기
Icon(Icons.arrow_back)
닫기
Icon(Icons.close)
삭제
Icon(Icons.delete)
사용자
Icon(Icons.person)
홈
Icon(Icons.home)
설정
Icon(Icons.settings)
비밀번호 표시
Icon(Icons.visibility)
비밀번호 숨김
Icon(Icons.visibility_off)
```

### 21. FaIcon

Font Awesome 아이콘. Flutter 기본에는 없는 아이콘 제공.

```yml
dependencies:
  font_awesome_flutter: ^11.x.x
```

```dart

FaIcon(FontAwesomeIcons.github)
FaIcon(FontAwesomeIcons.google)
FaIcon(FontAwesomeIcons.apple)
FaIcon(FontAwesomeIcons.xTwitter)
FaIcon(FontAwesomeIcons.kakaoTalk)

FaIcon(
  FontAwesomeIcons.github,
  size: 30,
  color: Colors.black,
)

```

### 3. IconButton

실무에서 엄청 많이 씀. 클릭가능한 Icon

```dart
IconButton(
  icon: Icon(Icons.close),
  onPressed: () {
    Navigator.pop(context);
  },
)

TextField 실무 패턴
비밀번호 보기
TextField(
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: _togglePassword,
    ),
  ),
)
입력 삭제
TextField(
  controller: _controller,
  decoration: InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        _controller.clear();
      },
    ),
  ),
)

AppBar 실무 패턴
AppBar(
  title: const Text('Profile'),
  leading: IconButton( //appBar 제일 왼쪽에서 위치하는 Icon
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
)

TextField 예시
 TextField(
    controller: _passwordController,
    keyboardType: TextInputType.emailAddress,
    autocorrect: false,
    onEditingComplete: _onSubmit,
    decoration: InputDecoration(
      suffix: Row(
        mainAxisSize:
            MainAxisSize.min, //Row는 공간을 다 잡아먹으므로 min size로 지정. 지정하지 않으면 왼쪽에 위치할수도 있다.
        children: [
          FaIcon(
            FontAwesomeIcons.solidCircleXmark,
            color: Colors.grey.shade500,
            size: Sizes.size20,
          ),
          Gaps.h5,
          FaIcon(
            FontAwesomeIcons.eye,
            color: Colors.grey.shade500,
            size: Sizes.size20,
          ),
        ],
      ),
      ...
    );
```

## Form & TextFormField

### TextFormField

Form 검증(validation) 기능이 추가된 TextField

```ts
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    return null;
  },
)
```


## Form

여러 개의 입력창(TextFormField)을 하나의 그룹으로 묶어서 검증(validation)과 저장(save)을 관리하는 위젯

```ts
final _formKey =
    GlobalKey<FormState>(); //form 제어 위한 key 정의

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) { ... },
        onSaved: (newValue) => print(newValue),
      ),
      TextFormField(
        validator: (value) { ... };
        onSaved: (newValue) => print(newValue),
      ),
      ...
    ],
  ),
)


_formKey.currentState!.validate(); //validate()는 모든 TextFormField 검사하여 에러 표시


_formKey.currentState!.save(); //form의 모든 onSaved 실행 됨. 요즘엔 잘 안쓴다고 한다..
```

## ListView
ListView는 여러 위젯을 세로 또는 가로로 나열하고 스크롤 가능하게 만드는 위젯. 화면을 벗어나면 스크롤 가능해짐.

```dart
ListView(
  scrollDirection: Axis.horizontal,
  shrinkWrap: true,
  padding: const EdgeInsets.all(20),
  children: [
    Text('A'),
    Text('B'),
  ],
)

ListView.builder(
  itemCount: posts.length,
  itemBuilder: (context, index) {
    return Text(posts[index].title);
  },
)
```
- shrinkWrap
  - true면 ListView의 크기를 children 크기만큼만 줄임. default false로 기본적으로 ListView는 가능한 공간을 최대한 차지하려고 함.
- padding: 안쪽 여백
- scrollDirection: 스크롤 방향. default는 vertical

### ListView.separated

목록 아이템 사이에 구분선/간격/위젯을 자동으로 끼워 넣는 ListView 생성자

```dart
ListView.separated(
  itemCount: posts.length, //몇 개 만들지
  itemBuilder: (context, index) {
    final post = posts[index];

    return ListTile(
      leading: const Icon(Icons.article),
      title: Text('Post $index'),
      subtitle: const Text('This is a post preview'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        print('Post $index clicked');
      },
    );
  },
  separatorBuilder: (context, index) {
    return const Divider(); //Divider는 Flutter가 기본으로 제공하는 가로 구분선 위젯
    //return const SizedBox(height: 12); 간격만 주기
  },
)
```
- itemCount: 몇 개 만들지
- itemBuilder: 실제 리스트 아이템 만들기
- separatorBuilder: 아이템 사이에 들어갈 위젯 만들기
- ListTile
  - 기본으로 제공하는 리스트 한 줄짜리 아이템 위젯. 게시글,사용자 목록 같은 곳에서 많이 쓰임
  - leading : 왼쪽에 들어가는 위젯
  - title : 메인 텍스트
  - subtitle : 보조 텍스트
  - trailing :오른쪽에 들어가는 위젯


