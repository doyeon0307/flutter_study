import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';
import 'package:my_delivery_app/restaurant/repository/restaurant_repository.dart';

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

  paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    // 강제로 재로딩
    // true -> CursorPaginationLoading
    bool forceRefetch = false,
  }) async {
    try {
      {
        // [1] CursorPagination-정상적으로 데이터가 있는 상태
        // [2] CursorPaginationLoading-데이터 로딩 상태 (현재 캐시 없음)
        // [3] CursorPaginationError
        // [4] CursorPaginationRefetching-첫번째부터 데이터 다시 가져옴
        // [5] CursorPaginationFetchMore-추가 데이터 pagination 요청 받음

        // [1]
        // 바로 반환하는 상황
        // 1. hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
        //    어차피 불러올 데이터가 없음
        // 2. 로딩중 - fetchMore = true
        //    fetchMore가 아닐 때 - 새로고침의 의도가 있을 수 있으니 pagination 실행

        // [1] 1. 이미 데이터를 갖고 있는 상황
        if (state is CursorPagination && !forceRefetch) {
          final pstate = state as CursorPagination;
          if (!pstate.meta.hasMore) {
            return;
          }
        }

        // [1] 2. fetchMore이고 로딩중
        final isLoading = state is CursorPaginationLoading;
        final isRefetching = state is CursorPaginationRefetching;
        final isFetchingMore = state is CursorPaginationFetchingMore;

        if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
          return;
        }

        // pagination params 생성
        PaginationParams paginationParams = PaginationParams(
          count: fetchCount,
        );

        // fetchMore
        // 데이터를 추가로 더 가져오는 상황
        // fetchMore 자체가 이미 화면에 데이터가 보여지는 상황임
        // 이미 데이터를 들고 있는 상황이므로 CursorPagination임
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

          final resp = await repository.paginate(
            paginationParams: paginationParams,
          );

          if (state is CursorPaginationFetchingMore) {
            final pState = state as CursorPaginationFetchingMore;

            state = resp.copyWith(data: [
              // 기존 데이터
              ...pState.data,
              // 새로운 데이터
              ...resp.data,
            ]);
          } else {
            state = resp;
          }
        }
        // 데이터를 처음부터 가져오는 상황
        // 기존 데이터를 보유한 채로 Fetch(API 요청) 진행
        else {
          if (state is CursorPagination && !forceRefetch) {
            final pState = state as CursorPagination;
            state = CursorPaginationRefetching(
              meta: pState.meta,
              data: pState.data,
            );
          } else {
            state = CursorPaginationLoading();
          }
        }
      }
    } catch (e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다");
    }
  }
}
