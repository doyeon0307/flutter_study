import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/layout/default_layout.dart';
import 'package:provider_practive/riverpod/state_provider_screen.dart';

// ConsumerWidget을 상속받는다
class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({super.key});

  @override
  // StatlessWidget과 ConsumerWidget의 유일한 차이점은
  // build의 파라미터로 WidgetRef를 받는 점이다
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: 특정 provider를 바라보다가 그 provider가 변경되면 빌드해라
    final provider = ref.watch(numberProvider);

    return DefaultLayout(
      title: "State Provider Screen",
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update(
                      (state) => state + 1,
                    );
              },
              child: Text("up"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).state =
                    ref.read(numberProvider.notifier).state - 1;
              },
              child: Text("down"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _NextScreen(),
              )),
              child: Text("Next Screen"),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvider);

    return DefaultLayout(
      title: "Next Provider Screen",
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update(
                      (state) => state + 1,
                    );
              },
              child: Text("up"),
            ),
          ],
        ),
      ),
    );
  }
}
