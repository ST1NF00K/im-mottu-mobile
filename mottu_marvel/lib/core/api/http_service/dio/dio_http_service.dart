import 'package:dio/dio.dart';
import 'package:mottu_marvel/core/api/http_service/http_service.dart';

class DioHttpService implements HttpService {
  late final Dio _dio;

  DioHttpService() {
    _config();
  }

  void _config() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://gateway.marvel.com/v1/public',
      queryParameters: {
        'apikey': 'c9d30f04c947cc183770e4a09c329b65',
        'hash': 'd01897be94148cae497d970c17718bbb',
        'ts': '1725329187',
      },
    ));
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
    );

    return response.data;
  }
}
