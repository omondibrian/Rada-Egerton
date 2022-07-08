import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/complaint_dto.dart';

class IssueServiceProvider {
  final String _hostUrl = GlobalConfig.baseUrl;
  final Dio _httpClientConn = httpClient;
  final _timeOut = 10000;
  static final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;
  // issues/category
  Future<Either<NewComplaint, ErrorMessage>> createNewIssue(
      Map<String, dynamic> data) async {
    String? authToken = GlobalConfig.instance.authToken;
    try {
      final result = await _httpClientConn.post("$_hostUrl/api/v1/issues/",
          options: Options(
              headers: {'Authorization': authToken}, sendTimeout: _timeOut),
          data: json.encode(data));

      return Left(
        NewComplaint.fromJson(result.data["newComplaint"]),
      );
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while creating a new issue',
      );
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }

  Future<Either<List<IssueCategory>, ErrorMessage>> getIssueCategories() async {
    String? authtoken = GlobalConfig.instance.authToken;
    try {
      final result = await _httpClientConn.get(
        "$_hostUrl/api/v1/issues/category",
        options: Options(
            headers: {'Authorization': authtoken}, sendTimeout: _timeOut),
      );
      Iterable l = result.data["issuesCategories"]["issueCategories"];

      return Left(
          List<IssueCategory>.from(l.map((j) => IssueCategory.fromJson(j))));
    } catch (e, stackTrace) {
      _firebaseCrashlytics.recordError(
        e,
        stackTrace,
        reason: 'Error while fetching categories of issues.',
      );
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }
}
