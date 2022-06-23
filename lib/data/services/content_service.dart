import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rada_egerton/data/entities/informationData.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ContentService {
  //information data
  static final String _hostUrl = GlobalConfig.baseUrl;
  static Future<Either<List<InformationData>, ErrorMessage>>
      getInformation() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await httpClient.get(
        "$_hostUrl/api/v1/admin/content",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable information = result.data["content"];
      return Left(List<InformationData>.from(
          information.map((data) => InformationData.fromJson(data))));
    } on DioError catch (e) {
      log(e.response.toString());
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<List<InformationCategory>, ErrorMessage>>
      getInformationCategory() async {
    try {
      String token = await ServiceUtility.getAuthToken() as String;
      final result = await httpClient.get(
        "$_hostUrl/api/v1/admin/content/category",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      log(result.data["contentCategories"]);
      Iterable informationCategory = result.data["contentCategories"];
      return Left(List<InformationCategory>.from(informationCategory.map(
          (data) =>
              InformationCategory(data["_id"].toString(), data["name"]))));
    } on DioError catch (e) {
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
