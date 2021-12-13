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
        "$_hostUrl/api/v1/admin/content",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable _information = result.data["content"];
      print(_information);
      return Left(List<InformationData>.from(
          _information.map((data) => InformationData.fromJson(data))));
    } on DioError catch (e) {
      print(e.response);
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
        "$_hostUrl/api/v1/admin/content/category",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      print(result.data["contentCategories"]);
      Iterable _informationCategory = result.data["contentCategories"];
      return Left(List<InformationCategory>.from(_informationCategory.map(
          (data) => InformationCategory(data["_id"].toString(), data["name"]))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
