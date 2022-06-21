import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/resources/config.dart';
import 'package:rada_egerton/resources/constants.dart';
import 'package:rada_egerton/utils/main.dart';
import 'package:rada_egerton/entities/ComplaintDto.dart';

class IssueServiceProvider {
  String _hostUrl = GlobalConfig.baseUrl;
  Dio _httpClientConn = GlobalConfig.httpClient;
  final _timeOut = 10000;
  // issues/category
  Future<Either<ComplaintDto, ErrorMessage>> createNewIssue(
      Map<String, dynamic> data) async {
    String? authToken = await ServiceUtility.getAuthToken();
    try {
      final result = await this._httpClientConn.post(
          "${this._hostUrl}/api/v1/issues/",
          options: Options(
              headers: {'Authorization': authToken},
              sendTimeout: this._timeOut),
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
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/issues/category",
            options: Options(
                headers: {'Authorization': _authtoken},
                sendTimeout: this._timeOut),
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
