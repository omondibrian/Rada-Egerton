import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/utils/main.dart';
import 'package:rada_egerton/data/entities/ComplaintDto.dart';

class IssueServiceProvider {
  final String _hostUrl = GlobalConfig.baseUrl;
  final Dio _httpClientConn = httpClient;
  final _timeOut = 10000;
  // issues/category
  Future<Either<ComplaintDto, ErrorMessage>> createNewIssue(
      Map<String, dynamic> data) async {
    String? authToken = await ServiceUtility.getAuthToken();
    try {
      final result = await _httpClientConn.post(
          "${_hostUrl}/api/v1/issues/",
          options: Options(
              headers: {'Authorization': authToken},
              sendTimeout: _timeOut),
          data: json.encode(data));

      return Left(ComplaintDto.fromJson(result.data));
    } on DioError catch (e) {
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }

  Future<Either<List<IssueCategory>, ErrorMessage>> getIssueCategories() async {
    String? _authtoken = await ServiceUtility.getAuthToken();
    try {
      final result = await _httpClientConn.get(
            "${_hostUrl}/api/v1/issues/category",
            options: Options(
                headers: {'Authorization': _authtoken},
                sendTimeout: _timeOut),
          );
      Iterable l = result.data["issuesCategories"]["issueCategories"];

      return Left(
          List<IssueCategory>.from(l.map((j) => IssueCategory.fromJson(j))));
    } on DioError catch (e) {
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }
}