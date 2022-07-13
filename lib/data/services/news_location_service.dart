import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/data/entities/news_dto.dart';
import 'package:rada_egerton/data/entities/location_dto.dart';
import 'package:rada_egerton/data/entities/contacts_dto.dart';
import 'package:rada_egerton/resources/utils/main.dart';

class NewsAndLocationServiceProvider {
  final String _hostUrl = GlobalConfig.baseUrl;
  final Dio _httpClientConn = Dio();
  final _timeOut = 10000;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  Future<Either<List<News>, ErrorMessage>> fetchNews() async {
    try {
      String token = GlobalConfig.instance.authToken;
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
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching news',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<LocationsDto, ErrorMessage>> fetchLocationPins() async {
    String? authtoken = GlobalConfig.instance.authToken;
    try {
      // final result = await _httpClientConn.get(
      //   "$_hostUrl/api/v1/admin/location",
      //   options: Options(
      //       headers: {'Authorization': authtoken}, sendTimeout: _timeOut),
      // );
      //todo: revert back to fetching from derver when backend is populated
      final result = await rootBundle.loadString('assets/locations.json');
      return Left(
        LocationsDto.fromJson(jsonDecode(result)),
        //todo: revert this too
        // result.data,
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching location pins',
      );
      return Right(
        ServiceUtility.handleDioExceptions(e),
      );
    }
  }

  Future<Either<List<Contact>, ErrorMessage>> getContacts(
      {Function(String)? retryLog}) async {
    String? authtoken = GlobalConfig.instance.authToken;
    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, logPrint: retryLog),
    );
    try {
        final result = await dio.get(
          "$_hostUrl/api/v1/admin/contact",
          options: Options(
              headers: {'Authorization': authtoken}, sendTimeout: _timeOut),
        );
      Iterable l = result.data["contacts"];
      return Left(List<Contact>.from(l.map((j) => Contact.fromJson(j))));
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching contacts details',
      );
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }
}
