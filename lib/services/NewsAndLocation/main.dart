import 'package:rada_egerton/entities/NewsDTO.dart';
import 'package:rada_egerton/entities/locationDto.dart';
import 'package:rada_egerton/services/utils.dart';

import '../constants.dart';
import 'package:dio/dio.dart';

class NewsAndLocationServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  Future<NewsDto?> fetchNews() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/news",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return NewsDto.fromJson(result.data);
    } on DioError catch (e) {
      ServiceUtility.handleDioExceptions(e);
    }
  }

    Future<LocationsDto?> fetchLocationPins() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/location",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return LocationsDto.fromJson(result.data);
    } on DioError catch (e) {
      ServiceUtility.handleDioExceptions(e);
    }
  }
}
