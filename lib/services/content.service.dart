import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rada_egerton/constants.dart';
import 'package:rada_egerton/entities/informationData.dart';
import 'package:rada_egerton/utils/main.dart';

class ContentService {
  //information data
  static Future<Either<List<InformationData>, ErrorMessage>>
      getInformation() async {
    String _hostUrl = BASE_URL;
    Dio _httpClientConn = Dio();
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/content",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable _information = result.data;
      return Left(List<InformationData>.from(
          _information.map((data) => InformationData.fromJson(data))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<List<InformationCategory>, ErrorMessage>>
      getInformationCategory() async {
    String _hostUrl = BASE_URL;
    Dio _httpClientConn = Dio();
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await _httpClientConn.get(
        "$_hostUrl/rada/api/v1/content",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable _informationCategory = result.data;
      return Left(List<InformationCategory>.from(_informationCategory
          .map((data) => InformationCategory(data["id"], data["name"]))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
