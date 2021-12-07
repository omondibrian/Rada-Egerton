import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/entities/NewsDTO.dart';
import 'package:rada_egerton/entities/locationDto.dart';
import 'package:rada_egerton/entities/ContactsDto.dart';

class NewsAndLocationServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  Future<Either<List<News>, ErrorMessage>> fetchNews() async {
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
      Iterable l = result.data["news"];
      return Left(List<News>.from(l.map((j) => News.fromJson(j))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<LocationsDto, ErrorMessage>> fetchLocationPins() async {
    String? _authtoken = await ServiceUtility.getAuthToken();
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/location",
            options: Options(
                headers: {'Authorization': _authtoken},
                sendTimeout: this._timeOut),
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
    String? _authtoken = await ServiceUtility.getAuthToken();
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/contact",
            options: Options(
                headers: {'Authorization': _authtoken},
                sendTimeout: this._timeOut),
          );
      Iterable l = result.data["contacts"];
      return Left(List<Contact>.from(l.map((j) => Contact.fromJson(j))));
    } on DioError catch (e) {
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }
}
