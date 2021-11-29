import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:rada_egerton/services/utils.dart';
import 'package:rada_egerton/services/constants.dart';
import 'package:rada_egerton/entities/ComplaintDto.dart';

class IssueServiceProvider {
  String _hostUrl = BASE_URL;
  Dio _httpClientConn = Dio();
  final _timeOut = 10000;

  Future<Either<ComplaintDto, ErrorMessage>> createNewIssue() async {
    try {
      final result = await this._httpClientConn.get(
            "${this._hostUrl}/api/v1/admin/news",
            options: Options(
                headers: {'Authorization': ServiceUtility.getAuthToken()},
                sendTimeout: this._timeOut),
          );
      return Left(ComplaintDto.fromJson(result.data));
    } on DioError catch (e) {
      var errMsg = ServiceUtility.handleDioExceptions(e);
      return Right(errMsg);
    }
  }

}
