import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/random_advice/random_advice_cubit.dart';

class RandomAdvicePage extends StatelessWidget {
  const RandomAdvicePage({
    super.key,
  }); //부모 Widget의 key parameter를 자동 전달하는 최신 Dart 축약 문법

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Advice')),
      body: Center(
        child: BlocBuilder<RandomAdviceCubit, String>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                state,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RandomAdviceCubit>().getRandomAdvice();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
