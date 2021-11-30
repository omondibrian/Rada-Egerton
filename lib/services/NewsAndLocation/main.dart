import 'package:rada_egerton/entities/ContactsDto.dart';

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
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/news",
            options: Options(
              headers: {
                'Authorization': token,
              },
              sendTimeout: this._timeOut,
            ),
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
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/location",
            options: Options(
              headers: {
                'Authorization': token,
              },
              sendTimeout: this._timeOut,
            ),
          );
      return Left(
        LocationsDto.fromJson(
          result.data,
        ),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<ContactsDto, ErrorMessage>?> fetchContacts() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/contact",
            options: Options(
              headers: {
                'Authorization': token,
              },
              sendTimeout: this._timeOut,
            ),
          );
      return Left(
        ContactsDto.fromJson(
          result.data,
        ),
      );
    } on DioError catch (e) {
      Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
