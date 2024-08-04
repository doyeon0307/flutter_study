import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_delivery_app/common/const/data.dart';
import 'package:my_delivery_app/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );
    print('${resp.data['data']}');
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List>(
          future: paginateRestaurant(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return RestaurantCard(
                  image: Image.network(
                    'http://$ip/${item['thumbUrl']}',
                    fit: BoxFit.cover,),
                  name: item['name'],
                  tags: List<String>.from(item['tags']),
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['deliveryTime'],
                  deliveryFee: item['deliveryFee'],
                  ratings: item['ratings'],
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
