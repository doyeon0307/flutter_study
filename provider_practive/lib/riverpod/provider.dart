import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_practive/model/shopping_item_model.dart';
import 'package:provider_practive/riverpod/state_notifier_provider.dart';

// provider 내에 provider를 쓸 때는 watch를 쓴다
// 내부 provider가 변경될 때 최상위 provider도 변경돼야 하기 때문이다
// 전에 만들었던 provider를 filterdShoppingList provider 내에 넣어주었다
final filteredShoppingListProvider = Provider<List<ShoppingItemModel>>(
  (ref) {
    final filterState = ref.watch(filterProvider);
    final shoppingListState = ref.watch(shoppingListProvider);

    if (filterState == FilterState.all) {
      return shoppingListState;
    }

    return shoppingListState
        .where(
          (element) => filterState == FilterState.spicy
              ? element.isSpicy
              : !element.isSpicy,
        )
        .toList();
  },
);

enum FilterState {
  notSpicy,
  spicy,
  all,
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState.all);
