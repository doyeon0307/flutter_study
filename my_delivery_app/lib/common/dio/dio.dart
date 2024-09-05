import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_delivery_app/common/const/data.dart';
import 'package:my_delivery_app/common/secure_storage/secure_storage.dart';

final dioProvider = Provider(
  (ref) {
    final dio = Dio();

    final storage = ref.watch(secureStorageProvider);
    dio.interceptors.add(CustomInterceptor(storage: storage));

    return dio;
  },
);

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);

    print("[REQ] [${options.method}] ${options.uri}");

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    print(
        "[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}");
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    print("[ERR] [${err.requestOptions}] ${err.requestOptions.uri}");

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == "/auth/token";

    try {
      if (isStatus401 && !isPathRefresh) {
        final dio = Dio();
        final refreshToken = storage.read(key: REFRESH_TOKEN_KEY);
        final resp = await dio.post("http://$ip/auth/token",
            options: Options(headers: {
              'authorization': 'Bearer $refreshToken',
            }));
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        final response = await dio.fetch(options);

        handler.resolve(response);
      }
    } on DioError catch (e) {
      handler.reject(e);
    }
  }
}
