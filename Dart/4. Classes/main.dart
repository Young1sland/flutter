enum Team { red, blue }

class Strong {
  final double strengthLevel = 1500.99;
}

class QuickRunner {
  void runQuick() {
    print("ruuuuuun!");
  }
}

class Player with Strong, QuickRunner { //Mixin 내부의 프로퍼티와 메소드를 가져 옴.
  final Team team; 

  Player({required this.team});

  void sayHello() {
    print('and I play for ${team}');
  }
}
class Horse with Strong, QuickRunner {}

void main() {
  var player = Player(team: Team.red);
}
