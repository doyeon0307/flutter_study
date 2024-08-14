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
              // 버튼을 눌렀을 때 실행되는 것은 read
              // build 함수 안에서 ui에 반영하는 것은 watch
              onPressed: () {
                ref.read(numberProvider.notifier).update(
                      // state: 현재 상태
                      // 오른쪽은 반환값, 현재 상태에서 1씩 더해줌
                      (state) => state + 1,
                    );
              },
              child: Text("up"),
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
              // 버튼을 눌렀을 때 실행되는 것은 read
              // build 함수 안에서 ui에 반영하는 것은 watch
              onPressed: () {
                ref.read(numberProvider.notifier).update(
                      // state: 현재 상태
                      // 오른쪽은 반환값, 현재 상태에서 1씩 더해줌
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
