import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/data/entities/NewsDTO.dart';
import 'package:rada_egerton/data/entities/locationDto.dart';
import 'package:rada_egerton/data/entities/ContactsDto.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class NewsAndLocationServiceProvider {
  final String _hostUrl = GlobalConfig.baseUrl;
  final Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  Future<Either<List<News>, ErrorMessage>> fetchNews() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
            "$_hostUrl/api/v1/admin/news",
            options: Options(
              headers: {
                'Authorization': token,
              },
              sendTimeout: _timeOut,
            ),
          );
      Iterable l = result.data["news"];
      return Left(List<News>.from(l.map((j) => News.fromJson(j))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<LocationsDto, ErrorMessage>> fetchLocationPins() async {
    String? authtoken = await ServiceUtility.getAuthToken();
    try {
      final result = await _httpClientConn.get(
            "$_hostUrl/api/v1/admin/location",
            options: Options(
                headers: {'Authorization': authtoken},
                sendTimeout: _timeOut),
          );
      return Left(
        LocationsDto.fromJson(
          result.data,
        ),
      );
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<List<Contact>, ErrorMessage>> getContacts() async {
    String? authtoken = await ServiceUtility.getAuthToken();
    try {
      final result = await _httpClientConn.get(
            "$_hostUrl/api/v1/admin/contact",
            options: Options(
                headers: {'Authorization': authtoken},
                sendTimeout: _timeOut),
          );
      Iterable l = result.data["contacts"];
      return Left(List<Contact>.from(l.map((j) => Contact.fromJson(j))));
    } on DioError catch (e) {
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }
}
