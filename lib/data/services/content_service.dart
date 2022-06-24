import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/data/entities/informationData.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class ContentService {
  //information data
  static final String _hostUrl = GlobalConfig.baseUrl;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;
  static Future<Either<List<InformationData>, ErrorMessage>>
      getInformation() async {
    try {
      String token = GlobalConfig.instance.authToken;
      final result = await httpClient.get(
        "$_hostUrl/api/v1/admin/content",
        options: Options(headers: {
          'Authorization': token,
        }, sendTimeout: 10000),
      );
      Iterable information = result.data["content"];
      return Left(List<InformationData>.from(
          information.map((data) => InformationData.fromJson(data))));
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching content data',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  static Future<Either<List<InformationCategory>, ErrorMessage>>
      getInformationCategory() async {
    try {
      String token = GlobalConfig.instance.authToken;
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
    } on Exception catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching categories of the content data',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }
}
