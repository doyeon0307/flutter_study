import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_delivery_app/common/const/data.dart';
import 'package:my_delivery_app/common/dio/dio.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/common/model/pagination_params.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = RestaurantRepository(
      dio,
      baseUrl: "http://$ip/restaurant",
    );
    return repository;
  },
);

@RestApi()
abstract class RestaurantRepository {
  // baseUrl: "http://ip/restaurant"
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // path: "http://ip/restaurant/"
  @GET("/")
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // path: "http://ip/restaurant/:id"
  @GET("/{id}")
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
