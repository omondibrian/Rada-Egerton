import '../constants.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/entities/NewsDTO.dart';
import 'package:rada_egerton/entities/locationDto.dart';

class NewsAndLocationServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  Future<Either<NewsDto, ErrorMessage>?> fetchNews() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/news",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return Left(
        NewsDto.fromJson(result.data),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<LocationsDto, ErrorMessage>?> fetchLocationPins() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/location",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return Left(LocationsDto.fromJson(result.data));
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
