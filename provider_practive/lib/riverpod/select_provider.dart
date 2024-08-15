import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/model/shopping_item_model.dart';

// State Notifier 복기! 클래스를 만들고 provider를 만든다
final selectProvider = StateNotifierProvider<SelectNotifier,
    ShoppingItemModel>((ref) => SelectNotifier());


class SelectNotifier extends StateNotifier<ShoppingItemModel> {
  SelectNotifier()
      : super(
    ShoppingItemModel(
      name: "김치",
      quantity: 3,
      hasBought: false,
      isSpicy: true,
    ),
  );

  // 속성 하나만 변경하고 싶어도 모든 속성을 재정의해야 한다
  // 이러한 반복작업을 없애고 싶다
  // TextStyle을 copyWith 했던 것처럼
  // ShoppingItemModel에 가서 copyWith을 선언한다
  // void toggleHasBought() {
  //   state = ShoppingItemModel(
  //     name: state.name,
  //     quantity: state.quantity,
  //     hasBought: !state.hasBought,
  //     isSpicy: state.isSpicy,
  //   );
  // }

  void toggleHasBought() {
    state = state.copyWith(hasBought: !state.hasBought);
  }

  void toggleIsSpicy() {
    state = state.copyWith(isSpicy: !state.isSpicy);
  }
}