import 'dart:math';

import 'package:data_class/person.dart';

void main(){
  print(mayBeFun?.(1));
}

String Function(int) fun = (n) => '$n';
String Function(int)? mayBeFun = Random().nextBool() ? fun : null;

