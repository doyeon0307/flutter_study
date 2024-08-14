import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_delivery_app/common/const/data.dart';
import 'package:my_delivery_app/common/dio/dio.dart';
import 'package:my_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:my_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:my_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:my_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:my_delivery_app/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final repository = RestaurantRepository(
      dio,
      baseUrl: "http://$ip/restaurant",
    );

    final resp = await repository.paginate();
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
          future: paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RestaurantDetailScreen(
                            id: item.id,
                          );
                        },
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(model: item),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20.0);
              },
            );
          },
        ),
      ),
    );
  }
}
