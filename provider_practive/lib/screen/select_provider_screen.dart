import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/layout/default_layout.dart';
import 'package:provider_practive/riverpod/select_provider.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');
    // final state = ref.watch(selectProvider);

    // HasBought에는 관심이 없고 IsSpicy가 눌렸을 때만 빌드하고 싶다면
    // 원래는 state 전체, 즉 ShoppingItemModel을 관리했음
    // 이제는 state의 value를 isSpicy라는 속성 하나로 한정시킴
    // state는 isSpicy라는 boolean 변수가 된 것!
    final state = ref.watch(
      selectProvider.select(
        (value) => value.isSpicy,
      ),
    );

    // wathch를 listen에도 똑같이 적용할 수 있음
    ref.listen(
      selectProvider.select(
        (value) => value.hasBought,
      ),
      (previous, next) => print('next: $next'),
    );

    return DefaultLayout(
      title: "Select Provider Screen",
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(state.toString()),
            // Text(state.name),
            // Text(state.isSpicy.toString()),
            // Text(state.hasBought.toString()),
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleIsSpicy();
              },
              child: Text("Spicy Toggle"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(selectProvider.notifier).toggleHasBought();
              },
              child: Text("Has Bought Toggle"),
            ),
          ],
        ),
      ),
    );
  }
}
