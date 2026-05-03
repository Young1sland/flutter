# Basic

## Project 설정
```sh
flutter create first_app
```

### 1. Extension 설치
#### (1) Dart Data Class Generator & Equatable
데이터 모델 클래스를 자동으로 만들어주는 Extenstion. Ricardo가 가장 최근에 업데이트 되었으므로 이걸 설치.
```sh
# data_class라는 Dart 프로젝트(패키지)를 생성
dart create data_class

# 객체를 값 기준으로 비교하도록 해주는 package
dart pub add equatable
```
- 왼쪽 하단의 Setting -> equatable 검색 true 설정
```text
Dart-data-class-generator: Use Equatable
If true, uses equatable for value equality and hashcode.
```
- data class 생성 시 기본으로 Generate toString, CopyWith, Equatable 해주자
```sh
dart create data_class
```

#### (2) 그 외 extension
- bloc: bloc쓰면 설치. bloc 패키지를 사용하는데 필요한 많은 보일러 플레이트 코드를 쉽게 만들 수 있게 해줌. 
- freezed extension: Freezed 코드를 쉽게 작성하게 도와주는 에디터 플러그인
- Error Lens by Alexander: 에러, 오류 및 기타 언어 진단 사항 하이라이트
- yaml: yaml언어 지원
- DotENV by mkiestead: dotenv 파일 문법 지원
- Image Preview by Kiss Tamas: 이미지 미리 보기를 에디터의 gutter와 마우스를 올릴 때 표시
- Remove Comments by plibither8: 모든 코멘트,라인 코멘트 제거

### 2. formatter & lint
마지막 콤마에 줄 바꿈하기

analysis_options.yaml
```yaml
formatter:
  trailing_commas: preserve

# 그 외
linter:
  rules:
    prefer_const_constructors: true # constructor가 위에 위치
    prefer_const_literals_to_create_immutables: true # 가능하면 const를 쓰라는 경고
    avoid_print: false # print 사용 시 경고 안함
    prefer_final_fields: true # 불변 필드는 final 
    always_use_package_imports: true # 상대경로 대신 package import 쓰기
    avoid_unnecessary_containers: true
    use_key_in_widget_constructors: true # 위젯 생성자에 Key 넣으라는 규칙
```
- 수동 formatting: format document (Shift + Alt + F)
- use_key_in_widget_constructors: 
  - 위젯 생성자에 Key 넣으라는 규칙
```dart
// ❌
class MyWidget extends StatelessWidget {
  MyWidget();
}

// ✅
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
}
```

### 실행
- F5 : 디버그 실행
- Ctrl + F5: 디버깅 없이 실행

## Widget Catalog

https://docs.flutter.dev/ui/widgets

