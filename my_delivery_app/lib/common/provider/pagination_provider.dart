import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/model_with_id.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';
import 'package:my_delivery_app/common/repository/base_pagination_repository.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading());

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
          final pState = state as CursorPagination<T>;
          // 갖고있는 데이터를 유지한 채로 fetching
          state = CursorPaginationFetchingMore<T>(
            meta: pState.meta,
            data: pState.data,
          );
          paginationParams = paginationParams.copyWith(
            after: pState.data.last.id,
          );
        } else {
          if (state is CursorPagination && !forceRefetch) {
            final pState = state as CursorPagination<T>;
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
          final pState = state as CursorPaginationFetchingMore<T>;

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
}
