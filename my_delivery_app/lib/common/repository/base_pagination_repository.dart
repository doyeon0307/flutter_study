// 클래스로 interface 만들기

import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/model_with_id.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  // T: repository model
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}