import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/model/shopping_item_model.dart';

// 2. 아래에 정의한 Notifier를 위젯에서 사용하기 위해 Provider로 만든다
// Generic에 State Notifier를 상속한 클래스,
//    State Notifier가 관리하는 데이터 타입 두 가지를 넣어준다
  final shoppingListProvider =
      StateNotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>(
    (ref) => ShoppingListNotifier(),
  );

// 1. Notifier를 Class로 정의한다
// 클래스는 반드시 StateNotifier를 상속한다
// StateNotifier는 관리할 데이터의 타입을 명시해야 한다
class ShoppingListNotifier extends StateNotifier<List<ShoppingItemModel>> {
  ShoppingListNotifier()
      :
        // super에는 처음에 어떤 값으로 상태를 초기화할 지 넣어준다
        // StateNotifier에 적어준 타입과 일치하는 데이터를 넣는다
        // List<ShoppingItemModel>이므로 빈 리스트를 넣어도 된다
        super([
          ShoppingItemModel(
            name: "김치",
            quantity: 3,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: "라면",
            quantity: 5,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: "삼겹살",
            quantity: 10,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: "수박",
            quantity: 2,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: "카스테라",
            quantity: 5,
            hasBought: false,
            isSpicy: false,
          ),
        ]);

  // 클래스 안에서 복잡한 상태를 관리하므로 메서드를 사용한다
  void toggleHasBought({required String name}) {
    // super constructor로 초기화한 값이 state에 들어있다
    // name 파라미터의 값과 일치하면 hasBought의 bool값을 반대로 한다
    state = state
        .map((e) => e.name == name
            ? ShoppingItemModel(
                name: e.name,
                quantity: e.quantity,
                hasBought: !e.hasBought,
                isSpicy: e.isSpicy,
              )
            : e)
        .toList();
  }
}
