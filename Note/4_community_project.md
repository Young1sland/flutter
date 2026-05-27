# Community Project

## 1. Project Setup

### 1) 재사용 가능한 패키지 생성

```sh
flutter create --template=package package_name
```

- flutter create는 실행가능한 앱 생성. flutter run 가능
  
  ```text
  생성결과 예시
    my_app/
    ├─ lib/
    │   └─ main.dart
    ├─ android/
    ├─ ios/
    └─ pubspec.yaml
  ```

- flutter create --template=package는 재사용 가능한 패키지 생성함.

    ```text
    생성결과 예시
        my_app/
        ├─ lib/
        │   └─ main.dart
        ├─ android/
        ├─ ios/
        └─ pubspec.yaml
    ```

```sh
# packages 폴더 생성 후 폴더에서..
flutter create --template=package core
flutter create --template=package domain
flutter create --template=package data_supabase

# root 폴더에서서 생성.
flutter create bloc_app
flutter create provider_app
flutter create riverpod_app
```

### 2) pubspec.yaml

- publish_to
  - package(create --template=package)는 원래 publish 가능.

    ```sh
    dart pub publish # 배포 명령
    ```

  - 대부분 개발 시 package는 사내용도이므로 배포하지 않게 위해 none 설정해둔다.
  
    ```yaml
    publish_to: "none" # pub.dev에 배포하지 않겠다.
    ```

- homepage: 패키지가 pub.dev 같은 저장소에 배포될 떄 패키지의 홈페이지 지정
- dependencies

  - 대부분의 경우 ^ 사용.
  
    ```yaml
    dio: ^5.8.0
    ```

  - 의미는 `>=5.8.0 <6.0.0`. 즉 5.x 업데이트 허용. 6.0은 금지
  - 실제 설치 버전은 pubspec.lock에 고정 됨
  - package 업데이트

    ```sh
    # 현재 가능한 업데이트 확인
    flutter pub outdated

    # 업데이트
    flutter pub upgrade # 현재 major version은 유지 됨.

    # major까지 강제
    flutter pub upgrade --major-versions

    ```

  - local폴더로 path 지정
  
    ```yaml
    dependencies:
        core:
            path: ../core
    ```

    - pub.dev에서 다운로드 하지 말고 로컬 폴더에 있는 core package 직접 사용

### 3) 폴더 구조

- packages 프로젝트에서 lib/src 폴더 생성. 변경가능한 내부 구현을 포함.
- 패키지 명과 같은 lib/package_name.dart는 외부 노출. 노출 함수가 많은 경우 파일을 분리.
- barrel 파일: 총알(barrel)에 여러 탄약 넣듯이 여러 export를 한곳에서 모아주는 파일
  
  ```text
  my_app/
    ├─ lib/
    │   └─ src/
    |       └─ constants/
    |             └─ app_contants.dart
    |             └─ contants.dart(barrel 파일)     - export 'app_constants.dart';
    |       └─ errors/
    |             └─ errors.dart(barrel 파일)       - export 'exceptions.dart'; 
    |                                              - export 'failures.dart';
    |             └─ exceptions.dart
    |             └─ failure.dart
    |             
    |
    └─ constants.dart
    └─ errors.dart

### 4) packages 폴더 내 패키지 설정

- core 패키지

  ```sh
  # core 패키지 폴더에서 equatlab fppart 설치
  flutter pub add equatable fpdart
  ```

- domain 패키지

  ```sh
  flutter pub add equatable fpdart

  ```

  ```yaml
  publish_to: "none"

  dependencies:
    equatable: ^2.0.8
    flutter:
        sdk: flutter
    fpdart: ^1.2.0
    core:
        path: ../core # core 패키지를 pub.dev에서 다운로드하지 말고 local의 core path를 사용
  ```

- data_supabase 패키지
  
  ```sh
  flutter pub add equatable fpdart json_annotation supabase_flutter uuid
  flutter pub add --dev build_runner json_serializable

  ```

  ```yaml
  dependecies:
    core:
      path: ../core
    domain:
      path: ../domain
  ```

### 5) analysis options

정적 분석(static analysis) 설정 파일  
packages의 analysis_options.yaml에 모두 적용

```yaml
include: package:flutter_lints/flutter.yaml # flutter팀이 권장하는 규칙

