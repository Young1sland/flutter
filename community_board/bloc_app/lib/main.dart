import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Flutter 엔진/Widget 시스템 초기화를 먼저 보장하는 코드, main에서 Flutter 관련 async 작업할 때 필요
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  configureDependencies(); //DI(Dependency Injection) 초기화 함수. DI container 등록

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Board Bloc',
      debugShowCheckedModeBanner: false, //오른쪽 위에 뜨는 debug 배너 안뜨게 설정
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const Scaffold(
        body: Center(child: Text('Project Setup Completed!')),
      ),
    );
  }
}
