import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:my_delivery_app/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  // CursorPagination이 아니다 = 데이터가 없다 = 캐싱할게 없음
  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere(
    (element) => element.id == id,
  );
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future paginate({
    int fetchCount = 20,
    // 데이터 추가로 가져오기
    // true -> 새로운 데이터 가져옴
    // false -> 새로고침 (헌재 데이터 다시 가져와 덮어씀)
    bool fetchMore = false,
    // 강제로 재로딩
    // true -> CursorPaginationLoading 상태로 만듦
    bool forceRefetch = false,
  }) async {
    try {
      {
        if (state is CursorPagination && !forceRefetch) {
          final pstate = state as CursorPagination;
          if (!pstate.meta.hasMore) {
            return;
          }
        }

        final isLoading = state is CursorPaginationLoading;
        final isRefetching = state is CursorPaginationRefetching;
        final isFetchingMore = state is CursorPaginationFetchingMore;

        if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
          return;
        }

        PaginationParams paginationParams = PaginationParams(
          count: fetchCount,
        );

        if (fetchMore) {
          final pState = state as CursorPagination;
          // 갖고있는 데이터를 유지한 채로 fetching
          state = CursorPaginationFetchingMore(
            meta: pState.meta,
            data: pState.data,
          );
          paginationParams = paginationParams.copyWith(
            after: pState.data.last.id,
          );
        }
        else {
          if (state is CursorPagination && !forceRefetch) {
            final pState = state as CursorPagination;
            state = CursorPaginationRefetching(
                meta: pState.meta, data: pState.data);
          } else {
            state = CursorPaginationLoading();
          }
        }

        final resp = await repository.paginate(
          paginationParams: paginationParams,
        );

        if (state is CursorPaginationFetchingMore) {
          final pState = state as CursorPaginationFetchingMore;

          state = resp.copyWith(
            data: [
              ...pState.data,
              ...resp.data,
            ],
          );
        } else {
          state = resp;
        }
      }
    } catch (e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다");
    }
  }

  Future<void> getDetail({
    required String id,
  }) async {
    // 만약 데이터가 하나도 없는 상태라면
    // 데이터를 가져오는 시도를 한다
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 여전히 CursorPagination이 아니라면
    if (state is! CursorPagination) {
      return;
    }
    // 예외 처리 끝

    // 캐스팅
    final pState = state as CursorPagination;

    // 데이터 요청
    final resp = await repository.getRestaurantDetail(id: id);
    // 요청한 데이터로 detail data(state) 업데이트
    // paginate로 가져온 데이터가 지금 state에 List로 있잖아?
    // 이 중에서 detail을 요청한 id와 일치하는 것을 찾아 바꿈
    // detail을 요청한 RestaurantModel은 resp로 받은 DetailModel로 바꾸어준다
    // getDetail(id: 1)이라면 restaurant provider의 state는 다음과 같다
    // [Model(1), DetailModel(2), Model(3)]
    // DetailModel이 Model을 상속받기 때문에 가능하다
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}