analyzer: 
  exclude: 
    - build/**
    - .dart_tool/**
    - lib/generated_plugin_registrant.dart
    - test/**.mocks.dart
    - "**/*.g.dart"
    - "**.config.dart"

linter: 
  rules:
    avoid_print: false
    no_leading_underscores_for_local_identifiers: false
    omit_local_variable_types: false # local 변수 타입 생략하지 말 것
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true    
    prefer_final_fields: true
    prefer_final_in_for_each: true
    prefer_relative_imports: true # relative import 스타일
    sort_constructors_first: true
    unawaited_futures: true # Future를 반환하는 함수를 호출 시 await 안 하면 warning
```

- relative import 사용하고자 할 경우
  - `import '../models/user.dart'`;

  ```yaml
  prefer_relative_imports: true
  ```

- package import 스타일 사용하고자 할 경우
  - monorepo에서 좀 더 선호되는 스타일
  - `import 'package:app/models/user.dart';`

  ```yaml
  prefer_relative_imports: false
  always_use_package_imports: true
  ```

### 6) supabase

오픈소스 firebase 대체재로 Firebase + PostgreSQL + Backend Toolkit  
<https://supabase.com/>

- project 생성 후 Connect에서 flutter로 변경해서 example보거나 API Keys 참고
- .env에 추가. .gitignore에 *.env 추가. (.env로 끝나는 모든 파일 대상)
password: mk.pjnE@k+b2-jE

### 7) Bloc App

#### (1) pubspec.yaml
  
  ```yaml
  dependencies:
    supabase_flutter: ^2.10.3
    flutter_dotenv: ^6.0.0

    # State Mangement
    get_it: ^8.2.0
    injectable: ^2.5.2
    bloc: ^9.1.0
    flutter_bloc: ^9.1.1

    # Routing
    go_router: ^16.3.0

    # Data Class & Functional Programming
    equatable: ^2.0.7
    fpdart: ^1.1.1

    # UI & Utilities
    cached_network_image: ^3.4.1
    image_picker: ^1.2.0
    intl: ^0.20.2
    uuid: ^4.5.1
    string_validator: ^1.2.0
    stream_transform: ^2.1.1

    core:
      path: ../packages/core
    domain:
      path: ../packages/domain
    data_supabase:
      path: ../packages/data_supabase
  
  dev_dependencies:
    flutter_test:
      sdk: flutter
    
    flutter_lints: ^5.0.0
    build_runner: ^2.10.1
    injectable_generator: ^2.9.0
  
  flutter:
    uses-material-design: true
    assets:
      - .env

  ```

- image_picker
  - 갤러리/카메라 이미지 선택. 카메라/동영상 촬용 기능 제공
  - IOS에 권한 설정 필요. 안 넣으면 앱 Crash 발생
    ios/Runner/Info.plist

    ```xml
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Need permission for the photo library</string>

    <key>NSCameraUsageDescription</key>
    <string>Need permission for the camera</string>

    <!-- 영상 녹화 기능이 있다면 -->
    <key>NSMicrophoneUsageDescription</key>
    <string>Need permission for the microphone</string>
    ```

- get_it
  - Service Locator. 전역 객체 등록소
  - Flutter/Dart용 가벼운 DI(Service Locator) 라이브러리
  - get_it + Bloc조합으로 많이 사용. 그러나 Riverpod은 단독으로 가능

#### (2) main.dart에 환경변수 loading
  
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  void main() async {
    //Flutter 엔진/Widget 시스템 초기화를 먼저 보장하는 코드, main에서 Flutter 관련 async 작업할 때 필요
    WidgetsFlutterBinding.ensureInitialized(); 
    await dotenv.load(fileName: '.env');

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    configureDependencies(); //DI(Dependency Injection) 초기화 함수. DI container 등록

    runApp(const MyApp());
  }
  ```

#### (3) DI injectable 설정

lib/core/di/di.dart

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

```

di.config.dart 생성

```sh
# 코드 자동 생성기를 계속 감시 모드로 실행. 피일 변경 감시. 수정될 때마다 자동 재생성
# -d: --delete-conflicting-outputs, 기존 generated 파일 충돌 시 자동 삭제
dart run build_runner watch -d 
```

lib/core/di/register_module.dart

```dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

```
