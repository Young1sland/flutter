# Widget

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

## Padding & Margin

padding = 내부 여백 (안쪽 공간). 컨텐츠와 테두리 사이 거리
margin = 외부 여백 (바깥 공간). 다른 요소와의 거리
