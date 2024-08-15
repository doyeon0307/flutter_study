import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/layout/default_layout.dart';
import 'package:provider_practive/riverpod/listen_provider.dart';

// provider를 사용할 때
// stateless -> ConsumerWdiget
// stateful -> ConsumerStatefulWidget
// 아래 클래스의 State->ConsumerSate
// 사실상 Consumer만 붙여준 것
// stateful에서는 build 함수에서 두 번째 파라미터로 ref를 받지 않음
// ref는 글로벌하게 제공됨
class ListenProviderScreen extends ConsumerStatefulWidget {
  const ListenProviderScreen({super.key});

  @override
  ConsumerState<ListenProviderScreen> createState() =>
      _ListenProviderScreenState();
}

class _ListenProviderScreenState extends ConsumerState<ListenProviderScreen>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 10,
      vsync: this,
      initialIndex: ref.read(listenProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    // previous: 기존 상태, next: 다음 상태
    ref.listen<int>(
      listenProvider,
      (previous, next) {
        if (previous != next) {
          controller.animateTo(next);
        }
      },
    );

    return DefaultLayout(
      title: "Listen Provider Screen",
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: List.generate(
          10,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(index.toString()),
              ElevatedButton(
                onPressed: () {
                  ref.read(listenProvider.notifier).update(
                    (state) {
                      return state == 10 ? 10 : state + 1;
                    },
                  );
                },
                child: Text("다음"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(listenProvider.notifier).update(
                    (state) {
                      return state == 0 ? 0 : state - 1;
                    },
                  );
                },
                child: Text("뒤로"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
