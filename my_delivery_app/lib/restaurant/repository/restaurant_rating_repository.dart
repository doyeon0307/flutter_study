import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/const/data.dart';
import 'package:my_delivery_app/common/dio/dio.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';
import 'package:my_delivery_app/common/repository/base_pagination_repository.dart';
import 'package:my_delivery_app/rating/model/rating_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

// url 자체에 변수(rid)가 있음 -> family
final RestaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>(
  (ref, arg) {
    final dio = ref.watch(dioProvider);
    return RestaurantRatingRepository(dio, baseUrl: "http://$ip/restaurant/$arg/rating");
  },
);

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository extends IBasePaginationRepository<RatingModel>{
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET("/")
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
