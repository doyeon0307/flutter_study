import 'package:dio/dio.dart' hide Headers;
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // baseUrl: "http://ip/restaurant"
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // path: "http://ip/restaurant/"
  @GET("/")
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();

  // path: "http://ip/restaurant/:id"
  @GET("/{id}")
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}