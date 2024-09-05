import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingStateNotifier
    extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({required this.repository})
      : super(
          CursorPaginationLoading(),
        );


}
