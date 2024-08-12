import 'package:dio/dio.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // baseUrl: "http://ip/restaurant"
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // path: "http://ip/restaurant/"
  // @GET("/")
  // paginate();

  // path: "http://ip/restaurant/:id"
  @GET("/{id}")
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
